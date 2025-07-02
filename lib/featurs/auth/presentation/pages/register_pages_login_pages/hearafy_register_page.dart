import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/RegisterImagePicker.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/header.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/logo_register_section.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/auth_primary_button.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/register_textefilds.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

import '../../models/registration_data.dart';
import 'final_registration_page.dart';

class HearafyRegisterPage extends StatefulWidget {
  final RegistrationData registrationData;
  const HearafyRegisterPage({super.key, required this.registrationData});

  @override
  State<HearafyRegisterPage> createState() => _HearafyRegisterPageState();
}

class _HearafyRegisterPageState extends State<HearafyRegisterPage> {
  final formkey = GlobalKey<FormState>();
  final service_type_ctr = TextEditingController();
  final years_exp_ctr = TextEditingController();
  final location_ctr = TextEditingController();
  final discription_ctr = TextEditingController();

  List? images;
  bool? isselected;
  bool? image_validated;

  @override
  void initState() {
    super.initState();
    images = [];
    isselected = false;
    image_validated = true;
  }

  @override
  void dispose() {
    service_type_ctr.dispose();
    years_exp_ctr.dispose();
    location_ctr.dispose();
    discription_ctr.dispose();
    super.dispose();
  }

  void getimage_tolist(File file, bool is_selcted) {
    setState(() {
      isselected = is_selcted;
      if (is_selcted) {
        images!.add(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Column(
            children: [
              // the bodey section layout clean and responsive
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StylizedTitle(),
                      HeaderText(
                          Title:
                              "اهلا ${widget.registrationData.fullName.split(' ')[0]}"),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            RegisterTextefilds(
                              label: "نوع حرفتك",
                              hint: "مثلا سباك",
                              controller: service_type_ctr,
                              valodator: (value) {
                                if (value!.isEmpty) {
                                  return "نوع الحلرفه مطلوب";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            RegisterTextefilds(
                              label: "عدد سنوات الخبره",
                              hint: "exp",
                              controller: years_exp_ctr,
                              valodator: (value) {
                                if (value!.isEmpty) {
                                  return "عدد سنوات الخبره مطلوبه";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            RegisterTextefilds(
                              label: "موقعك الاساسي للشغل ",
                              hint: "مثلا الدقهليه مركز ميت غمر",
                              controller: location_ctr,
                              valodator: (value) {
                                if (value!.isEmpty) {
                                  return "العنوان مطلوب";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            RegisterTextefilds(
                              label: "نبذه عن نفسك",
                              hint: "وصف لك ولحرفتك",
                              controller: discription_ctr,
                              valodator: (value) {
                                final words = value!.split(RegExp(r'\s+'));
                                if (value.isEmpty) {
                                  return "العنوان مطلوب";
                                } else if (words.length > 100) {
                                  return "وصفك لا يجب ان يتعدي 100 كلمه";
                                } else if (words.length < 10) {
                                  return "وصفك قصير جدا";
                                } else {
                                  return null;
                                }
                              },
                              maxlines: 5,
                            ),
                          ],
                        ),
                      ),
                      image_validated == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "***يجب اختيار صور لاعمالك للمتابعه ***",
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
                      SizedBox(height: 16.h),
                      // image upoad
                      RegisterImagePicker(
                        label: "صور من اعمالك",
                        get_image: getimage_tolist,
                      ),
                      SizedBox(height: 16.h),
                      // the validation check
                      if (isselected!)
                        Container(
                          height: 150.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      image: FileImage(images![index]),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              AuthPrimaryButton(
                button_label: "التالي",
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (formkey.currentState!.validate()) {
                    if (isselected == true) {
                      final updatedRegistrationData =
                          widget.registrationData.copyWith(
                        jobTitle: service_type_ctr.text.trim(),
                        yearsOfExperience: years_exp_ctr.text.trim(),
                        description: discription_ctr.text.trim(),
                        portfolioImages: images?.cast<File>(),
                        workingHours:
                            "8:00 AM - 6:00 PM", // Default working hours
                      );

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FinalRegistrationPage(
                                registrationData: updatedRegistrationData,
                              )));
                    } else {
                      setState(() {
                        image_validated = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
