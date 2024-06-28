import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GPACalculator(),
    );
  }
}

class GPACalculator extends StatefulWidget {
  @override
  _GPACalculatorState createState() => _GPACalculatorState();
}

class _GPACalculatorState extends State<GPACalculator> {
  TextEditingController hoursController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController cumulativeGPAController = TextEditingController();
  TextEditingController completedHoursController = TextEditingController();

  List<Map<String, dynamic>> courses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: hoursController,
              decoration: InputDecoration(labelText: 'Number of Hours'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade (A, B, C, D, F)'),
              maxLength: 1,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addCourse();
              },
              child: Text('Add Course'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: cumulativeGPAController,
              decoration: InputDecoration(labelText: 'Cumulative GPA before the current semester'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: completedHoursController,
              decoration: InputDecoration(labelText: 'Number of hours completed before the current semester'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateGPA();
              },
              child: Text('Calculate GPA'),
            ),
            SizedBox(height: 20),
            Text('New GPA: ${calculateNewGPA()}'),
          ],
        ),
      ),
    );
  }

  void addCourse() {
    String grade = gradeController.text.toUpperCase();
    double hours = double.tryParse(hoursController.text) ?? 0.0;

    if (isValidGrade(grade) && hours > 0) {
      setState(() {
        courses.add({'grade': grade, 'hours': hours});
        gradeController.clear();
        hoursController.clear();
      });
    } else {
      // Show an error message or handle invalid input
      // For simplicity, we'll just print an error message to the console
      print('Invalid grade or number of hours');
    }
  }

  void calculateGPA() {
    double cumulativeGPA = double.tryParse(cumulativeGPAController.text) ?? 0.0;
    double completedHours = double.tryParse(completedHoursController.text) ?? 0.0;
    double totalPoints = cumulativeGPA * completedHours;

    for (var course in courses) {
      double gradePoints = calculateGradePoints(course['grade']);
      totalPoints += gradePoints * course['hours'];
      completedHours += course['hours'];
    }

    double newGPA = totalPoints / completedHours;

    setState(() {
      cumulativeGPAController.clear();
      completedHoursController.clear();
    });

    // Display the new GPA or perform further actions with it
    print('New GPA: $newGPA');
  }

  bool isValidGrade(String grade) {
    // Add your own logic for grade validation if needed
    return ['A', 'B', 'C', 'D', 'F'].contains(grade);
  }

  double calculateGradePoints(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'B':
        return 3.0;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0; // F
    }
  }

  double calculateNewGPA() {
    // Implement your logic to calculate the new GPA
    // based on the entered data and the existing cumulative GPA.
    // For simplicity, the logic is provided in the calculateGPA function.
    return 0.0;
  }
}
