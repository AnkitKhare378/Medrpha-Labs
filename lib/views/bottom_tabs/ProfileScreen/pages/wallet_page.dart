import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/widgets/add_cash_section.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/widgets/wallet_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/WalletM/wallet_model.dart';
import '../../../../view_model/WalletVM/updateWallet/update_wallet_bloc.dart';
import '../../../../view_model/WalletVM/updateWallet/update_wallet_event.dart';
import '../../../../view_model/WalletVM/updateWallet/update_wallet_state.dart';
import '../../../../view_model/WalletVM/wallet_bloc.dart';
import '../../../../view_model/WalletVM/wallet_event.dart';
import '../../../../view_model/WalletVM/wallet_state.dart';
import '../widgets/transaction_tabs.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController amountController = TextEditingController();

  int? _userId;
  bool _isLoadingUserId = true;

  // Minimum limit constant
  final double _minWalletLimit = 500.0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');

    if (mounted) {
      setState(() {
        _userId = id;
        _isLoadingUserId = false;
        if (_userId != null) {
          context.read<WalletBloc>().add(const FetchWalletData());
        }
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  /// 1. Added Alert Dialog Method
  void _showLimitAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Minimum Amount Required",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Text(
            "Please enter an amount of ₹${_minWalletLimit.toInt()} or more to proceed.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUserId) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My wallet')),
        body: const Center(
          child: Text('User ID not found. Please log in again.'),
        ),
      );
    }

    final userId = _userId!;

    return BlocListener<UpdateWalletViewModel, UpdateWalletState>(
      listener: (context, state) {
        if (state is UpdateWalletSuccess) {
          context.read<WalletBloc>().add(const FetchWalletData());
          amountController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallet balance added successfully!')),
          );
        } else if (state is UpdateWalletError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add balance: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        appBar: AppBar(
          title: Text('My wallet',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Total Card
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return const Center(child: WalletShimmer());
                  } else if (state is WalletError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
                  } else if (state is WalletLoaded) {
                    return _buildWalletCard(state.walletData);
                  }
                  return _buildWalletCard(null);
                },
              ),

              const SizedBox(height: 24),

              // Section Header with Red Min Label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Medr Cash',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('Min: ₹${_minWalletLimit.toInt()}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Integration Point
              // Ensure AddCashSection calls _showLimitAlert() if validation fails
              AddCashSection(
                amountController: amountController,
                userId: userId,
                // If your AddCashSection has a custom validation callback, use it here.
                // Otherwise, the validation should happen inside the AddCashSection widget
                // using the logic: if (amount < 500) _showLimitAlert();
              ),

              const SizedBox(height: 16),
              Text(
                'Note: The cash will be added to Medr Cash and can be used only for purchases on Medrpha Labs.',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueAccent, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              const TransactionTabs(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---
  Widget _buildWalletCard(WalletData? data) {
    final balance = data?.currentBalance ?? 0.00;
    final formattedBalance = _formatCurrency(balance);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text('Wallet Total',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(formattedBalance,
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.w700, color: Colors.blueAccent)),
          const Divider(height: 28),
          _walletRow('Medr Cash', formattedBalance),
          _walletRow('Medr Supercash', _formatCurrency(0.00)),
        ],
      ),
    );
  }

  Widget _walletRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
          Text(amount, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blueAccent)),
        ],
      ),
    );
  }
}