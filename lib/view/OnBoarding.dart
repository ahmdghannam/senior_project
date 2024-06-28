import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_project/model/localDatabase/sharedPrefferences.dart';
import 'package:flutter_course_project/view/login.dart';

void main(){
  runApp(OnBoarding());
}

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You AI Assistant",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text("Using this software\n,you can get answers about the university\nand create your table anywhere.",textAlign: TextAlign.center,),
              Image.asset('assets/robot.png'),
              ElevatedButton(
                onPressed: () {
                  setDontNeedOnBoarding();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()),
                  );
                }, style: ElevatedButton.styleFrom(
                fixedSize: const Size(320, 60),
                backgroundColor: const Color(0xFF842700),
                foregroundColor: Colors.white,
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(child: const Text('Next Screen',style: TextStyle(fontSize: 20),)),
                    Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
