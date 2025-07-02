import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';

/// A reusable text field widget ================================================
///
/// this is for the validations for each textfeild widget
///
typedef Validator = String? Function(String?);

class RegisterTextefilds extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final Validator? valodator;
  final TextEditingController controller;
  final int maxlines;

  const RegisterTextefilds({
    super.key,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.valodator,
    required this.controller,
    this.maxlines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: lightColorScheme.scrim,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 4.h),
        TextFormField(
          maxLines: maxlines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: valodator,
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: lightColorScheme.secondary,
              ),
          textAlign: TextAlign.right,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: lightColorScheme.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: lightColorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
