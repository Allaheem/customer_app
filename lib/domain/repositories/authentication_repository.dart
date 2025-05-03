import 'package:equatable/equatable.dart';

// Abstract class defining the authentication repository interface
abstract class AuthenticationRepository extends Equatable {
  // Stream to report authentication status changes (e.g., user logs in/out)
  // Stream<AuthStatus> get status;

  Future<void> logIn({
    required String identifier,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String identifier,
    required String password,
  });

  Future<void> requestPasswordReset({required String identifier});

  Future<void> verifyCode({
    required String identifier,
    required String code,
  });

  // Future<void> resetPassword({
  //   required String token, // Token received after code verification
  //   required String newPassword,
  // });

  Future<void> logOut();

  // Future<User?> getCurrentUser(); // Method to get current user data

  @override
  List<Object?> get props => [];
}

// Placeholder implementation for the Authentication Repository
// This will be replaced with actual API calls later
class MockAuthenticationRepository implements AuthenticationRepository {

  @override
  Future<void> logIn({
    required String identifier,
    required String password,
  }) async {
    // print('Attempting login with identifier: $identifier');
    await Future.delayed(const Duration(seconds: 1));
    if (identifier == 'error@test.com') { // Simulate login error
      throw Exception('Login failed: Invalid credentials');
    }
    // print("Login successful");
    // In a real app, you would store the received token here
  }

  @override
  Future<void> signUp({
    required String name,
    required String identifier,
    required String password,
  }) async {
    // print("Attempting sign up for: $name with identifier: $identifier");
    await Future.delayed(const Duration(seconds: 1));
     if (identifier == 'exists@test.com') { // Simulate existing user error
      throw Exception('Sign up failed: User already exists');
    }
    // print("Sign up request successful, verification needed");
    // In a real app, the backend would send a verification code
  }

  @override
  Future<void> requestPasswordReset({required String identifier}) async {
    // print("Requesting password reset for: $identifier");
    await Future.delayed(const Duration(seconds: 1));
     if (identifier == 'notfound@test.com') { // Simulate user not found error
      throw Exception('Password reset failed: User not found');
    }
    // print("Password reset code sent successfully");
     // In a real app, the backend would send a verification code
  }

  @override
  Future<void> verifyCode({
    required String identifier,
    required String code,
  }) async {
    // print("Verifying code: $code for identifier: $identifier");
    await Future.delayed(const Duration(seconds: 1));
    if (code != '123456') { // Simulate incorrect code
       throw Exception('Verification failed: Invalid code');
    }
    // print("Code verified successfully");
    // In a real app, the backend would return a success status or a token for the next step
  }

  @override
  Future<void> logOut() async {
    // print("Logging out");
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, you would clear the stored token here
    // print("Logout successful");
  }

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

