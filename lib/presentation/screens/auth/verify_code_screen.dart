import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: Import AuthBloc, AuthEvent, AuthState
// import '../blocs/auth/auth_bloc.dart';

// Placeholder for AuthBloc, AuthEvent, AuthState - replace with actual imports
class AuthBloc extends Bloc<AuthEvent, AuthState> { AuthBloc() : super(AuthInitial()); }
abstract class AuthEvent {}
class CodeVerificationRequested extends AuthEvent { final String identifier; final String code; CodeVerificationRequested({required this.identifier, required this.code}); }
// TODO: Add ResendCodeRequested event if needed
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthFailure extends AuthState { final String error; AuthFailure({required this.error}); }
class CodeVerified extends AuthState {}
// End Placeholder

class VerifyCodeScreen extends StatefulWidget {
  final String verificationTarget; // Phone number or email

  const VerifyCodeScreen({super.key, required this.verificationTarget});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement localization (Arabic/English)
    // TODO: Implement theme (Black/Gold)
    // TODO: Provide AuthBloc instance via BlocProvider higher in the widget tree

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code / التحقق من الرمز'), // Placeholder
        backgroundColor: Colors.black, // Placeholder theme
        iconTheme: const IconThemeData(color: Colors.amber), // Placeholder theme
      ),
      backgroundColor: Colors.black, // Placeholder theme
      body: BlocListener<AuthBloc, AuthState>(
        // TODO: Replace with actual AuthBloc import
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("Verification Failed: ${state.error} / فشل التحقق: ${state.error}")), // Placeholder
              );
          } else if (state is CodeVerified) {
            // TODO: Navigate to the next screen based on the flow (e.g., Reset Password or Home)
            // print("Code Verified - Navigate to next screen");
            // Example: Pop until login screen and then push home, or push reset password screen
            Navigator.popUntil(context, (route) => route.isFirst); // Example: Go back to the initial screen after verification
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enter the verification code sent to / أدخل رمز التحقق المرسل إلى \n${widget.verificationTarget}', // Placeholder
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16), // Placeholder theme
                ),
                const SizedBox(height: 30),
                // Placeholder for OTP input field (e.g., using PinCodeTextField package)
                TextFormField(
                  controller: _codeController,
                  decoration: _buildInputDecoration('Verification Code / رمز التحقق'), // Placeholder
                  style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 8), // Placeholder theme
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6, // Assuming a 6-digit code
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the code / الرجاء إدخال الرمز'; // Placeholder
                    }
                    if (value.length != 6) {
                       return 'Code must be 6 digits / يجب أن يتكون الرمز من 6 أرقام'; // Placeholder
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  // TODO: Replace with actual AuthBloc import
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber, // Placeholder theme
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      CodeVerificationRequested(
                                        identifier: widget.verificationTarget,
                                        code: _codeController.text,
                                      ),
                                    );
                              }
                            },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'Verify / تحقق', // Placeholder
                              style: TextStyle(color: Colors.black, fontSize: 16), // Placeholder theme
                            ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // TODO: Implement resend code logic (dispatch event to BLoC)
                     // print("Resend Code Requested");
                     // Example: context.read<AuthBloc>().add(ResendCodeRequested(identifier: widget.verificationTarget));
                  },
                  child: const Text(
                    'Didn\'t receive the code? Resend / لم تستلم الرمز؟ إعادة إرسال', // Placeholder
                    style: TextStyle(color: Colors.amber), // Placeholder theme
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.amber), // Placeholder theme
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber.shade200), // Placeholder theme
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber), // Placeholder theme
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red), // Placeholder theme
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2), // Placeholder theme
      ),
      counterText: "", // Hide the counter text
    );
  }
}

