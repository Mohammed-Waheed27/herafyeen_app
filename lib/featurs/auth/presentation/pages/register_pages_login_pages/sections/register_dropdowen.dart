import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';

/// A dropdown for "نوع الحرفة"
class RegisterDropdown extends StatefulWidget {
  final String label;
  final String hint;

  const RegisterDropdown({
    Key? key,
    required this.label,
    required this.hint,
  }) : super(key: key);

  @override
  State<RegisterDropdown> createState() => _RegisterDropdownState();
}

class _RegisterDropdownState extends State<RegisterDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: lightColorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: lightColorScheme.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              alignment: AlignmentDirectional.centerEnd,
              hint: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.hint,
                  style: TextStyle(color: lightColorScheme.onSecondary),
                ),
              ),
              icon: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_drop_down,
                    color: lightColorScheme.primary),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Carpenter',
                  child: Text('نجار', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'Plumber',
                  child: Text('سباك', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'Electrician',
                  child: Text('كهربائي', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'Painter',
                  child: Text('دهان', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'Tiler',
                  child: Text('مبلط', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'Blacksmith',
                  child: Text('حداد', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'AirConditioner',
                  child: Text('فني تكييف', textAlign: TextAlign.right),
                ),
                DropdownMenuItem(
                  value: 'Gardener',
                  child: Text('بستاني', textAlign: TextAlign.right),
                ),
              ],
              onChanged: (val) {
                setState(() {
                  selectedValue = val;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
