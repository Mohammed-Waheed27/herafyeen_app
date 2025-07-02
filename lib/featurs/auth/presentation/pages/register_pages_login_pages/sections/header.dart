import 'package:flutter/material.dart';

import '../../../../../../theme/color/app_theme.dart';

/// Top text: "حرفي دائماً في خدمتك" ================================================

class HeaderText extends StatelessWidget {
  final Title;
  const HeaderText({super.key, this.Title});

  @override
  Widget build(BuildContext context) {
    return Text(
      Title,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 18,
            color: lightColorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }
}
