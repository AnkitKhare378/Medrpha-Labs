import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegalInformationPage extends StatelessWidget {
  const LegalInformationPage({super.key});

  // Re-usable FAQ/Expansion tile
  Widget _faqTile(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        // Remove default ExpansionTile dividers
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          iconColor: Colors.blueAccent,
          collapsedIconColor: Colors.blueAccent,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          'Legal Information',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _faqTile(
            context,
            'Terms of Service',
            'By using this application you agree to comply with and be bound by '
                'the following terms and conditions. Your continued use signifies '
                'acceptance of these terms.',
          ),
          _faqTile(
            context,
            'Privacy Policy',
            'We respect your privacy and are committed to protecting the personal '
                'information you share with us. This policy explains how we collect, '
                'use, and safeguard your data.',
          ),
          _faqTile(
            context,
            'Disclaimer',
            'All health-related information provided in this app is for informational '
                'purposes only and is not a substitute for professional medical advice. '
                'Always seek the advice of your physician or other qualified provider.',
          ),
          _faqTile(
            context,
            'Contact Us',
            'For any legal queries or concerns, please email us at '
                'support@medrpha.com.',
          ),
        ],
      ),
    );
  }
}
