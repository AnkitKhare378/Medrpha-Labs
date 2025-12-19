import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/signup/widgets/login_text_span.dart';
import '../../config/components/round_button.dart';
import '../../config/routes/routes_name.dart';
import 'app_text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  final List<Map<String, String>> sliders = [
    {
      'image': 'assets/images/img_3.png',
      'text': 'Welcome to Medrpha Labs',
    },
    {
      'image': 'assets/images/img_1.png',
      'text': 'Empowering Healthcare Innovation',
    },
    {
      'image': 'assets/images/img_2.png',
      'text': 'Create your Account Now',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _autoScroll();
    });
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
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Collect data
      final data = {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      // Navigate or API call
      Navigator.pushReplacementNamed(
        context,
        RoutesName.otpScreen,
        arguments: data["phone"],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Image.asset("assets/images/signup.png", height: 150,),
                      SizedBox(height: 20,),
                      // Curved bottom section
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Name
                                AppTextInput(
                                  controller: _nameController,
                                  hintText: "Full Name",
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter your name";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

// Phone
                                AppTextInput(
                                  controller: _phoneController,
                                  hintText: "Phone Number",
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter phone number";
                                    }
                                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                      return "Enter a valid 10-digit phone number";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

// Email
                                AppTextInput(
                                  controller: _emailController,
                                  hintText: "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter email";
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return "Enter a valid email address";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Password
                                AppTextInput(
                                  controller: _passwordController,
                                  hintText: "Password",
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter password";
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),
                                RoundButton(
                                  title: "Signup",
                                  height: 50,
                                  width: double.infinity,
                                  onPressed: _submit,
                                ),

                                const SizedBox(height: 10),
                                LoginTextSpan(),
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
    );
  }
}
