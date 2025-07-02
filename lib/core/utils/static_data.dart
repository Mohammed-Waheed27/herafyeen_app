import '../models/user_model.dart';

class StaticData {
  // Sample workers data
  static List<UserModel> sampleWorkers = [
    const UserModel(
      id: '1',
      username: 'ahmed_plumber',
      fullName: 'أحمد محمد السباك',
      email: 'ahmed@example.com',
      role: UserRole.worker,
      location: 'القاهرة، مصر الجديدة',
      jobTitle: 'سباك',
      workingHours: '8:00 AM - 6:00 PM',
      phone: '+20 123 456 7890',
      profileImageUrl: 'https://via.placeholder.com/150',
      isActive: true,
      rating: 4.8,
      reviewCount: 25,
    ),
    const UserModel(
      id: '2',
      username: 'sara_electrician',
      fullName: 'سارة أحمد الكهربائي',
      email: 'sara@example.com',
      role: UserRole.worker,
      location: 'الجيزة، الدقي',
      jobTitle: 'كهربائي',
      workingHours: '9:00 AM - 5:00 PM',
      phone: '+20 123 456 7891',
      profileImageUrl: 'https://via.placeholder.com/150',
      isActive: true,
      rating: 4.6,
      reviewCount: 18,
    ),
    const UserModel(
      id: '3',
      username: 'mohamed_carpenter',
      fullName: 'محمد علي النجار',
      email: 'mohamed@example.com',
      role: UserRole.worker,
      location: 'الإسكندرية، سيدي جابر',
      jobTitle: 'نجار',
      workingHours: '7:00 AM - 4:00 PM',
      phone: '+20 123 456 7892',
      profileImageUrl: 'https://via.placeholder.com/150',
      isActive: true,
      rating: 4.9,
      reviewCount: 32,
    ),
    const UserModel(
      id: '4',
      username: 'fatma_painter',
      fullName: 'فاطمة حسن الدهان',
      email: 'fatma@example.com',
      role: UserRole.worker,
      location: 'القاهرة، المعادي',
      jobTitle: 'دهان',
      workingHours: '8:00 AM - 6:00 PM',
      phone: '+20 123 456 7893',
      profileImageUrl: 'https://via.placeholder.com/150',
      isActive: true,
      rating: 4.7,
      reviewCount: 21,
    ),
    const UserModel(
      id: '5',
      username: 'omar_mechanic',
      fullName: 'عمر سمير الميكانيكي',
      email: 'omar@example.com',
      role: UserRole.worker,
      location: 'الجيزة، العجوزة',
      jobTitle: 'ميكانيكي',
      workingHours: '8:00 AM - 7:00 PM',
      phone: '+20 123 456 7894',
      profileImageUrl: 'https://via.placeholder.com/150',
      isActive: true,
      rating: 4.5,
      reviewCount: 15,
    ),
  ];

  // Sample job titles
  static List<String> jobTitles = [
    'سباك',
    'كهربائي',
    'نجار',
    'دهان',
    'ميكانيكي',
    'حداد',
    'بناء',
    'تكييف',
    'تنظيف',
    'حدائق',
  ];

  // Sample locations
  static List<String> locations = [
    'القاهرة، مصر الجديدة',
    'الجيزة، الدقي',
    'الإسكندرية، سيدي جابر',
    'القاهرة، المعادي',
    'الجيزة، العجوزة',
    'القاهرة، التجمع الخامس',
    'الجيزة، الهرم',
    'القاهرة، مدينة نصر',
    'الإسكندرية، العطارين',
    'القاهرة، الزمالك',
  ];

  // Sample current user
  static const UserModel currentUser = UserModel(
    id: 'current_user',
    username: 'user123',
    fullName: 'مستخدم تجريبي',
    email: 'user@example.com',
    role: UserRole.customer,
    location: 'القاهرة، مصر',
    phone: '+20 123 456 7895',
    profileImageUrl: 'https://via.placeholder.com/150',
    isActive: true,
  );
}
