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
  void _onChipTap(String value) {
    // 1. Extract the number from the string (e.g., '+400' -> 400)
    final amountString = value.substring(1);
    final amountToAdd = double.tryParse(amountString) ?? 0.0;

    // 2. Get the current amount in the input field
    final currentText = widget.amountController.text;
    final currentAmount = double.tryParse(currentText) ?? 0.0;

    // 3. Calculate the new total amount
    final newAmount = currentAmount + amountToAdd;

    // 4. Update the controller's text
    // We display it without decimal points if it's a whole number
    widget.amountController.text = newAmount.toStringAsFixed(newAmount.truncateToDouble() == newAmount ? 0 : 2);
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
      // Use BlocBuilder on the dedicated UpdateWalletViewModel
      child: BlocBuilder<UpdateWalletViewModel, UpdateWalletState>(
        builder: (context, state) {
          final isLoding = state is UpdateWalletLoading;
          return Column(
            children: [
              TextFormField(
                controller: widget.amountController, // Assign the controller
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '₹',
                  border: OutlineInputBorder(),
                ),
                enabled: !isLoding, // Disable input while loading
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                children: ['+400', '+500', '+1000', '+2000']
                    .map((v) => Chip(
                  label: GestureDetector(
                    onTap: isLoding ? null : () => _onChipTap(v),
                    child: Text(v,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                            fontSize: 12)),
                  ),
                  backgroundColor: Colors.white,
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              AddMoreTestButton(
                onPressed: isLoding
                    ? () {} // Do nothing when loading
                    : () {
                  final amountText = widget.amountController.text.trim();
                  final amount = double.tryParse(amountText);

                  if (amount != null && amount > 0) {
                    // Dispatch the event using the renamed BLoC
                    context.read<UpdateWalletViewModel>().add(
                      AddBalanceToWallet(
                        userId: widget.userId,
                        amountToAdd: amount,
                      ),
                    );
                    widget.amountController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid amount.')),
                    );
                  }
                },
                title: isLoding ? "ADDING..." : "ADD TO WALLET", // Update title
                backgroundColor:
                isLoding ? Colors.blue.shade200 : Colors.blueAccent,
                textColor: isLoding ? Colors.white70 : Colors.white,
                // If AddMoreTestButton has an isLoding parameter, you should pass it here
              ),
            ],
          );
        },
      ),
    );
  }
}
