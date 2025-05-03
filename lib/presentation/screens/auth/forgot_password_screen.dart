import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: Import AuthBloc, AuthEvent, AuthState, VerifyCodeScreen
// import '../blocs/auth/auth_bloc.dart';
// import 'verify_code_screen.dart';

// Placeholder for AuthBloc, AuthEvent, AuthState - replace with actual imports
class AuthBloc extends Bloc<AuthEvent, AuthState> { AuthBloc() : super(AuthInitial()); }
abstract class AuthEvent {}
class PasswordResetRequested extends AuthEvent { final String identifier; PasswordResetRequested({required this.identifier}); }
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthFailure extends AuthState { final String error; AuthFailure({required this.error}); }
class PasswordResetCodeSent extends AuthState { final String identifier; PasswordResetCodeSent({required this.identifier}); }
// End Placeholder

// Placeholder for VerifyCodeScreen
class VerifyCodeScreen extends StatelessWidget { final String verificationTarget; const VerifyCodeScreen({super.key, required this.verificationTarget}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verify Code'))); }
// End Placeholder

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Define theme variable
    // TODO: Implement localization (Arabic/English)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password / نسيت كلمة المرور'), // Placeholder
        backgroundColor: theme.appBarTheme.backgroundColor, // Placeholder theme
        iconTheme: theme.appBarTheme.iconTheme, // Placeholder theme
      ),
      backgroundColor: theme.scaffoldBackgroundColor, // Placeholder theme
      body: BlocListener<AuthBloc, AuthState>(
        // TODO: Replace with actual AuthBloc import
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("Request Failed: ${state.error} / فشل الطلب: ${state.error}"), backgroundColor: theme.colorScheme.error), // Placeholder
              );
          } else if (state is PasswordResetCodeSent) {
            // print("Password reset code sent - Navigate to Verify Code");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyCodeScreen(verificationTarget: state.identifier),
              ),
            );
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
                  'Enter your phone number or email to receive a verification code. / أدخل رقم هاتفك أو بريدك الإلكتروني لاستلام رمز التحقق.', // Placeholder
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)), // Placeholder theme
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _identifierController,
                  decoration: _buildInputDecoration('Phone Number or Email / رقم الهاتف أو البريد الإلكتروني'), // Placeholder
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), // Placeholder theme
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone or email / الرجاء إدخال الهاتف أو البريد الإلكتروني'; // Placeholder
                    }
                    // TODO: Add more specific validation
                    return null;
                  },
                ),
                const SizedBox(height: 30),
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
                                      PasswordResetRequested(identifier: _identifierController.text),
                                    );
                              }
                            },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'Send Code / إرسال الرمز', // Placeholder
                              style: TextStyle(color: Colors.black, fontSize: 16), // Placeholder theme
                            ),
                    );
                  },
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
    );
  }
}

