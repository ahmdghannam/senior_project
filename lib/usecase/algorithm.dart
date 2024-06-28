import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_course_project/model/Dto/CseCourse.dart';
import 'package:flutter_course_project/model/Dto/UICourse.dart';
import 'package:flutter_course_project/model/exelFiles/ReadCoursesFromCSV.dart';
import 'package:flutter_course_project/model/localDatabase/sharedPrefferences.dart';
import 'package:flutter/material.dart';
// 3 things to update: remove the children from neededCourses, add open/close to database, .... and ?
import '../model/Dto/Section.dart';
import '../model/Dto/FirebaseCourse.dart';
// import '../model/Dto/LectureTime.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
  String toStringConvert() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(hour);
    final String minuteLabel = addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }
}

Future<List<FirebaseCourse>> getFalseStatusCourses(String studentId) async {
  List<FirebaseCourse> falseStatusCourses = [];

  try {
    // Retrieve the student document from the 'student-course' collection
    DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection('student-course')
        .doc(studentId)
        .get();

    if (studentSnapshot.exists) {
      // Get the 'courses' map from the student document
      Map<String, dynamic> coursesMap = studentSnapshot['courses'];

      // Iterate through the coursesMap and check for false status
      coursesMap.forEach((code, isPassed) {
        if (isPassed == false) {
          falseStatusCourses.add(FirebaseCourse(code, isPassed));
        }
      });
    }
  } catch (e) {
    print('Error retrieving false status courses: $e');
  }

  return falseStatusCourses;
}
List<CseCourse> getNeededCourses(List<CseCourse>? cseCourses, List<FirebaseCourse> notFinishedCourses) {
  if (cseCourses == null) return [];

  return cseCourses
      .where((cseCourse) => notFinishedCourses.any((notFininshed) =>
  notFininshed.code.trim() == cseCourse.courseId.trim()))
      .toList(); // join
}
List<CseCourse> sortCourses(List<CseCourse> courses) {
  // Sort courses based on the calculated weight
  courses.sort((a, b) {
    int weightA = calculateCourseWeight(a);
    int weightB = calculateCourseWeight(b);

    // Sort in reverse order (big to small weight)
    return weightA.compareTo(weightB);
  });

  return courses;
}
int calculateCourseWeight(CseCourse course) {
  // Function to calculate the weight for each course based on default semester and prerequisites
  // Adjust the formula based on your specific weighting criteria
  return course.defaultSemester + course.childrenCount;
}

Future<List<UICourse>> getSuggestedCourses(String start, String end, String chosenHours) async {
  // The University Schedule sections,
  List<Section>? sections = await loadAvailableSections();

  // The Major Courses with it's details
  List<CseCourse>? cseCourses = await loadAllCseCourses();

  // Get the needed courses ( the allowed courses to be registered (not finished yet) )
  String? userId = await getUserID();
  if (userId == null) {
    return throw "user id not found";
  }
  List<FirebaseCourse> notFinishedCourses = await getFalseStatusCourses(userId);
  List<CseCourse> neededCourses = getNeededCourses(cseCourses, notFinishedCourses); //join
  neededCourses = sortCourses(neededCourses);
  // print("neededCourses $neededCourses");
  // Default parameters to be taken from the user later
  // chosenHours = "15";
  int desiredCreditHours = int.parse(chosenHours);
  print("&& desiredCreditHours" + chosenHours);

  String parts = start + "-" + end;
  List<TimeOfDay> myTimes = parseLectureTimeString(parts);
  TimeOfDay startTime= myTimes[0], endTime = myTimes[1];

  // The Table to be Displayed for the user
  List<UICourse> tableToBeDisplayed = [];

  // Attempt to generate a schedule using the provided inputs
  if (generateSchedule(neededCourses, sections, tableToBeDisplayed, 0, desiredCreditHours, startTime, endTime)) {
    // Print the successfully generated schedule
    print("Schedule generated successfully:");
  } else {
    // Print a message indicating failure to generate a suitable schedule
    print("Failed to generate schedule.");
  }
  return tableToBeDisplayed;
}

void removeCourseByCourseId(List<UICourse> tableToBeDisplayed, String courseId) {
  // Iterate through the list of UICourses
  for (int i = 0; i < tableToBeDisplayed.length; i++) {
    // Check if the courseId of the current UICourse matches the provided courseId
    if (tableToBeDisplayed[i].code == courseId) {
      // Remove the UICourse from the list
      tableToBeDisplayed.removeAt(i);
      break;
    }
  }
}

void removeSectionBySectionId(List<Section> sections, String sectionId) {
  // Iterate through the list of sections
  for (int i = 0; i < sections.length; i++) {
    // Check if the sectionId of the current section matches the provided sectionId
    if (sections[i].sectionId == int.parse(sectionId)) {
      // Remove the Section from the list
      sections.removeAt(i);
      break;
    }
  }
}


CseCourse? returnCourseByCourseId(List<CseCourse> courses, String courseId) {
  // Iterate through the list of courses
  for (int i = 0; i < courses.length; i++) {
    if (courses[i].courseId == courseId) {
      return courses[i];
    }
  }
  return null;
}

String TryToAddSection(List<UICourse> tableToBeDisplayed,CseCourse course,List<Section> sections ) {
  String result = "";
  for (Section section in sections) {
    result = hasConflictWithSection(tableToBeDisplayed, section);
    if (result == "") {
      // added = true;
      tableToBeDisplayed.add(UICourse(
          section.courseId.toString(),
          course.courseName,
          section.sectionId.toString(),
          section.status.toString(),
          // should be changed to activity (the change in the section class)
          section.time.toString(),
          course.creditHours.toString()));
      break;
    }
  }
  return result;
}
bool generateSchedule(
    List<CseCourse> neededCourses,
    List<Section> sections,
    List<UICourse> tableToBeDisplayed,
    int currentIndex,
    int desiredCreditHours,
    TimeOfDay startTime,
    TimeOfDay endTime ) {
  bool stop = false;
  List<CseCourse> addedCourses = [];
  for(CseCourse course in neededCourses){
    List<Section> CourseSections = getOpenSections(sections, course, startTime, endTime);
    if(CourseSections.length==0){ // for now only, to pass the elective courses
      continue;
    }
    String result = TryToAddSection(tableToBeDisplayed,course, CourseSections);
    if(result == ""){ // added
      addedCourses.add(course);
      desiredCreditHours -= course.creditHours;
      if (desiredCreditHours <= 0) {
        stop = true;
        break;
      }
      // else if (desiredCreditHours < 0) {
      //   removeCourseByCourseId(tableToBeDisplayed, course.courseId.toString());
      //   // re-add the hours and continue
      //   addedCourses.removeLast();
      //   desiredCreditHours += course.creditHours;
      // }
    }
    else { // not added
      String removedCourseId = result.split('-')[0];
      String removedSectionId = result.split('-')[1];
      removeCourseByCourseId(tableToBeDisplayed, removedCourseId);
      CseCourse? removedCourse = returnCourseByCourseId(addedCourses, removedCourseId);
      String newResult = "";
      if(removedCourse!=null){
        List<Section> sectionList = getOpenSections(sections, removedCourse, startTime, endTime);
        removeSectionBySectionId(sectionList, removedSectionId);
        newResult=TryToAddSection(tableToBeDisplayed, removedCourse, sectionList);
        if(newResult==""){ // added - there is another section that is not conflicting, now try to add the current course
          String result = TryToAddSection(tableToBeDisplayed,course, CourseSections);
          if(result == ""){ // added -
            addedCourses.add(course);
            desiredCreditHours -= course.creditHours;
            if (desiredCreditHours <= 0) {
              stop = true;
              break;
            }
            // else if (desiredCreditHours < 0) {
            //   removeCourseByCourseId(tableToBeDisplayed, course.courseId.toString());
            //   // re-add the hours and continue
            //   addedCourses.removeLast();
            //   desiredCreditHours += course.creditHours;
            // }
          }
        // else{
        // //   continue to the next course
        // }
        }
        else{
          // re-add the removedCourse and then continue to the next course
          List<Section> CourseSections = getOpenSections(sections, removedCourse, startTime, endTime);
          String result = TryToAddSection(tableToBeDisplayed,removedCourse, CourseSections);
          if(result == ""){ // added
            addedCourses.add(removedCourse);
          }
        //   continue to the next course
        }
      }
    }

    if(stop){
      // print(addedCourses);
      return true;
    }
  }
  // print(addedCourses);
  return false;

}

String hasConflictWithSection(List<UICourse> tableToBeDisplayed, Section newSection) {
  if (tableToBeDisplayed == []){
    return "";
  }

  for (UICourse section in tableToBeDisplayed) {
    if (doSectionsConflict(Section(
        int.parse(section.sectionNumber),
        int.parse(section.code),
        false,
        section.time
    ), newSection)) {
      return '${section.code}-${section.sectionNumber}';
    }
  }
  return "";
}

bool hasConflict(List<UICourse> tableToBeDisplayed, Section newSection) {
  if (tableToBeDisplayed == []){
    return false;}

  for (UICourse section in tableToBeDisplayed) {
    if (doSectionsConflict(Section(
        int.parse(section.sectionNumber),
        int.parse(section.code),
        false,
        section.time
    ), newSection)) {
      return true;
    }
  }
  return false;
}


List<Section> getOpenSections(List<Section> sections, CseCourse course, TimeOfDay startTime, TimeOfDay endTime) {
  return sections
      .where((section) =>
              section.courseId == int.parse(course.courseId)
              && !section.status // The ! should be removed
              // && doSectionsConflict(section, Section(0,0,false,'[${startTime.toStringConvert()}-${endTime.toStringConvert()}]')) // UnComment when we change the data

              // The below is not valid
              && (section.startTime?.compareTo(startTime)==1 || section.startTime?.compareTo(startTime)==0 )
              && (section.endTime?.compareTo(endTime)==-1    || section.endTime?.compareTo(endTime)==0 )
            ).toList();
}

// You can add more error checking here if needed
// timeString = "13:30-14:20"
List<TimeOfDay> parseLectureTimeString(String timeString) {
  List<String> parts = timeString.split('-'); // parts = ["13:30","14:20"]

  List<String> startTimeParts = parts[0].split(':'); // startTimeParts = ["13","30"]
  TimeOfDay startTime = TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1]));

  List<String> endTimeParts = parts[1].split(':'); // endTimeParts = ["14","20"]
  TimeOfDay endTime = TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1]));

  return [startTime,endTime];
}

//[13:30-14:20 DAR B109 Sunday Tuesday Thursday]
bool isThereAConflict(String time, String time2) {
  if (time == time2) return true;
  var time1asList = time.substring(1, time.length - 1).split(' ');
  var time2asList = time2.substring(1, time2.length - 1).split(' ');
  // if (!isTheSameDay(time1asList, time2asList)) return false;

  List<TimeOfDay> L1_time = parseLectureTimeString(time1asList[0]);
  TimeOfDay L1_startTime = L1_time[0];
  TimeOfDay L1_endTime = L1_time[1];

  List<TimeOfDay> L2_time = parseLectureTimeString(time2asList[0]);
  TimeOfDay L2_startTime = L2_time[0];
  TimeOfDay L2_endTime = L2_time[1];
  // v1 : if (L1_startTime.compareTo(L2_startTime)==-1 && L1_endTime.compareTo(L2_endTime)==1)
  // v2 : if (L1_endTime.compareTo(L2_startTime)==-1 || L2_endTime.compareTo(L1_startTime)==-1)
  if ((L1_startTime.compareTo(L2_startTime)==-1 && L1_endTime.compareTo(L2_startTime)==-1)
      || (L2_startTime.compareTo(L1_startTime)==-1 && L2_endTime.compareTo(L1_startTime)==-1))
    return false;
  else
    return true;
}


// Function to check if two sections have conflicting days and time overlap
// may have problems, due to day/time
bool doSectionsConflict(Section section1, Section section2) {
  // Take the days from the section 1 time
  List<String> section1List = section1.time.substring(1, section1.time.length - 1).split(' ');
  List<String> section1Days = [];
  for (int i = section1List.length - 1; i >= 0; i--) {
    if (section1List[i].endsWith("day")) {
      section1Days.add(section1List[i]);
    }
  }
  // Take the days from the section 2 time
  List<String> section2List = section2.time.substring(1, section2.time.length - 1).split(' ');
  List<String> section2Days = [];
  for (int i = section2List.length - 1; i >= 0; i--) {
    if (section2List[i].endsWith("day")) {
      section2Days.add(section2List[i]);
    }
  }
  // Check conflict
  if (section1Days.any((day) => section2Days.contains(day))) {
    if (isThereAConflict(section1.time,section2.time)) {
      return true;
    }
  }
  return false; // No conflict
}