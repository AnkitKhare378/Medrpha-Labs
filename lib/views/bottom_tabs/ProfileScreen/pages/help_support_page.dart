// File: lib/views/bottom_tabs/ProfileScreen/pages/help_support_page.dart (Integrated)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/FaqM/get_frequently_model.dart';
import '../../../../view_model/FaqVM/get_frequently_view_model.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  @override
  void initState() {
    super.initState();
    // 🚀 Trigger the BLoC to fetch FAQs when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FrequentlyBloc>().add(const FetchFaqs());
    });
  }

  // The old static list is removed, replaced by BLoC data.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📄 FAQ Section Title
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // FAQ Tiles built using BlocBuilder
            BlocBuilder<FrequentlyBloc, FrequentlyState>(
              builder: (context, state) {
                if (state is FrequentlyLoading) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ));
                } else if (state is FrequentlyLoaded) {
                  if (state.faqs.isEmpty) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No FAQs available.'),
                    ));
                  }
                  return Column(
                    children: state.faqs
                        .map((faq) => _faqTile(context, faq.question, faq.answer))
                        .toList(),
                  );
                } else if (state is FrequentlyError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Failed to load FAQs: ${state.message}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(color: Colors.red)),
                    ),
                  );
                }
                // Initial state or unhandled state
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 24),

            // 📞 Contact Us
            Text(
              'Need more help?',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _contactCard(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+91 98765 43210',
              onTap: () {
                // integrate tel: link if needed
              },
            ),
            const SizedBox(height: 12),
            _contactCard(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@medrphalabs.com',
              onTap: () {
                // integrate mailto: link if needed
              },
            ),

            const SizedBox(height: 24),

            // 💬 Send Message Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // open chat/support form
                },
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                label: Text(
                  'Send us a Message',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated FAQ ExpansionTile with no dividers
  Widget _faqTile(BuildContext context, String question, String answer) {
    // ... (Your existing _faqTile widget implementation)
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contact Card widget
  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    // ... (Your existing _contactCard widget implementation)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.15),
              radius: 24,
              child: Icon(icon, color: Colors.blueAccent, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}