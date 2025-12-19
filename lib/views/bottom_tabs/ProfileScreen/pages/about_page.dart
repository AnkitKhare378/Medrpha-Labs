import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Header Image ---
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1602052577122-f73b9710adba?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // --- Company Story ---
          Text(
            'Who We Are',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Medrpha Labs was founded with the vision of making quality healthcare '
                'accessible to everyone. We combine advanced diagnostics with a patient-first '
                'approach, ensuring that every individual receives timely and accurate results. '
                'Our team of dedicated professionals works tirelessly to innovate and improve '
                'the experience of modern healthcare.',
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),

          // --- Second Image ---
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://plus.unsplash.com/premium_photo-1661432575489-b0400f4fea58?q=80&w=872&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // --- Mission Section ---
          Text(
            'Our Mission',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our mission is to empower individuals to take control of their health by '
                'providing reliable, affordable, and convenient diagnostic solutions. '
                'Through innovation and compassion, we strive to create a healthier future for all.',
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),

          // --- Contact Info ---
          Text(
            'Contact Us',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: support@medrpha.com\nPhone: +91 98765 43210',
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
