import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/user_register_page.dart';
import '../../../../../theme/color/app_theme.dart';
import '../../../../../core/models/user_model.dart';

import '../../models/registration_data.dart';
import 'hearafy_register_page.dart';
import 'widgets/auth_primary_button.dart';
import 'sections/RegisterImagePicker.dart';
import 'sections/header.dart';
import 'sections/hearafy_user_selection_section.dart';
import 'sections/logo_register_section.dart';
import 'widgets/register_textefilds.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({Key? key}) : super(key: key);

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  // the controllers
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  //local needed variabels for the state of the page
  int? activeIndex;
  bool? is_selected;
  File? filee;
  bool? showvalidation;
  bool? have_image;

  @override
  void initState() {
    super.initState();
    activeIndex = 27;
    is_selected = false;
    showvalidation = false;
    have_image = false;
  }

  void updateActiveIndex(int? index) {
    setState(() {
      activeIndex = index;
    });
  }

  void getimage(File file, bool is_selcted) {
    setState(() {
      is_selected = is_selcted;
      filee = file;
    });
  }
  //disposing the controllers

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const StylizedTitle(),
                SizedBox(
                  height: 20.h,
                ),
                const HeaderText(
                  Title: 'إنشاء حساب جديد',
                ),
                SizedBox(
                  height: 20.h,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        RegisterTextefilds(
                          label: 'الاسم بالكامل',
                          hint: 'User Name',
                          controller: _nameCtrl,
                          valodator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الاسم مطلوب';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        RegisterTextefilds(
                          label: 'رقم الهاتف',
                          hint: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          controller: _phoneCtrl,
                          valodator: (value) {
                            if (value == null ||
                                !RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                              return 'رقم موبايل غير صالح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        RegisterTextefilds(
                          label: "البريد الالكتروني",
                          hint: 'Gmail',
                          controller: _emailCtrl,
                          valodator: (value) {
                            if (value == null ||
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                              return 'الإيميل مش صحيح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        RegisterTextefilds(
                          label: 'كلمة المرور',
                          hint: 'Password',
                          controller: _passCtrl,
                          valodator: (value) {
                            if (value == null || value.length < 6) {
                              return 'كلمة السر لازم تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        RegisterTextefilds(
                          label: "تاكيد كلمة المرور",
                          obscure: true,
                          hint: 'password confirm',
                          controller: _confirmCtrl,
                          valodator: (value) {
                            if (value != _passCtrl.text) {
                              return 'كلمة السر مش متطابقة';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        RegisterTextefilds(
                          label: "المحافظه & المدينه",
                          hint: 'city',
                          controller: _cityCtrl,
                          valodator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'المدينة مطلوبة';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    )),
                HeaderText(
                  Title: "اختر نوع الحساب",
                ),
                showvalidation == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "***يجب اختيار نوع الحساب للمتابعه ***",
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
                HearafyUserSelectionSection(
                  activeindex: activeIndex,
                  onindexcahnge: updateActiveIndex,
                ),
                SizedBox(height: 16.h),
                have_image == true
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
                RegisterImagePicker(
                  label: 'صورة البروفايل',
                  get_image: getimage,
                ),
                is_selected == true
                    ? Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(18.r),
                        height: 300.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                width: 2, color: lightColorScheme.primary),
                            image: DecorationImage(
                              image: FileImage(File(filee!.path)),
                              fit: BoxFit.contain,
                            )),
                      )
                    : SizedBox(height: 16.h),
                SizedBox(height: 16.h),
                AuthPrimaryButton(
                  button_label: "التالي",
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (activeIndex == 0 || activeIndex == 1) {
                        setState(() {
                          showvalidation = false;
                        });
                        if (is_selected == true) {
                          setState(() {
                            have_image = false;
                          });
                          print("you have sucess with the login ");
                          // here i will make the cheks on the role of the registrations ============================================

                          // Create base registration data
                          final registrationData = RegistrationData(
                            fullName: _nameCtrl.text.trim(),
                            phone: _phoneCtrl.text.trim(),
                            email: _emailCtrl.text.trim(),
                            password: _passCtrl.text,
                            location: _cityCtrl.text.trim(),
                            role: activeIndex == 0
                                ? UserRole.worker
                                : UserRole.customer,
                            profileImage: filee,
                          );

                          if (activeIndex == 0) {
                            // Navigate to worker registration page
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HearafyRegisterPage(
                                      registrationData: registrationData,
                                    )));
                          } else if (activeIndex == 1) {
                            // Navigate to customer registration page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserRegisterPage(
                                        registrationData: registrationData,
                                      )),
                            );
                          }
                        } else {
                          setState(() {
                            have_image = true;
                          });
                        }
                      } else {
                        setState(() {
                          showvalidation = true;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
