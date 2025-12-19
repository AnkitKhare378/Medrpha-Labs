import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  const FilterAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: onClose ?? () => Navigator.pop(context),
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
