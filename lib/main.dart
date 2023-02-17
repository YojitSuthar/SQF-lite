import 'package:flutter/material.dart';
import 'package:sqf_lite/screens/home_page.dart';

class myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}


void main()=> runApp(myapp());