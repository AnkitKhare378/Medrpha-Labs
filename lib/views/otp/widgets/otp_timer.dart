import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpTimer extends StatefulWidget {
  final VoidCallback onResend;

  const OtpTimer({super.key, required this.onResend});

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        _timer?.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _secondsRemaining > 0
          ? Text(
        "Resend OTP in $_secondsRemaining sec",
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      )
          : TextButton(
        onPressed: () {
          widget.onResend();
          _startTimer();
        },
        child: Text(
          "Resend OTP",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
