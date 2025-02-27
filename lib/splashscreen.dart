
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:task_manager/to-do/task_manager_homepage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6)).then((value){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context){
         return const TaskManagerHomePage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage("assets/image/taskManager.jpg"),
              width: 300,
            ),
            SizedBox(
              height: 50,
              ),

          SpinKitThreeBounce(
            color: Color(0xffeef444c),
            size: 50.0,
            )

          ],
        ),
      ),
    );
  }
}