import 'package:flutter/material.dart';
import 'package:flutter_course_project/model/localDatabase/sharedPrefferences.dart';
import 'package:flutter_course_project/view/ChatPage.dart';
import 'package:flutter_course_project/view/ProfilePage.dart';
import 'package:flutter_course_project/view/TableCreatorPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'StartingPage.dart';

class HomePage extends StatefulWidget {
  final String studentId;
  HomePage({required this.studentId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(
        studentId: widget.studentId,
      ),
       ChatPage(),
      ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    setAsLoggedIn();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
            // Container(height: 16),
            Container(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'Welcome to Mosaed, where we effortlessly transform your student data into organized tables! Simplify your workload and enhance efficiency with just a few clicks.'
                    '\n\nand Chat with our Ai powered chatbot to get more information about your courses and your schedule.',


                textAlign: TextAlign.center,
              ),
            ),
            Container(height: 4),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TableCreatorPage()),
                );
              },
              child: Text(
                'Create New Table',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 70),
                backgroundColor: Color(0xff842700),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartingPage(
                            studentId: widget.studentId,
                          )),
                ); // Add functionality for updating passed courses
              },
              child: Text('Update Passed Courses',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 70),
                backgroundColor: Color(0xff842700),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _launchURLInBrowser(
                    'https://www.aaup.edu/Academics/Undergraduate-Studies/Faculty-Engineering/Computer-Systems-Engineering-Department/Computer-Systems-Engineering/Curriculum');
              },
              child:
                  Text('Go to CSE Plan', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 70),
                backgroundColor: Color(0xff842700),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          print("the index is : $index");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => pages[index]),
          );
        },
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Table'),
      ),
      body: Center(
        child: Text('Page 1 Content'),
      ),
    );
  }
}

_launchURLInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
