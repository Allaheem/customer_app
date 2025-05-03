import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: Import AuthBloc, AuthEvent, AuthState, VerifyCodeScreen
// import '../blocs/auth/auth_bloc.dart';
// import 'verify_code_screen.dart';

// Placeholder for AuthBloc, AuthEvent, AuthState - replace with actual imports
class AuthBloc extends Bloc<AuthEvent, AuthState> { AuthBloc() : super(AuthInitial()); }
abstract class AuthEvent {}
class SignUpRequested extends AuthEvent { final String name; final String identifier; final String password; SignUpRequested({required this.name, required this.identifier, required this.password}); }
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthFailure extends AuthState { final String error; AuthFailure({required this.error}); }
class PasswordResetCodeSent extends AuthState { final String identifier; PasswordResetCodeSent({required this.identifier}); }
// End Placeholder

// Placeholder for VerifyCodeScreen
class VerifyCodeScreen extends StatelessWidget { final String verificationTarget; const VerifyCodeScreen({super.key, required this.verificationTarget}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verify Code'))); }
// End Placeholder

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Define theme variable
    // TODO: Implement localization (Arabic/English)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up / إنشاء حساب'), // Placeholder
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
                SnackBar(content: Text("Sign Up Failed: ${state.error} / فشل إنشاء الحساب: ${state.error}"), backgroundColor: theme.colorScheme.error), // Placeholder
              );
          } else if (state is PasswordResetCodeSent) { // Assuming sign up leads to verification
             // print("Sign Up successful - Navigate to Verify Code");
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person_add_alt_1, size: 80, color: theme.colorScheme.primary), // Placeholder theme
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration("Full Name / الاسم الكامل", theme), // Placeholder
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), // Placeholder theme
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name / الرجاء إدخال الاسم'; // Placeholder
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _identifierController,
                    decoration: _buildInputDecoration('Phone Number or Email / رقم الهاتف أو البريد الإلكتروني', theme), // Placeholder
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), // Placeholder theme
                    keyboardType: TextInputType.emailAddress,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone or email / الرجاء إدخال الهاتف أو البريد الإلكتروني'; // Placeholder
                      }
                      // TODO: Add more specific validation (email format, phone format)
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _buildInputDecoration("Password / كلمة المرور", theme), // Placeholder
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), // Placeholder theme
                    obscureText: true,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password / الرجاء إدخال كلمة المرور'; // Placeholder
                      }
                      if (value.length < 6) { // Example validation
                         return 'Password must be at least 6 characters / كلمة المرور يجب أن تكون 6 أحرف على الأقل'; // Placeholder
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: _buildInputDecoration("Confirm Password / تأكيد كلمة المرور", theme), // Placeholder
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), // Placeholder theme
                    obscureText: true,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password / الرجاء تأكيد كلمة المرور'; // Placeholder
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match / كلمات المرور غير متطابقة'; // Placeholder
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<AuthBloc, AuthState>(
                     // TODO: Replace with actual AuthBloc import
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}), // Placeholder theme
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        SignUpRequested(
                                          name: _nameController.text,
                                          identifier: _identifierController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                }
                              },
                        child: state is AuthLoading
                            ? CircularProgressIndicator(color: theme.colorScheme.onPrimary) // Use theme color
                            : Text(
                                'Sign Up / إنشاء حساب', // Placeholder
                                style: theme.elevatedButtonTheme.style?.textStyle?.resolve({}), // Placeholder theme
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to Login Screen
                    },
                    child: Text(
                      'Already have an account? Login / لديك حساب بالفعل؟ تسجيل الدخول', // Placeholder
                      style: theme.textButtonTheme.style?.textStyle?.resolve({})?.copyWith(color: theme.colorScheme.primary), // Placeholder theme
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      labelStyle: theme.inputDecorationTheme.labelStyle, // Placeholder theme
      enabledBorder: OutlineInputBorder(
        borderSide: theme.inputDecorationTheme.enabledBorder?.borderSide ?? BorderSide(color: theme.colorScheme.primary.withOpacity(0.7)), // Placeholder theme
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: theme.inputDecorationTheme.focusedBorder?.borderSide ?? BorderSide(color: theme.colorScheme.primary), // Placeholder theme
      ),
       errorBorder: OutlineInputBorder(
        borderSide: theme.inputDecorationTheme.errorBorder?.borderSide ?? BorderSide(color: theme.colorScheme.error), // Placeholder theme
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: theme.inputDecorationTheme.focusedErrorBorder?.borderSide ?? BorderSide(color: theme.colorScheme.error, width: 2), // Placeholder theme
      ),
    );
  }
}

