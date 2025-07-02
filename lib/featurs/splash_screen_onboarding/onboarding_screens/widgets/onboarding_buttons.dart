import 'package:flutter/material.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class OnboardingButtons extends StatelessWidget {
  final String title;
  final Function()? ontap;
  final bool is_scoundary;
  const OnboardingButtons(
      {super.key, required this.title, this.ontap, required this.is_scoundary});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: is_scoundary
              ? lightColorScheme.onPrimary
              : lightColorScheme.primary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 2,
              color:
                  is_scoundary ? lightColorScheme.primary : Colors.transparent),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: is_scoundary
                      ? lightColorScheme.primary
                      : lightColorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
