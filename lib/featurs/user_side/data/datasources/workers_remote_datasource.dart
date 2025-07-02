import 'dart:math';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/user_data_service.dart';

abstract class WorkersRemoteDataSource {
  Future<List<UserModel>> getWorkers({String? jobTitle, String? location});
  Future<UserModel> getWorkerDetails(String workerId);
  Future<Map<String, dynamic>> requestWork({
    required String workerId,
    required String description,
    required String location,
    required double price,
  });
  Future<List<Map<String, dynamic>>> getMyRequests();
}

class WorkersRemoteDataSourceImpl implements WorkersRemoteDataSource {
  final ApiClient apiClient;

  WorkersRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<UserModel>> getWorkers(
      {String? jobTitle, String? location}) async {
    print(
        '🌍 WorkersDataSource: Getting workers with jobTitle: $jobTitle, location: $location');

    // For now, use fallback data to avoid API issues
    print('🌍 WorkersDataSource: Using fallback generated data');
    return _generateFallbackWorkers(jobTitle ?? 'عام');
  }

  @override
  Future<UserModel> getWorkerDetails(String workerId) async {
    print('🌍 WorkersDataSource: Getting worker details for ID: $workerId');

    // For now, use fallback data
    print('🌍 WorkersDataSource: Using fallback generated data for worker');
    return _generateFallbackWorkerDetails(workerId);
  }

  @override
  Future<Map<String, dynamic>> requestWork({
    required String workerId,
    required String description,
    required String location,
    required double price,
  }) async {
    print('🌍 WorkersDataSource: Requesting work from worker: $workerId');
    print('🌍 WorkersDataSource: Description: $description');
    print('🌍 WorkersDataSource: Location: $location');
    print('🌍 WorkersDataSource: Price: $price');

    // Simulate work request success
    print('🌍 WorkersDataSource: Simulating work request success');
    return {
      'success': true,
      'message': 'تم إرسال طلب العمل بنجاح',
      'requestId': 'req_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getMyRequests() async {
    print('🌍 WorkersDataSource: Getting user\'s work requests');

    // Return empty list for now
    print('🌍 WorkersDataSource: Returning empty requests list');
    return [];
  }

  // Fallback methods for when API is not available
  List<UserModel> _generateFallbackWorkers(String category) {
    final workersData =
        UserDataService.generateWorkersForCategory(category, count: 8);

    return workersData.map((workerData) {
      return UserModel(
        id: workerData['id'],
        username: workerData['name'].replaceAll(' ', '_').toLowerCase(),
        fullName: workerData['name'],
        email:
            '${workerData['name'].replaceAll(' ', '_').toLowerCase()}@herafy.com',
        role: UserRole.worker,
        location: workerData['location'],
        phone: workerData['phone'],
        jobTitle: workerData['profession'],
        workingHours: workerData['workingHours'],
        profileImageUrl: null,
        isActive: true,
        rating: double.tryParse(workerData['rating']),
        reviewCount: workerData['completedWorks'],
      );
    }).toList();
  }

  UserModel _generateFallbackWorkerDetails(String workerId) {
    // Use workerId to generate consistent data
    final hash = workerId.hashCode.abs();
    final random = Random(hash);

    final firstNames = ['محمد', 'أحمد', 'علي', 'حسن', 'محمود'];
    final lastNames = ['محمد', 'أحمد', 'السيد', 'عبدالرحمن', 'المصري'];
    final jobTitles = ['سباك', 'كهربائي', 'نجار', 'نقاش', 'حداد'];
    final locations = [
      'القاهرة - مدينة نصر',
      'الجيزة - المهندسين',
      'الإسكندرية - سيدي جابر'
    ];

    return UserModel(
      id: workerId,
      username: 'worker_$workerId',
      fullName:
          '${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}',
      email: 'worker_$workerId@herafy.com',
      role: UserRole.worker,
      location: locations[random.nextInt(locations.length)],
      phone: '0101234567${random.nextInt(10)}',
      jobTitle: jobTitles[random.nextInt(jobTitles.length)],
      workingHours: '9:00 ص - 5:00 م',
      profileImageUrl: null,
      isActive: true,
      rating: (random.nextDouble() * 2 + 3),
      reviewCount: random.nextInt(300) + 50,
    );
  }
}
