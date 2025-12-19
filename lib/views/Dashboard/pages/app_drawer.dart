import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/blood_test_screen.dart';

import '../widgets/slide_page_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String profileImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/495px-No-Image-Placeholder.svg.png";
    final String name = "User Name";
    final String email = "user@user.com";

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Close (X) Button at Top Left
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 25,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // closes the drawer
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Profile Section Centered
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  profileImage,
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(FontAwesomeIcons.user,
                        size: 40, color: Colors.grey);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              email,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 25),

            // Drawer Items (Glass Effect)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _glassTile(FontAwesomeIcons.house, "Home", () {
                    Navigator.pop(context);
                  }),
                  _glassTile(FontAwesomeIcons.user, "My Profile", () {

                  }),
                  _glassTile(FontAwesomeIcons.clockRotateLeft, "My Orders", () {}),
                  _glassTile(FontAwesomeIcons.vials, "Lab Tests", () {
                    Navigator.of(context).push(
                      SlidePageRoute(
                        page: BloodTestScreen(),
                      ),
                    );
                  }),
                  _glassTile(FontAwesomeIcons.heart, "Saved", () {}),
                  _glassTile(FontAwesomeIcons.gear, "Settings", () {}),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logout logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.white, size: 16),
                  label: Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Glassmorphic Drawer Tile
  Widget _glassTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ListTile(
            leading: FaIcon(icon, color: Colors.blueAccent, size: 18),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
