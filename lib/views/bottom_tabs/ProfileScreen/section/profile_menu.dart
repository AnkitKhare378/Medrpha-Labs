import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/core/utils/auth_utils.dart';
import 'package:medrpha_labs/views/Dashboard/pages/notification_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/BookingScreen/booking_screen.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/select_address_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/about_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/health_record_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/help_support_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/provider/family_provider.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../../login/login_screen.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../pages/family_members_page.dart';
import '../pages/legal_information_page.dart';
import '../pages/save_for_later_page.dart';
import '../pages/wallet_page.dart';

class ProfileMenu extends StatefulWidget {
  final bool isLoggedIn;
  const ProfileMenu({Key? key,required this.isLoggedIn});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  Widget _menuItem(
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool isLast = false,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
            bottom: BorderSide(
              color: Colors.blue.shade50,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: const Color(0xFF2196F3), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _showSignOutDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: () async {
              // 1. Get the Provider instance
              // Use listen: false because we are inside a function
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              final familyProvider = Provider.of<FamilyProvider>(context, listen: false);
              // 2. Clear the cart data locally
              await cartProvider.clearLocalData();
              familyProvider.clearSelection();

              // 3. Clear User ID and Session
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_id');
              // If you have other keys like 'token', remove them here too

              // 4. Redirect to Login
              if (!mounted) return;
              Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          )
        ],
      ),
    );

    if (confirm == true) {
      showAppSnackBar(context, 'You have been signed out successfully');
      await Future.delayed(const Duration(milliseconds: 00));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isLoggedIn);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if(!widget.isLoggedIn)...[
            _menuItem(Iconsax.notification, 'Notification', () {Navigator.of(context).push(SlidePageRoute(page: const NotificationPage()));}),
            _menuItem(Iconsax.message_question, 'Help & Support', () {Navigator.of(context).push(SlidePageRoute(page: const HelpSupportPage()));}),
            _menuItem(Iconsax.document_text, 'Legal Information', () {Navigator.of(context).push(SlidePageRoute(page: const LegalInformationPage()),);}),
          ],
          if(widget.isLoggedIn) ...[
            _menuItem(Iconsax.wallet_3, 'My Wallet', () {Navigator.of(context).push(SlidePageRoute(page: const WalletPage()));}),
            _menuItem(Iconsax.shopping_bag, 'My Orders & Bookings', () {Navigator.of(context).push(SlidePageRoute(page: OrderHistoryScreen()));}),
            _menuItem(Iconsax.location, 'My Addresses', () {Navigator.of(context).push(SlidePageRoute(page: const SelectAddressPage()));}),
            // _menuItem(Iconsax.health, 'Health Records', () {Navigator.of(context).push(SlidePageRoute(page: const HealthRecordPage()));}),
            _menuItem(Iconsax.notification, 'Notification', () {Navigator.of(context).push(SlidePageRoute(page: const NotificationPage()));}),
            _menuItem(Iconsax.people, 'Family Members', () {Navigator.of(context).push(SlidePageRoute(page: const FamilyMembersPage()));}),
            _menuItem(Iconsax.save_2, 'Saved For Later', () {Navigator.of(context).push(SlidePageRoute(page: SaveForLaterPage()));}),
            _menuItem(Iconsax.message_question, 'Help & Support', () {Navigator.of(context).push(SlidePageRoute(page: const HelpSupportPage()));}),
            _menuItem(Iconsax.document_text, 'Legal Information', () {Navigator.of(context).push(SlidePageRoute(page: const LegalInformationPage()),);}),
            _menuItem(Iconsax.info_circle, 'About Us', () {Navigator.of(context).push(SlidePageRoute(page: const AboutUsPage()),);}),
            _menuItem(
              Iconsax.logout,
              'Sign Out',
                  () => _showSignOutDialog(context),
              isLast: true,
            ),
          ],
          // 🔹 Sign Out with dialog

        ],
      ),
    );
  }
}
