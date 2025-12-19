import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class FixedAppBar extends StatefulWidget {


  const FixedAppBar({super.key});

  @override
  State<FixedAppBar> createState() => _FixedAppBarState();
}

class _FixedAppBarState extends State<FixedAppBar> {
  Timer? _searchTimer;
  int _searchTextIndex = 0;
  final List<String> _searchTexts = [
    'Blood Test, Diabetes',
    'Health Checkup',
    'Thyroid Test',
    'Liver Function',
    'Kidney Test',
  ];

  void _startSearchAnimation() {
    _searchTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _searchTextIndex = (_searchTextIndex + 1) % _searchTexts.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startSearchAnimation();
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
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.search_normal,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search for ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (
                                Widget child,
                                Animation<double> animation,
                                ) {
                              return SlideTransition(
                                position: animation.drive(
                                  Tween(
                                    begin: const Offset(0.0, 0.3),
                                    end: const Offset(0.0, 0.0),
                                  ).chain(
                                    CurveTween(curve: Curves.easeOut),
                                  ),
                                ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                _searchTexts[_searchTextIndex],
                                key: ValueKey(_searchTextIndex),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
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
