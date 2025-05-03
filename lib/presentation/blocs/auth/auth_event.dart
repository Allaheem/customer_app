part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event triggered when the user attempts to log in
class LoginRequested extends AuthEvent {
  final String identifier; // Can be phone number or email
  final String password;

  const LoginRequested({required this.identifier, required this.password});

  @override
  List<Object> get props => [identifier, password];
}

// Event triggered when the user attempts to sign up
class SignUpRequested extends AuthEvent {
  final String name;
  final String identifier; // Can be phone number or email
  final String password;

  const SignUpRequested({
    required this.name,
    required this.identifier,
    required this.password,
  });

  @override
  List<Object> get props => [name, identifier, password];
}

// Event triggered when the user requests a password reset
class PasswordResetRequested extends AuthEvent {
  final String identifier; // Can be phone number or email

  const PasswordResetRequested({required this.identifier});

  @override
  List<Object> get props => [identifier];
}

// Event triggered when the user verifies the code
class CodeVerificationRequested extends AuthEvent {
  final String identifier; // Can be phone number or email
  final String code;

  const CodeVerificationRequested({required this.identifier, required this.code});

   @override
  List<Object> get props => [identifier, code];
}

// Event triggered when the user logs out
class LogoutRequested extends AuthEvent {}

// Event triggered internally to check initial auth status
class AuthStatusChanged extends AuthEvent {
  final AuthStatus status;
  const AuthStatusChanged(this.status);

   @override
  List<Object> get props => [status];
}

// Enum to represent authentication status
enum AuthStatus { unknown, authenticated, unauthenticated }

