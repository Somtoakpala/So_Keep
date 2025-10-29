import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
      // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  GestureDetector(
      onTap:onTap ,
      child: Container(
      
      
       decoration: BoxDecoration(
      color: Color(0xffBD5959),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(screenWidth*0.02)
       ),  
       width: screenWidth*0.5,
       height: screenHeight*0.06,
      child: Center(child: Text(text, style: GoogleFonts.instrumentSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: screenWidth*0.04, height: 0.1),  )),   
      ),
    );
  }
}