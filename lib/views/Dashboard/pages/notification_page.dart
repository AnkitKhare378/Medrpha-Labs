import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/core/constants/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "New Message",
        "subtitle": "You have received a new message from Admin.",
        "time": "2 min ago",
        "icon": Icons.message
      },
      {
        "title": "Course Update",
        "subtitle": "Your Maths class has been rescheduled to 5 PM.",
        "time": "1 hr ago",
        "icon": Icons.school
      },
      {
        "title": "Exam Reminder",
        "subtitle": "SSC CGL Tier 1 test is tomorrow at 10 AM.",
        "time": "Yesterday",
        "icon": Icons.alarm
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: AppColors.primaryColor.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Icon(item["icon"] as IconData, color: AppColors.primaryColor),
            ),
            title: Text(
              item["title"].toString(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                item["subtitle"].toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            trailing: Text(
              item["time"].toString(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              // Handle notification click
            },
          );
        },
      ),
    );
  }
}
