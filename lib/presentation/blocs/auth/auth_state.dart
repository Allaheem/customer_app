part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state before any action is taken
class AuthInitial extends AuthState {}

// State when an authentication operation is in progress
class AuthLoading extends AuthState {}

// State when the user is successfully authenticated
class AuthSuccess extends AuthState {
  // Optionally, include user data here
  // final User user;
  // const AuthSuccess({required this.user});
  // @override List<Object?> get props => [user];
}

// State when the user is not authenticated
class AuthUnauthenticated extends AuthState {}

// State when an authentication operation fails
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// State after successfully requesting a password reset code
class PasswordResetCodeSent extends AuthState {
   final String identifier; // To pass to the verification screen
   const PasswordResetCodeSent({required this.identifier});
   @override
   List<Object?> get props => [identifier];
}

// State after successfully verifying the code (for password reset or sign up)
class CodeVerified extends AuthState {
  // Optionally include data needed for the next step, e.g., reset token
}

