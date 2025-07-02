class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://finalprojact.runasp.net';

  // Auth endpoints
  static const String register = '/api/Auth/register';
  static const String login = '/api/Auth/login';
  static const String logout = '/api/Auth/logout';
  static const String inactiveWorkers = '/api/Auth/inactive-workers';
  static const String activateWorker = '/api/Auth/activate-worker';

  // Chat endpoints
  static const String createSession = '/api/Chat/create-session';
  static const String sendMessage = '/api/Chat/send-message';
  static const String getMessages = '/api/Chat/messages';
  static const String closeSession = '/api/Chat/close-session';
  static const String mySessions = '/api/Chat/my-sessions';

  // Profile endpoints
  static const String updateProfile = '/api/Profile/update-profile';
  static const String deleteProfile = '/api/Profile/delete-profile';

  // Work endpoints
  static const String requestWork = '/api/Work/request-work';
  static const String getWorkers = '/api/Work/workers';
  static const String getWorker = '/api/Work/worker';
  static const String myRequests = '/api/Work/my-requests';
  static const String acceptRequest = '/api/Work/accept-request';
  static const String rejectRequest = '/api/Work/reject-request';
  static const String completeRequest = '/api/Work/complete-request';
  static const String rateWorker = '/api/Work/rate-worker';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, String> multipartHeaders = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  };
}
