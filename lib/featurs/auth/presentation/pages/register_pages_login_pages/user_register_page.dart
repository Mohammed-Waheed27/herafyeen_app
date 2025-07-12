import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/header.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/register_textefilds.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/auth_primary_button.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

import '../../models/registration_data.dart';
import 'final_registration_page.dart';
import 'sections/RegisterImagePicker.dart';
import 'sections/logo_register_section.dart';

class UserRegisterPage extends StatefulWidget {
  final RegistrationData registrationData;
  const UserRegisterPage({super.key, required this.registrationData});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _idcard = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? is_selected;
  //image validation
  bool? have_image;
  //the selected image
  File? filee;
  @override
  void initState() {
    super.initState();
    is_selected = false;
    have_image = true;
  }

  void getmage(File file, bool is_selcted) {
    setState(() {
      is_selected = is_selcted;
      filee = file;
    });
  }

  @override
  void dispose() {
    _idcard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Center(
          child: Column(
            children: [
              StylizedTitle(),
              HeaderText(
                  Title:
                      "اهلا ${widget.registrationData.fullName.split(' ')[0]}"),
              Expanded(
                  child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        // the national id
                        child: RegisterTextefilds(
                          label: "الرقم القومي",
                          hint: "national id 14 digits",
                          controller: _idcard,
                          valodator: (value) {
                            if (value!.isEmpty) {
                              return "الرقم القومي مطلوب";
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return "يجب ان يكون ارقام فقط";
                            } else if (value.length != 14) {
                              return "رقم قومي غير صالح يجب ان يكون 14 رقم";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // the validation for the profiel pic seclection
                      have_image == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "***يجب اختيار صورة البروفايل للمتابعه ***",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: lightColorScheme.primary,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                )
                              ],
                            )
                          : SizedBox(),
                      // upload of the image
                      RegisterImagePicker(
                        label: " صورة البطاقه الشخصية من الامام",
                        get_image: getmage,
                      ),
                      is_selected == true
                          ? Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(18.r),
                              height: 300.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      width: 2,
                                      color: lightColorScheme.primary),
                                  image: DecorationImage(
                                    image: FileImage(File(filee!.path)),
                                    fit: BoxFit.contain,
                                  )),
                            )
                          : SizedBox(height: 16.h),
                    ],
                  ),
                ),
              )),

              // the button to move
              Align(
                alignment: Alignment.bottomCenter,
                child: AuthPrimaryButton(
                  button_label: "التالي",
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (formKey.currentState!.validate()) {
                      if (is_selected == true) {
                        setState(() {
                          have_image = true;
                        });
                        final updatedRegistrationData =
                            widget.registrationData.copyWith(
                          idCardImage: filee,
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FinalRegistrationPage(
                                  registrationData: updatedRegistrationData,
                                )));
                      } else if (is_selected == false) {
                        setState(() {
                          have_image = false;
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
