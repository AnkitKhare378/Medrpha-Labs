import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/login/widgets/app_number_input.dart';
import 'package:medrpha_labs/views/login/widgets/terms_privacy_text.dart';
import 'package:medrpha_labs/config/components/round_button.dart';
import 'package:medrpha_labs/config/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/login_service.dart';
import '../../view_model/AccountVM/login_view_model.dart';
import '../../view_model/CartVM/get_cart_view_model.dart';
import '../AppWidgets/app_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  final List<Map<String, String>> sliders = [
    {'image': 'assets/images/img_3.png', 'text': 'Welcome to Medrpha Labs'},
    {'image': 'assets/images/img_1.png', 'text': 'Empowering Healthcare Innovation'},
    {'image': 'assets/images/img_2.png', 'text': 'Join Us for a Smarter Future'},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _autoScroll());
  }

  void _fetchUserSpecificCart() async {
    // 1. Initialize SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 2. Fetch the integer user_id
    final id = prefs.getInt('user_id');

    // 3. Check if the ID exists and the widget is still in the tree
    if (id != null && mounted) {
      // 4. Dispatch the event to your BLoC
      // (Note: No need to parse if 'id' is already an int)
      context.read<GetCartBloc>().add(FetchCart(id));
    } else {
      debugPrint("No User ID found in SharedPreferences");
    }
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % sliders.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _autoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final input = _phoneController.text.trim();
      context.read<LoginBloc>().add(LoginRequested(input));
    }
  }

  // --- NEW: Skip Button Logic ---
  void _skipToHome(BuildContext context) {
    // Navigate past the onboarding/login, typically to the home screen
    // or the next screen that doesn't require the initial setup.
    Navigator.pushReplacementNamed(
      context,
      RoutesName.dashboardScreen, // Replace with your actual home screen route (e.g., RoutesName.homeScreen)
    );
    _fetchUserSpecificCart();
  }
  // -----------------------------

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginService()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack( // 1. Use a Stack to overlay the skip button
            children: [
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginLoading) {
                    showAppSnackBar(context, "Sending OTP...");
                  }
                  else if (state is LoginSuccess) {
                    showAppSnackBar(
                      context,
                      state.loginData.messages?.first ?? "OTP sent successfully!",
                    );

                    Navigator.pushNamed(
                      context,
                      RoutesName.otpScreen,
                      arguments: _phoneController.text.trim(),
                    );
                  }
                  else if (state is LoginError) {
                    showAppSnackBar(context, state.message);
                  }
                },

                // 2. Wrap your existing content inside the Stack
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),

                              // --- Image Slider ---
                              SizedBox(
                                height: 220,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: sliders.length,
                                  onPageChanged: (index) {
                                    setState(() => _currentPage = index);
                                  },
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Image.asset(
                                          sliders[index]['image']!,
                                          fit: BoxFit.contain,
                                          width: 200,
                                          height: 150,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          sliders[index]['text']!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              // --- Dots Indicator ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  sliders.length,
                                      (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: _currentPage == index ? 12 : 8,
                                    height: _currentPage == index ? 12 : 8,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // --- Bottom Section ---
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 30,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF5F7FA),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Login",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // --- Input Field ---
                                        AppContactInput(
                                          controller: _phoneController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "Please enter email or phone number";
                                            }

                                            // Phone validation
                                            if (RegExp(r'^[0-9]+$')
                                                .hasMatch(value)) {
                                              if (!RegExp(r'^[6-9]\d{9}$')
                                                  .hasMatch(value)) {
                                                return "Enter a valid 10-digit phone number";
                                              }
                                              return null;
                                            }

                                            // Email validation
                                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                .hasMatch(value)) {
                                              return "Enter a valid email address";
                                            }

                                            return null;
                                          },
                                        ),

                                        const SizedBox(height: 20),

                                        // --- Submit Button ---
                                        BlocBuilder<LoginBloc, LoginState>(
                                          builder: (context, state) {
                                            final isLoading =
                                            state is LoginLoading;
                                            return RoundButton(
                                              title: isLoading
                                                  ? "Please wait..."
                                                  : "Receive OTP",
                                              height: 50,
                                              width: double.infinity,
                                              onPressed: isLoading
                                                  ? null
                                                  : () => _submit(context),
                                            );
                                          },
                                        ),

                                        const SizedBox(height: 20),
                                        const Spacer(),

                                        // --- Social + Terms ---
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                  const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.rectangle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 4,
                                                        offset:
                                                        const Offset(2, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    'assets/logo/google2.png',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 25),
                                                Container(
                                                  padding:
                                                  const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.rectangle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 4,
                                                        offset:
                                                        const Offset(2, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    'assets/logo/facebook2.png',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            const TermsPrivacyText(),
                                          ],
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
                  },
                ),
              ),

              // 3. The new skip button, positioned on top
              Positioned(
                top: 20, // A little padding from the top edge of SafeArea
                right: 24, // Matches the horizontal padding of the bottom section
                child: InkWell(
                  onTap: () => _skipToHome(context),
                  child: Text(
                    'Skip >',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent, // Make it pop!
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