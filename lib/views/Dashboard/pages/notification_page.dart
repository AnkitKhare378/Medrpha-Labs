import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/core/constants/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Logic: Change this to an empty list [] to see the "No Data" view
    final notifications = [];

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
      body: notifications.isEmpty
          ? _buildNoDataView()
          : ListView.separated(
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
              child: Icon(item["icon"] as IconData,
                  color: AppColors.primaryColor),
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
            onTap: () {},
          );
        },
      ),
    );
  }

  /// Widget to show when the list is empty
  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You can replace this Icon with an Image.asset('assets/no_notif.png')
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Notifications Yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'We will notify you when something important happens.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}