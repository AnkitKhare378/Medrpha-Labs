import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../view_model/WalletVM/updateWallet/update_wallet_bloc.dart';
import '../../../../view_model/WalletVM/updateWallet/update_wallet_event.dart';
import '../../../../view_model/WalletVM/updateWallet/update_wallet_state.dart';
import '../../HomeScreen/pages/widgets/add_more_test_button.dart';

class AddCashSection extends StatefulWidget {
  final TextEditingController amountController;
  final int userId;
  const AddCashSection({super.key, required this.amountController, required this.userId});

  @override
  State<AddCashSection> createState() => _AddCashSectionState();
}

class _AddCashSectionState extends State<AddCashSection> {
  // Define the minimum limit constant here as well for consistency
  final double _minWalletLimit = 500.0;

  void _onChipTap(String value) {
    final amountString = value.substring(1);
    final amountToAdd = double.tryParse(amountString) ?? 0.0;

    final currentText = widget.amountController.text;
    final currentAmount = double.tryParse(currentText) ?? 0.0;

    final newAmount = currentAmount + amountToAdd;

    widget.amountController.text = newAmount.toStringAsFixed(newAmount.truncateToDouble() == newAmount ? 0 : 2);
  }

  /// Displays the formal alert dialog if amount is less than 500
  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Minimum Amount Required",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            "Please enter an amount of ₹${_minWalletLimit.toInt()} or more to proceed.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
      child: BlocBuilder<UpdateWalletViewModel, UpdateWalletState>(
        builder: (context, state) {
          final isLoading = state is UpdateWalletLoading;
          return Column(
            children: [
              TextFormField(
                controller: widget.amountController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  labelStyle: GoogleFonts.poppins(),
                  prefixText: '₹ ',
                  border: const OutlineInputBorder(),
                ),
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                children: ['+500', '+1000','+1500', '+2000']
                    .map((v) => ActionChip(
                  label: Text(v,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                          fontSize: 12)),
                  backgroundColor: Colors.white,
                  onPressed: isLoading ? null : () => _onChipTap(v),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              AddMoreTestButton(
                onPressed: isLoading
                    ? () {}
                    : () {
                  final amountText = widget.amountController.text.trim();
                  final amount = double.tryParse(amountText);

                  if (amount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount.')),
                    );
                  }
                  // --- Added the 500 limit alert logic here ---
                  else if (amount < _minWalletLimit) {
                    _showAlert(context);
                  }
                  // --- End of alert logic ---
                  else {
                    context.read<UpdateWalletViewModel>().add(
                      AddBalanceToWallet(
                        userId: widget.userId,
                        amountToAdd: amount,
                      ),
                    );
                    // We usually clear this in the BlocListener on success,
                    // but keeping your clear logic here if preferred.
                  }
                },
                title: isLoading ? "ADDING..." : "ADD TO WALLET",
                backgroundColor: isLoading ? Colors.blue.shade200 : Colors.blueAccent,
                textColor: isLoading ? Colors.white70 : Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}