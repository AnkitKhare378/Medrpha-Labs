import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/components/round_button.dart';
import 'package:medrpha_labs/config/routes/routes_name.dart';
import 'package:medrpha_labs/views/AppWidgets/app_snackbar.dart';
import 'package:medrpha_labs/views/login/widgets/terms_privacy_text.dart';
import 'package:medrpha_labs/views/otp/widgets/otp_input_fields.dart';
import 'package:medrpha_labs/views/otp/widgets/otp_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/navigation_service.dart';
import '../../view_model/AccountVM/verify_otp/verify_otp_event.dart';
import '../../view_model/AccountVM/verify_otp/verify_otp_state.dart';
import '../../view_model/AccountVM/verify_otp/verify_otp_view_model.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String _fcmToken = '';

  @override
  void initState() {
    super.initState();
    // 🚨 Fetch the FCM token when the screen initializes
    _fetchFCMToken();
  }

  Future<void> _fetchFCMToken() async {
    final token = await NotificationService().getDeviceToken();
    setState(() {
      _fcmToken = token;
    });
    if (kDebugMode) {
      print('✅ Stored FCM Token in state: $_fcmToken');
    }
  }

  String _buildOtpMessage(String input) {
    final isNumeric = RegExp(r'^[0-9]+$').hasMatch(input);

    if (isNumeric && input.length == 10) {
      return "OTP sent to +91 ${input.substring(0, 3)}******${input.substring(8)} via SMS";
    } else if (isNumeric) {
      return "OTP sent to +91 $input via SMS";
    } else {
      final parts = input.split('@');
      final masked = parts[0].length > 3
          ? "${parts[0].substring(0, 3)}***@${parts[1]}"
          : "***@${parts[1]}";
      return "OTP sent to $masked via Email";
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyOtpBloc(),
      child: BlocListener<VerifyOtpBloc, VerifyOtpState>(
        listener: (context, state) async {
          if (state is VerifyOtpLoading) {
            showAppSnackBar(context, "Verifying OTP...");
          } else if (state is VerifyOtpSuccess) {
            showAppSnackBar(
              context,
              state.response.messages?.first ?? "OTP verified successfully!",
            );
            Navigator.pushReplacementNamed(
              context,
              RoutesName.dashboardScreen,
            );
          } else if (state is VerifyOtpError) {
            showAppSnackBar(context, state.message);
            // Navigator.pushReplacementNamed(
            //   context,
            //   RoutesName.dashboardScreen,
            // );
            // final prefs = await SharedPreferences.getInstance();
            // await prefs.setInt('user_id', 5);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
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
                          const SizedBox(height: 60),
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/img_4.png',
                                fit: BoxFit.contain,
                                width: 200,
                                height: 150,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 30),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Please Enter OTP",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _buildOtpMessage(widget.phoneNumber),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Icon(
                                          CupertinoIcons.pencil,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),
                                  OtpInputFields(
                                    controllers: _controllers,
                                    focusNodes: _focusNodes,
                                  ),
                                  const SizedBox(height: 30),

                                  // 🔹 Verify OTP button with Bloc
                                  BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                                    builder: (context, state) {
                                      final isLoading =
                                      state is VerifyOtpLoading;
                                      return RoundButton(
                                        title: isLoading
                                            ? "Verifying..."
                                            : "Verify OTP",
                                        height: 50,
                                        width: double.infinity,
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                          final otp = _controllers
                                              .map((e) => e.text)
                                              .join();
                                          if (otp.length == 6) {
                                            context
                                                .read<VerifyOtpBloc>()
                                                .add(VerifyOtpSubmitted(
                                                widget.phoneNumber,
                                                otp, _fcmToken));
                                          } else {
                                            showAppSnackBar(context,
                                                "Please enter a valid 6-digit OTP");
                                          }
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 10),
                                  OtpTimer(
                                    onResend: () {
                                      showAppSnackBar(
                                          context, "OTP Resent Successfully");
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  const Spacer(),
                                  const TermsPrivacyText(),
                                ],
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
        ),
      ),
    );
  }
}
