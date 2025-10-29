import 'package:flutter/material.dart';

class Category extends StatelessWidget {
final String text;
final VoidCallback onTap;
  
  const Category({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap ,
      child: Container(
      
        decoration: BoxDecoration(
      color: Colors.white,
      border: BoxBorder.all(width:screenWidth*0.008, color: Color(0xffBD5959) ),
      borderRadius: BorderRadius.circular(screenWidth*0.04)
        ),
        width: screenWidth*0.2,
        height: screenHeight*0.1,
        child: Center(child: Text(text),),
      
      ),
    );
  }
}