String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'الاسم مطلوب';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || !RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
    return 'رقم موبايل غير صالح';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null ||
      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'الإيميل مش صحيح';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 6) {
    return 'كلمة السر لازم تكون 6 أحرف على الأقل';
  }
  return null;
}

// For confirmation, capture original password in state:
String? validateConfirm(String? value, String original) {
  if (value != original) {
    return 'كلمة السر مش متطابقة';
  }
  return null;
}

String? validateCity(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'المدينة مطلوبة';
  }
  return null;
}
