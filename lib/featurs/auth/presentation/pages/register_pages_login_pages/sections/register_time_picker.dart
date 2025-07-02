import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';

/// Time range picker placeholder for "من ... إلى ..." ================================================

class RegisterTimePicker extends StatefulWidget {
  const RegisterTimePicker({super.key});

  @override
  State<RegisterTimePicker> createState() => _RegisterTimePickerState();
}

class _RegisterTimePickerState extends State<RegisterTimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'حدد ساعات العمل المتاحة',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: lightColorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: startTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      startTime = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: lightColorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    startTime?.format(context) ?? '00:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: lightColorScheme.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('إلى'),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: endTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      endTime = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: lightColorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    endTime?.format(context) ?? '00:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: lightColorScheme.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
