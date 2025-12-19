import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isExpanded;

  static const String _phoneNumber = '+91 99903 01880';

  const CustomFloatingButton({
    super.key,
    required this.onPressed,
    required this.isExpanded,
  });

  // Function to launch the phone dialer
  Future<void> _callNumber(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _phoneNumber,
    );

    // FIX: canLaunchUrl and launchUrl are now recognized because of the import
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Fallback for devices that cannot launch the dialer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch dialer for $_phoneNumber'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double width = isExpanded ? screenWidth * 0.35 : 56;
    const double height = 50;

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth - 32,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: height,
          width: width,
          child: ElevatedButton(
            onPressed: () {
              onPressed?.call();
              _callNumber(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.zero,
              elevation: 6,
            ),
            child: isExpanded
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.phoneVolume,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Call to Book",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
                : const Center(
              child: FaIcon(
                FontAwesomeIcons.phoneVolume,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}