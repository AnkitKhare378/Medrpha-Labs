import 'package:flutter/material.dart';

import '../../../../config/color/colors.dart';

class FamilyMembersIconSection extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  const FamilyMembersIconSection({super.key, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Icon(
              Icons.edit_note,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        SizedBox(width: 4,),
        GestureDetector(
          onTap: onDelete,
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(
              Icons.delete,
              size: 20,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
