import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../auth/presentation/pages/register_pages_login_pages/widgets/register_textefilds.dart';

class UserSideApplicationPage extends StatefulWidget {
  final String? workerId;
  final String? workerName;
  final String? profession;

  const UserSideApplicationPage({
    super.key,
    this.workerId,
    this.workerName,
    this.profession,
  });

  @override
  State<UserSideApplicationPage> createState() =>
      _UserSideApplicationPageState();
}

class _UserSideApplicationPageState extends State<UserSideApplicationPage> {
  final locationCtr = TextEditingController();
  final priceCtr = TextEditingController();
  final discriptonCtr = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    locationCtr.dispose();
    priceCtr.dispose();
    discriptonCtr.dispose();
    super.dispose();
  }

  Future<void> _submitWorkRequest() async {
    if (!formKey.currentState!.validate()) return;

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.workerName != null
                ? 'تم إرسال طلب العمل إلى ${widget.workerName} بنجاح'
                : 'تم إرسال طلب العمل بنجاح',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Go back to previous screen
      Navigator.pop(context);
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء إرسال الطلب، يرجى المحاولة مرة أخرى',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.workerName != null
              ? "حجز ${widget.profession} - ${widget.workerName}"
              : "تقديم طلب لحجز الحرفي",
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: lightColorScheme.primary, fontSize: 20.sp),
        ),
        backgroundColor: lightColorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  RegisterTextefilds(
                    label: "مكان الشغل فين",
                    hint: "مثلا الدقهليه المنصوره شارع الجامعه",
                    controller: locationCtr,
                    valodator: (valu) {
                      if (valu!.isEmpty) {
                        return "عنوان الشغل مطلوب";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  RegisterTextefilds(
                    label: "السعر الي انت حابب تدفعه",
                    hint: "50",
                    controller: priceCtr,
                    valodator: (valu) {
                      if (valu!.isEmpty) {
                        return "السعر مطلوب";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  RegisterTextefilds(
                    label: "تفاصيل الشغل",
                    hint: "حاول ان تكون واضحا ف التفاصيل",
                    controller: discriptonCtr,
                    maxlines: 6,
                    valodator: (valu) {
                      if (valu!.isEmpty) {
                        return "تفاصيل الشغل مطلوبه";
                      }
                      return null;
                    },
                  ),
                  // Add some bottom padding to avoid overlap with buttons
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 150.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 2, color: lightColorScheme.primary),
                ),
                child: Center(
                  child: Text(
                    "الغاء",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  _submitWorkRequest();
                }
              },
              child: Container(
                width: 150.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: lightColorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    "ارسال",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
