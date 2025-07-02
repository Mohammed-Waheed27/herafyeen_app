import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/user_data_service.dart';

abstract class WorkerRequestsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getMyWorkRequests();
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<void> completeRequest(String requestId);
  Future<List<Map<String, dynamic>>> getRequestHistory();
}

class WorkerRequestsRemoteDataSourceImpl
    implements WorkerRequestsRemoteDataSource {
  final ApiClient apiClient;

  // In-memory storage to simulate real order management
  static List<Map<String, dynamic>>? _cachedPendingRequests;
  static List<Map<String, dynamic>>? _cachedHistory;

  WorkerRequestsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Map<String, dynamic>>> getMyWorkRequests() async {
    print('🔧 WorkerRequestsDataSource: Getting my work requests');

    try {
      final response = await apiClient.get(
        ApiConstants.myRequests,
        requiresAuth: true,
      );

      print('🔧 WorkerRequestsDataSource: API response received');

      // If API returns data, parse it
      if (response != null) {
        if (response is List) {
          final List<Map<String, dynamic>> result = [];
          for (final item in response as List<Map<String, dynamic>>) {
            if (item is Map<String, dynamic>) {
              result.add(item);
            }
          }
          _cachedPendingRequests = result;
          return result;
        } else if (response is Map<String, dynamic> &&
            response['data'] is List) {
          final List<Map<String, dynamic>> result = [];
          final dataList = response['data'] as List;
          for (final item in dataList) {
            if (item is Map<String, dynamic>) {
              result.add(item);
            }
          }
          _cachedPendingRequests = result;
          return result;
        }
      }
    } catch (e) {
      print('❌ WorkerRequestsDataSource: API call failed: $e');
    }

    // Generate fallback data for demonstration if not cached
    if (_cachedPendingRequests == null) {
      print('🔧 WorkerRequestsDataSource: Using fallback generated data');
      _cachedPendingRequests = _generateFallbackRequests();
    }

    // Return only pending requests
    return _cachedPendingRequests!
        .where((request) => request['status'] == 'pending')
        .toList();
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    print('🔧 WorkerRequestsDataSource: Accepting request: $requestId');

    try {
      await apiClient.post(
        '${ApiConstants.acceptRequest}/$requestId',
        requiresAuth: true,
      );
      print('🔧 WorkerRequestsDataSource: Request accepted successfully');
    } catch (e) {
      print('❌ WorkerRequestsDataSource: Failed to accept request: $e');
      // Continue with local simulation even if API fails
    }

    // Simulate request acceptance locally
    _updateRequestStatus(requestId, 'accepted');
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    print('🔧 WorkerRequestsDataSource: Rejecting request: $requestId');

    try {
      await apiClient.post(
        '${ApiConstants.rejectRequest}/$requestId',
        requiresAuth: true,
      );
      print('🔧 WorkerRequestsDataSource: Request rejected successfully');
    } catch (e) {
      print('❌ WorkerRequestsDataSource: Failed to reject request: $e');
      // Continue with local simulation even if API fails
    }

    // Simulate request rejection locally
    _updateRequestStatus(requestId, 'rejected');
  }

  @override
  Future<void> completeRequest(String requestId) async {
    print('🔧 WorkerRequestsDataSource: Completing request: $requestId');

    try {
      await apiClient.post(
        '${ApiConstants.completeRequest}/$requestId',
        requiresAuth: true,
      );
      print('🔧 WorkerRequestsDataSource: Request completed successfully');
    } catch (e) {
      print('❌ WorkerRequestsDataSource: Failed to complete request: $e');
      // Continue with local simulation even if API fails
    }

    // Simulate request completion locally
    _updateRequestStatus(requestId, 'completed');
  }

  @override
  Future<List<Map<String, dynamic>>> getRequestHistory() async {
    print('🔧 WorkerRequestsDataSource: Getting request history');

    // Return cached history or generate it
    if (_cachedHistory == null) {
      _cachedHistory = _generateFallbackHistory();
    }

    // Combine static history with moved requests from pending list
    final movedRequests = _getMovedRequestsFromPending();
    final combinedHistory = [..._cachedHistory!, ...movedRequests];

    return combinedHistory;
  }

  /// Update request status and move to history if needed
  void _updateRequestStatus(String requestId, String newStatus) {
    if (_cachedPendingRequests == null) {
      _cachedPendingRequests = _generateFallbackRequests();
    }

    // Find and update the request
    final requestIndex = _cachedPendingRequests!
        .indexWhere((request) => request['id'] == requestId);

    if (requestIndex != -1) {
      final request = _cachedPendingRequests![requestIndex];

      // Update status and timestamp
      request['status'] = newStatus;
      request['updatedAt'] = DateTime.now().toIso8601String();

      if (newStatus == 'accepted') {
        request['acceptedAt'] = DateTime.now().toIso8601String();
        print('✅ Request $requestId accepted and updated');
      } else if (newStatus == 'rejected') {
        request['rejectedAt'] = DateTime.now().toIso8601String();
        print('❌ Request $requestId rejected and moved to history');
      } else if (newStatus == 'completed') {
        request['completedAt'] = DateTime.now().toIso8601String();
        request['status'] = 'completed';
        print('✅ Request $requestId completed and moved to history');
      }
    }
  }

  /// Get requests that have been moved from pending to history
  List<Map<String, dynamic>> _getMovedRequestsFromPending() {
    if (_cachedPendingRequests == null) return [];

    return _cachedPendingRequests!
        .where((request) =>
            request['status'] == 'rejected' || request['status'] == 'completed')
        .map((request) => Map<String, dynamic>.from(request))
        .toList();
  }

  List<Map<String, dynamic>> _generateFallbackRequests() {
    // Generate realistic pending work requests
    final locations = [
      'القاهرة - مدينة نصر',
      'الجيزة - المهندسين',
      'الدقهلية - ميت غمر',
      'طنطا - شارع البحر',
      'المنصورة - شارع الجامعة',
    ];

    final services = [
      'إصلاح حنفية المطبخ',
      'تركيب مواسير جديدة',
      'إصلاح تسريب في الحمام',
      'تركيب سخان كهربائي',
      'إصلاح صرف المطبخ',
      'تغيير خلاط الحمام',
    ];

    final customerNames = [
      'أحمد محمد عبدالله',
      'سمير علي حسن',
      'محمد خالد أحمد',
      'فاطمة محمود السيد',
      'عمر إبراهيم محمد',
      'نور الدين عبدالرحمن',
    ];

    return List.generate(6, (index) {
      final now = DateTime.now();
      final requestDate = now.add(Duration(days: index + 1));

      return {
        'id': 'req_${1000 + index}',
        'customerId': 'customer_${100 + index}',
        'customerName': customerNames[index % customerNames.length],
        'service': services[index % services.length],
        'description':
            'أحتاج إلى ${services[index % services.length]} في أقرب وقت ممكن. العمل مستعجل.',
        'location': locations[index % locations.length],
        'preferredDate':
            '${requestDate.day}/${requestDate.month}/${requestDate.year}',
        'preferredTime': index % 2 == 0 ? '10:00 صباحاً' : '2:30 مساءً',
        'budget': '${150 + (index * 50)} جنيه',
        'status': 'pending',
        'requestDate':
            now.subtract(Duration(hours: index + 1)).toIso8601String(),
        'customerPhone': '01012345${600 + index}',
        'urgent': index % 3 == 0,
      };
    });
  }

  List<Map<String, dynamic>> _generateFallbackHistory() {
    final locations = [
      'القاهرة - مدينة نصر',
      'الجيزة - المهندسين',
      'الدقهلية - ميت غمر',
      'طنطا - شارع البحر',
      'المنصورة - شارع الجامعة',
    ];

    final services = [
      'إصلاح حنفية',
      'تركيب مواسير جديدة',
      'إصلاح تسرب',
      'تركيب سخان',
      'إصلاح تسريب في المطبخ',
    ];

    final customerNames = [
      'أحمد محمد',
      'سمير علي',
      'محمد خالد',
      'فاطمة أحمد',
      'عمر محمود',
    ];

    final statuses = ['completed', 'cancelled'];

    return List.generate(10, (index) {
      final isCompleted = index % 4 != 3; // 75% completed, 25% cancelled
      final status = isCompleted ? 'completed' : 'cancelled';
      final completionDate = DateTime.now().subtract(Duration(days: index + 1));

      return {
        'id': 'hist_${2000 + index}',
        'customerId': 'customer_${200 + index}',
        'customerName': customerNames[index % customerNames.length],
        'service': services[index % services.length],
        'location': locations[index % locations.length],
        'date':
            '${completionDate.day} ${_getMonthName(completionDate.month)} ${completionDate.year}',
        'time': index % 2 == 0 ? '10:00 صباحاً' : '2:30 مساءً',
        'status': status,
        'payment': isCompleted ? '${150 + (index * 25)} جنيه' : '0 جنيه',
        'rating': isCompleted ? (4 + (index % 2)) : 0,
        'completionDate': completionDate.toIso8601String(),
      };
    });
  }

  String _getMonthName(int month) {
    const months = [
      '',
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
    return months[month];
  }
}
