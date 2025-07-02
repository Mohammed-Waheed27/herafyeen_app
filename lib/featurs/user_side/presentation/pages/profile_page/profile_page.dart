import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../theme/color/app_theme.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../../core/models/user_model.dart';
import '../../bloc/profile_bloc.dart';
import '../../../../../featurs/auth/presentation/pages/login&signup secton/login_signup_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _jobTitleController = TextEditingController();

  File? _selectedImage;
  UserModel? _currentUser;
  bool _isEditing = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  void _loadUserData(UserModel user) {
    _currentUser = user;
    _fullNameController.text = user.fullName;
    _phoneController.text = user.phone ?? '';
    _locationController.text = user.location ?? '';
    _jobTitleController.text = user.jobTitle ?? '';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      AppSnackBar.showError(context, 'خطأ في اختيار الصورة');
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            UpdateProfileEvent(
              fullName: _fullNameController.text.trim(),
              phone: _phoneController.text.trim(),
              location: _locationController.text.trim(),
              jobTitle: _currentUser?.role == UserRole.worker
                  ? _jobTitleController.text.trim()
                  : null,
              profileImage: _selectedImage,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load user data when the page is built
    context.read<ProfileBloc>().add(const GetCurrentUserEvent());

    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            color: lightColorScheme.scrim,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: lightColorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _loadUserData(state.user);
          } else if (state is ProfileUpdateSuccess) {
            AppSnackBar.showSuccess(context, "تم تحديث الملف الشخصي بنجاح");
            _loadUserData(state.user);
            setState(() {
              _isEditing = false;
              _selectedImage = null;
            });
          } else if (state is LogoutSuccess) {
            AppSnackBar.showSuccess(context, "تم تسجيل الخروج بنجاح");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginSignupPage(),
              ),
              (route) => false,
            );
          } else if (state is ProfileError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 64.r,
                    color: lightColorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'خطأ في تحميل البيانات',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.scrim,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: lightColorScheme.surface,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProfileBloc>()
                          .add(const GetCurrentUserEvent());
                    },
                    child: const Text('محاولة مرة أخرى'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile Image Section
                      _buildProfileImageSection(),
                      SizedBox(height: 24.h),

                      // Profile Information Form
                      _buildProfileForm(),

                      if (_isEditing) ...[
                        SizedBox(height: 24.h),
                        _buildActionButtons(),
                      ],

                      // Logout button
                      if (!_isEditing) ...[
                        SizedBox(height: 32.h),
                        _buildLogoutButton(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60.r,
            backgroundColor: lightColorScheme.primary,
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!) as ImageProvider
                : (_currentUser?.profileImageUrl != null
                    ? NetworkImage(_currentUser!.profileImageUrl!)
                        as ImageProvider
                    : null),
            child: (_selectedImage == null &&
                    _currentUser?.profileImageUrl == null)
                ? Text(
                    _currentUser?.fullName.isNotEmpty == true
                        ? _currentUser!.fullName[0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      color: lightColorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
                    ),
                  )
                : null,
          ),
          if (_isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: lightColorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: lightColorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: lightColorScheme.onPrimary,
                    size: 16.r,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _fullNameController,
          label: 'الاسم الكامل',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'الاسم مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null &&
                value.isNotEmpty &&
                !RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
              return 'رقم هاتف غير صالح';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _locationController,
          label: 'الموقع',
          icon: Icons.location_on,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'الموقع مطلوب';
            }
            return null;
          },
        ),
        if (_currentUser?.role == UserRole.worker) ...[
          SizedBox(height: 16.h),
          _buildTextField(
            controller: _jobTitleController,
            label: 'المهنة',
            icon: Icons.work,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'المهنة مطلوبة';
              }
              return null;
            },
          ),
        ],
        SizedBox(height: 16.h),
        _buildReadOnlyField(
          label: 'البريد الإلكتروني',
          value: _currentUser?.email ?? '',
          icon: Icons.email,
        ),
        SizedBox(height: 16.h),
        _buildReadOnlyField(
          label: 'نوع الحساب',
          value: _currentUser?.role == UserRole.worker ? 'حرفي' : 'عميل',
          icon: Icons.person_outline,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      keyboardType: keyboardType,
      validator: validator,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: lightColorScheme.primary),
        filled: true,
        fillColor: _isEditing
            ? lightColorScheme.onSecondary
            : lightColorScheme.surface.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: lightColorScheme.primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: lightColorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: lightColorScheme.surface),
        filled: true,
        fillColor: lightColorScheme.surface.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
                _selectedImage = null;
                if (_currentUser != null) {
                  _loadUserData(_currentUser!);
                }
              });
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: BorderSide(color: lightColorScheme.surface),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: lightColorScheme.surface,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _updateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: lightColorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'حفظ التغييرات',
              style: TextStyle(
                color: lightColorScheme.onPrimary,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showLogoutDialog();
        },
        icon: Icon(
          Icons.logout,
          color: lightColorScheme.onPrimary,
        ),
        label: Text(
          'تسجيل الخروج',
          style: TextStyle(
            color: lightColorScheme.onPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.error,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    // Capture the ProfileBloc before showing the dialog
    final profileBloc = context.read<ProfileBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: lightColorScheme.error,
              ),
              SizedBox(width: 8.w),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: lightColorScheme.scrim,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد تسجيل الخروج من حسابك؟',
            style: TextStyle(
              color: lightColorScheme.surface,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: lightColorScheme.surface,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Use the captured ProfileBloc reference
                profileBloc.add(const LogoutEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: lightColorScheme.onPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
