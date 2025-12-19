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
import '../../HomeScreen/pages/widgets/add_more_test_button.dart';
import '../widgets/transaction_tabs.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController amountController = TextEditingController();

  // ⬅️ 2. Change _userId to be nullable and managed by state
  int? _userId;
  bool _isLoadingUserId = true; // State to track if ID is loaded

  @override
  void initState() {
    super.initState();
    _loadUserId(); // ⬅️ 3. Load the user ID when the state initializes
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // final id = prefs.getInt('user_id'); // ⬅️ Original instruction
    final id = prefs.getInt('user_id'); // ⬅️ Implementing the instruction

    if (mounted) {
      setState(() {
        _userId = id;
        _isLoadingUserId = false;
        // 4. Trigger initial data fetch only after ID is loaded
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

    // Handle case where user ID could not be loaded
    if (_userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My wallet')),
        body: const Center(
          child: Text('User ID not found. Please log in again.'),
        ),
      );
    }

    // Now we can use _userId! safely in the rest of the build method
    final userId = _userId!;

    return BlocListener<UpdateWalletViewModel, UpdateWalletState>(
      listener: (context, state) {
        if (state is UpdateWalletSuccess) {
          // **Reload the main Wallet data** to update the 'formattedBalance' in the view
          context.read<WalletBloc>().add(const FetchWalletData());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallet balance added successfully!')),
          );
        } else if (state is UpdateWalletError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text('Failed to add balance: ${state.message}')),
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
              // Wallet Total Section (Dynamic Content)
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return const Center(child: WalletShimmer());
                  } else if (state is WalletError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
                  } else if (state is WalletLoaded) {
                    return _buildWalletCard(state.walletData);
                  }
                  // Initial or other states show the default card
                  return _buildWalletCard(null);
                },
              ),

              const SizedBox(height: 24),

              // Add NMS Cash (Static Content)
              Text('Add Medr Cash',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              // ⬅️ 5. Use the loaded userId
              AddCashSection(amountController: amountController, userId: userId),
              const SizedBox(height: 16),
              Text(
                'Note: The cash will be added to Medr Cash and can be used only for purchases on Medrpha Labs. '
                    'The money added cannot be transferred to any other wallet and bank account. Terms & Conditions',
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
  // ... (rest of the _buildWalletCard and _walletRow functions remain the same)

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
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(formattedBalance,
              style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueAccent)),
          const Divider(height: 28),
          _walletRow('Medr Cash', formattedBalance), // Assuming currentBalance reflects Medr Cash
          _walletRow('Medr Supercash', _formatCurrency(0.00)), // Hardcoded for supercash as it's not in API
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
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500)),
          Text(amount,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent)),
        ],
      ),
    );
  }
}