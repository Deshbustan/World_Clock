import 'package:flutter/material.dart';
import 'package:world_clock/pages/home.dart';
import 'package:world_clock/pages/choose_location.dart';
import 'package:world_clock/pages/loading_screen.dart';

void main() => runApp(MaterialApp(

initialRoute: '/loading_screen',

routes: {
  '/home': (context) => const Home(),
  '/choose_location': (context) => const ChooseLocation(),
  '/loading_screen': (context) => const LoadingScreen(),
},

)
);


