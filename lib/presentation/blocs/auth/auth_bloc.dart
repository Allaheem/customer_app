import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// TODO: Create and inject an AuthenticationRepository

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final AuthenticationRepository _authenticationRepository;

  AuthBloc(/*{required AuthenticationRepository authenticationRepository}*/) 
      // : _authenticationRepository = authenticationRepository,
        : super(AuthInitial()) {

    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<CodeVerificationRequested>(_onCodeVerificationRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);

    // TODO: Check initial authentication status (e.g., check for stored token)
    // add(const AuthStatusChanged(AuthStatus.unauthenticated)); // Example initial state
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Call repository login method
      // await _authenticationRepository.logIn(
      //   identifier: event.identifier,
      //   password: event.password,
      // );
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      // Assuming login is successful for now
      emit(AuthSuccess());
      add(const AuthStatusChanged(AuthStatus.authenticated));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
      add(const AuthStatusChanged(AuthStatus.unauthenticated));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Call repository sign up method
      // await _authenticationRepository.signUp(
      //   name: event.name,
      //   identifier: event.identifier,
      //   password: event.password,
      // );
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      // Assuming sign up requires verification
      emit(PasswordResetCodeSent(identifier: event.identifier)); // Reusing state, might need a specific SignUpVerificationSent state
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onPasswordResetRequested(PasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Call repository password reset request method
      // await _authenticationRepository.requestPasswordReset(identifier: event.identifier);
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      emit(PasswordResetCodeSent(identifier: event.identifier));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

   Future<void> _onCodeVerificationRequested(CodeVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Call repository code verification method
      // await _authenticationRepository.verifyCode(
      //   identifier: event.identifier,
      //   code: event.code,
      // );
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      // Assuming verification is successful
      emit(CodeVerified());
      // Depending on the flow (sign up or password reset), navigate accordingly
      // If it was sign up, maybe emit AuthSuccess or navigate to login
      // If it was password reset, navigate to a screen to set a new password
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }


  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // TODO: Call repository logout method
      // await _authenticationRepository.logOut();
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate operation
      emit(AuthUnauthenticated());
      add(const AuthStatusChanged(AuthStatus.unauthenticated));
    } catch (e) {
      emit(AuthFailure(error: e.toString())); // Or just go to unauthenticated
      emit(AuthUnauthenticated());
      add(const AuthStatusChanged(AuthStatus.unauthenticated));
    }
  }

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
     switch (event.status) {
      case AuthStatus.authenticated:
        emit(AuthSuccess()); // Or emit state with user data
        break;
      case AuthStatus.unauthenticated:
        emit(AuthUnauthenticated());
        break;
      case AuthStatus.unknown:
        emit(AuthInitial());
        break;
    }
  }
}

