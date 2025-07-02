import 'dart:math';
import '../models/user_model.dart';

class UserDataService {
  static final _random = Random();

  // Lists of realistic Arabic names and data
  static const List<String> _arabicFirstNames = [
    'محمد',
    'أحمد',
    'علي',
    'حسن',
    'محمود',
    'عمر',
    'خالد',
    'يوسف',
    'إبراهيم',
    'عبدالله',
    'فاطمة',
    'عائشة',
    'خديجة',
    'مريم',
    'زينب',
    'أسماء',
    'حفصة',
    'أم كلثوم',
    'رقية',
    'سارة'
  ];

  static const List<String> _arabicLastNames = [
    'محمد',
    'أحمد',
    'علي',
    'حسن',
    'محمود',
    'السيد',
    'عبدالرحمن',
    'الدين',
    'إبراهيم',
    'عبدالله',
    'المصري',
    'الشامي',
    'البغدادي',
    'الأندلسي',
    'القاهري',
    'الدمشقي',
    'الحلبي',
    'المغربي'
  ];

  static const List<String> _egyptianLocations = [
    'القاهرة - مدينة نصر',
    'الجيزة - المهندسين',
    'الإسكندرية - سيدي جابر',
    'المنصورة - وسط البلد',
    'طنطا - السيد البدوي',
    'أسيوط - الوليدية',
    'الفيوم - قارون',
    'بني سويف - الكورنيش',
    'المنيا - شارع طه حسين',
    'سوهاج - أخميم',
    'قنا - الدندرة',
    'أسوان - الكورنيش',
    'الإسماعيلية - التجمع',
    'السويس - الأربعين',
    'دمياط - رأس البر',
    'كفر الشيخ - سيدي سالم',
    'البحيرة - دمنهور',
    'الغربية - المحلة الكبرى',
    'الدقهلية - المنصورة',
    'الشرقية - الزقازيق'
  ];

  static const List<String> _jobTitles = [
    'سباك',
    'كهربائي',
    'نجار',
    'نقاش',
    'حداد',
    'ميكانيكي',
    'فني تكييف',
    'مبلط',
    'عامل محارة',
    'فني صيانة',
    'لحام',
    'فني ألوميتال',
    'مقاول',
    'فني جبس بورد',
    'دهان',
    'فني سباكة',
    'فني كهرباء',
    'نجار أثاث',
    'حرفي',
    'عامل بناء'
  ];

  static const List<String> _workingHours = [
    '8:00 ص - 5:00 م',
    '9:00 ص - 6:00 م',
    '7:00 ص - 4:00 م',
    '10:00 ص - 7:00 م',
    '8:30 ص - 5:30 م',
    '9:30 ص - 6:30 م',
    '7:30 ص - 4:30 م',
    '6:00 ص - 3:00 م'
  ];

  static const List<String> _phoneNumbers = [
    '01012345678',
    '01123456789',
    '01234567890',
    '01098765432',
    '01187654321',
    '01076543210',
    '01065432109',
    '01054321098',
    '01043210987',
    '01032109876'
  ];

  /// Generate consistent random data for a user based on their username
  static UserModel generateUserData(
      String username, String email, UserRole role) {
    // Use username hash for consistent random generation
    final hash = username.hashCode.abs();
    final userRandom = Random(hash);

    final firstName =
        _arabicFirstNames[userRandom.nextInt(_arabicFirstNames.length)];
    final lastName =
        _arabicLastNames[userRandom.nextInt(_arabicLastNames.length)];
    final fullName = '$firstName $lastName';

    final location =
        _egyptianLocations[userRandom.nextInt(_egyptianLocations.length)];
    final phone = _phoneNumbers[userRandom.nextInt(_phoneNumbers.length)];

    String? jobTitle;
    String? workingHours;

    if (role == UserRole.worker) {
      jobTitle = _jobTitles[userRandom.nextInt(_jobTitles.length)];
      workingHours = _workingHours[userRandom.nextInt(_workingHours.length)];
    }

    return UserModel(
      id: username, // Use username as ID for consistency
      username: username,
      fullName: fullName,
      email: email,
      role: role,
      location: location,
      phone: phone,
      jobTitle: jobTitle,
      workingHours: workingHours,
      profileImageUrl: null, // Will be set when user uploads image
      idCardImageUrl: null,
      isActive: role == UserRole.customer
          ? true
          : userRandom.nextBool(), // Workers can be inactive
    );
  }

  /// Generate random workers data for home page and categories
  static List<Map<String, dynamic>> generateWorkersForCategory(String category,
      {int count = 10}) {
    final workers = <Map<String, dynamic>>[];

    for (int i = 0; i < count; i++) {
      final userRandom = Random(category.hashCode + i);
      final firstName =
          _arabicFirstNames[userRandom.nextInt(_arabicFirstNames.length)];
      final lastName =
          _arabicLastNames[userRandom.nextInt(_arabicLastNames.length)];

      workers.add({
        'id': 'worker_${category}_$i',
        'name': '$firstName $lastName',
        'profession': category,
        'rating':
            (userRandom.nextDouble() * 2 + 3).toStringAsFixed(1), // 3.0 - 5.0
        'experience': userRandom.nextInt(15) + 1, // 1-15 years
        'completedWorks': userRandom.nextInt(300) + 50, // 50-350 works
        'phone': _phoneNumbers[userRandom.nextInt(_phoneNumbers.length)],
        'location':
            _egyptianLocations[userRandom.nextInt(_egyptianLocations.length)],
        'workingHours': _workingHours[userRandom.nextInt(_workingHours.length)],
        'imageUrl':
            'assets/images/w${(userRandom.nextInt(3) + 1)}.jpg', // w1.jpg, w2.jpg, w3.jpg
        'bio': _generateWorkerBio(category, firstName),
      });
    }

    return workers;
  }

  /// Generate chat sessions for a user
  static List<Map<String, dynamic>> generateChatSessions(String userId,
      {int count = 5}) {
    final sessions = <Map<String, dynamic>>[];
    final userRandom = Random(userId.hashCode);

    for (int i = 0; i < count; i++) {
      final firstName =
          _arabicFirstNames[userRandom.nextInt(_arabicFirstNames.length)];
      final lastName =
          _arabicLastNames[userRandom.nextInt(_arabicLastNames.length)];
      final profession = _jobTitles[userRandom.nextInt(_jobTitles.length)];

      final messages = [
        'مرحباً، كيف يمكنني مساعدتك؟',
        'متاح للعمل اليوم',
        'شكراً لتواصلك معي',
        'سأكون متاح غداً',
        'تم الانتهاء من العمل بنجاح'
      ];

      sessions.add({
        'id': 'session_${userId}_$i',
        'workerName': '$firstName $lastName',
        'profession': profession,
        'lastMessage': messages[userRandom.nextInt(messages.length)],
        'time': _generateRandomTime(userRandom),
        'hasUnread': userRandom.nextBool(),
        'isActive': userRandom.nextBool(),
      });
    }

    return sessions;
  }

  /// Generate reservations for a user
  static List<Map<String, dynamic>> generateReservations(String userId,
      {int count = 6}) {
    final reservations = <Map<String, dynamic>>[];
    final userRandom = Random(userId.hashCode + 1000);

    final statuses = ['accepted', 'pending', 'rejected', 'completed'];

    for (int i = 0; i < count; i++) {
      final firstName =
          _arabicFirstNames[userRandom.nextInt(_arabicFirstNames.length)];
      final lastName =
          _arabicLastNames[userRandom.nextInt(_arabicLastNames.length)];
      final profession = _jobTitles[userRandom.nextInt(_jobTitles.length)];
      final status = statuses[userRandom.nextInt(statuses.length)];

      reservations.add({
        'id': 'reservation_${userId}_$i',
        'workerName': '$firstName $lastName',
        'profession': profession,
        'status': status,
        'date': _generateRandomDate(userRandom),
        'location':
            _egyptianLocations[userRandom.nextInt(_egyptianLocations.length)],
        'price': (userRandom.nextDouble() * 500 + 100)
            .toStringAsFixed(0), // 100-600 EGP
        'description': _generateWorkDescription(profession),
      });
    }

    return reservations;
  }

  static String _generateWorkerBio(String profession, String name) {
    final bios = {
      'سباك':
          'خبرة $name في أعمال السباكة لأكثر من 10 سنوات. متخصص في تركيب وصيانة جميع أنواع المواسير والأدوات الصحية.',
      'كهربائي':
          'فني كهرباء محترف مع خبرة واسعة في التركيبات المنزلية والصناعية. ضمان على جميع الأعمال.',
      'نجار':
          'حرفي نجارة ماهر في صناعة وتركيب الأثاث الخشبي. جودة عالية وأسعار مناسبة.',
      'نقاش':
          'رسام ونقاش محترف. متخصص في الدهانات الحديثة والديكورات الداخلية.',
    };

    return bios[profession] ??
        'حرفي محترف ومتمرس في مجال $profession. جودة عالية في العمل مع الالتزام بالمواعيد.';
  }

  static String _generateWorkDescription(String profession) {
    final descriptions = {
      'سباك': 'إصلاح تسريب في المطبخ وتركيب حنفية جديدة',
      'كهربائي': 'تركيب إضاءة جديدة في الصالة وإصلاح مفاتيح الكهرباء',
      'نجار': 'صناعة دولاب ملابس خشبي حسب المقاسات المطلوبة',
      'نقاش': 'دهان شقة كاملة بألوان حديثة ونظيفة',
    };

    return descriptions[profession] ?? 'عمل متخصص في مجال $profession';
  }

  static String _generateRandomTime(Random random) {
    final times = ['منذ دقائق', '10:30', '11:45', 'أمس', 'الأحد', 'الاثنين'];
    return times[random.nextInt(times.length)];
  }

  static String _generateRandomDate(Random random) {
    final now = DateTime.now();
    final randomDays = random.nextInt(30);
    final date = now.subtract(Duration(days: randomDays));

    final arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
  }
}
 