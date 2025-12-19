import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  const FormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return StatefulBuilder(
      builder: (context, setState) {
        focusNode.addListener(() => setState(() {}));

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                color:
                focusNode.hasFocus ? Colors.blueAccent : Colors.grey[700],
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
