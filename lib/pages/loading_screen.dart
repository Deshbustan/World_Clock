import 'package:flutter/material.dart';
import 'package:world_clock/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State <LoadingScreen> createState() => _LoadingScreenState();
}


class  _LoadingScreenState extends State <LoadingScreen> {

  // Create an instance of WorldTime
  void  getWorldTime() async {
    WorldTime instance = WorldTime(
      location: 'London',
      url: 'Europe/London',);
      // Call the getTime method to fetch the time
    await instance.getTime();
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
    });
   
  }

     @override
  void initState() {
    super.initState();
    // Call the function when the widget is first created and added to the widget tree.
    getWorldTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body:Center(
        child: SpinKitFadingCircle(
          color: Colors.grey[400]!,
          size: 50.0,
        ),
      ),
    );
  }
} 