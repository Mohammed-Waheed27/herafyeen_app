import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../theme/color/app_theme.dart';

/// Image picker placeholders for "صورة البروفايل" or "صورة المرفقة"
class RegisterImagePicker extends StatelessWidget {
  final String label;
  final Function(File file, bool is_selcted) get_image;
  const RegisterImagePicker(
      {Key? key, required this.label, required this.get_image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            print('Tapped on image picker');
            final ImagePicker picker = ImagePicker();
            try {
              print('Attempting to pick image...');
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              print(
                  'Image picker result: ${image?.path ?? "No image selected"}');
              if (image != null) {
                // pass the image to the parent node

                get_image(File(image.path), true);
              }
            } catch (e) {
              print('Error picking image: $e');
              // Show error in UI
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: lightColorScheme.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              color: lightColorScheme.primary,
              size: 32.h,
            ),
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: lightColorScheme.scrim,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
