import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  @override
  Widget build(BuildContext context) {

    
    

    data= data.isNotEmpty ? data:ModalRoute.of(context)?.settings.arguments as Map;
    // print(data);

    // set the background image based on whether it's day or night
    String bgImage = data['isDayTime'] ? 'day.jpg' : 'night.jpg';

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
        child: Padding(padding: const EdgeInsets.fromLTRB(0,190.0,0,0),
        child: Column(
          
          children: <Widget> [
            TextButton.icon(
              onPressed:  () async {
               dynamic  result = await Navigator.pushNamed(context, '/choose_location');
               data = {
                 'location': result['location'],
                 'flag': result['flag'],
                 'time': result['time'],
                 'isDayTime': result['isDayTime'],
               };
              },
              icon: Icon(Icons.edit_location, color: data['isDayTime'] ? Colors.black : Colors.white70),
              label: Text('Edit Location', style: TextStyle(color: data['isDayTime'] ? Colors.black : Colors.white70),),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  data['location'],
                  style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                    color: data['isDayTime'] ? Colors.black : Colors.white70),
                  ),
                
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              data['time'],
              style: TextStyle(
                fontSize: 66.0,
                fontWeight: FontWeight.bold,
                color: data['isDayTime'] ? Colors.black : Colors.white70),
              ),
           
          ],
        
        ),
      ),
      )
      ),
    );
  }
}