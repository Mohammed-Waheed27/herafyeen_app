import 'package:equatable/equatable.dart';
import '../../../../core/models/user_model.dart';

class AuthResponse extends Equatable {
  final String token;
  final UserModel user;

  const AuthResponse({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [token, user];
}
