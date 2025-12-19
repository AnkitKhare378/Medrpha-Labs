import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginTextSpan extends StatelessWidget {
  const LoginTextSpan({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: Colors.black87,
        ),
        children: [
          const TextSpan(text: "Already have an account? "),
          TextSpan(
            text: "Login",
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }
}
