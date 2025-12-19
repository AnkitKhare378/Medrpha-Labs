import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class LabTestAppBar extends StatefulWidget {
  final VoidCallback? onBack;
  final List<String> searchTexts;

  const LabTestAppBar({
    super.key,
    this.onBack,
    required this.searchTexts,
  });

  @override
  State<LabTestAppBar> createState() => _LabTestAppBarState();
}

class _LabTestAppBarState extends State<LabTestAppBar> {
  int _searchTextIndex = 0;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _startSearchAnimation();
  }

  void _startSearchAnimation() {
    _searchTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _searchTextIndex = (_searchTextIndex + 1) % widget.searchTexts.length;
      });
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Iconsax.search_normal,
                            color: Colors.grey, size: 20),
                        const SizedBox(width: 15),
                        // ✅ Combined Texts - "Search for Thyroid test"
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Text(
                            'Search for ${widget.searchTexts[_searchTextIndex]}',
                            key: ValueKey(_searchTextIndex),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
