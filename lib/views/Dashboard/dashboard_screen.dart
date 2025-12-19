import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medrpha_labs/views/bottom_tabs/CartScreen/my_cart_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/CategoryScreen/category_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/TestScreen/lab_test_screen2.dart';
import '../../core/services/navigation_service.dart';
import '../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../pages/dashboard/bloc/dashboard_event.dart';
import '../../pages/dashboard/bloc/dashboard_state.dart';
import 'package:medrpha_labs/views/Dashboard/widgets/animated_tab_icon.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/home_screen.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({this.initialIndex = 0, super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Used only for initial notification routing; UI itself follows bloc state.
  late int _selectedIndex;


  final int _labVersion = 0;
  final Key _homeKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    final notificationService = NotificationService();

    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);

    // App opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // handle if needed
    });

    // Background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Your UI is driven by bloc's state.currentIndex, so drive the bloc:
    context.read<DashboardBloc>().add( DashboardTabChanged(1));
    setState(() {
      _selectedIndex = 1;
    });
  }

  // Future<void> _openLabsDialog(BuildContext context) async {
  //   final labs = [
  //     {"name": "Medrpha Labs - New", "location": "123 Main Street"},
  //     {"name": "Medrpha Labs - North", "location": "45 Elm Avenue"},
  //     {"name": "Medrpha Labs - West", "location": "78 Pine Road"},
  //   ];
  //
  //   final selectedLab = await showDialog(
  //     context: context,
  //     builder: (_) => LabsListDialog(labs: labs),
  //   );
  //
  //   if (selectedLab != null) {
  //     // Force-remount HomeScreen so its AppBar re-runs initState and reloads prefs
  //     setState(() {
  //       _labVersion++;
  //       _homeKey = ValueKey(_labVersion);
  //     });
  //   }
  // }

  // Build current tab on demand (no cached const list)
  Widget _buildCurrentTab(int index) {
    switch (index) {
      case 0:
      // KeyedSubtree guarantees a remount of the entire Home tab subtree when _homeKey changes.
        return KeyedSubtree(
          key: _homeKey,
          child: const HomeScreen(),
        );
      case 1:
        return CategoryPage();
      case 2:
        return MyCartPage();
      case 3:
        return const LabTestPage();
      case 4:
        return const BloodTestProfileView();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      // fire only when the flag flips to true
      listenWhen: (previous, current) =>
      previous.showLabsDialog != current.showLabsDialog &&
          current.showLabsDialog,
      listener: (context, state) async {
        // await _openLabsDialog(context);

        // (Optional) tell bloc to reset the flag if your bloc doesn't already do it
        // context.read<DashboardBloc>().add(const DashboardLabsDialogClosed());
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: Scaffold(
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                // Rebuilds correct tab each time; Home tab remounts when _homeKey changes.
                child: _buildCurrentTab(state.currentIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.blue.shade50,
                currentIndex: state.currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w400),
                onTap: (index) {
                  context.read<DashboardBloc>().add(DashboardTabChanged(index));
                },
                items: [
                  BottomNavigationBarItem(
                    icon: AnimatedTabIcon(
                      icon: CupertinoIcons.house,
                      isSelected: state.currentIndex == 0,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedTabIcon(
                      icon: Iconsax.element_4,
                      isSelected: state.currentIndex == 1,
                    ),
                    label: "Category",
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedTabIcon(
                      icon: Iconsax.shopping_bag,
                      isSelected: state.currentIndex == 2,
                    ),
                    label: "Cart",
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedTabIcon(
                      icon: Iconsax.health,
                      isSelected: state.currentIndex == 3,
                    ),
                    label: "Lab Test",
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedTabIcon(
                      icon: Iconsax.user,
                      isSelected: state.currentIndex == 4,
                    ),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
