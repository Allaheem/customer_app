import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // Added missing import

// TODO: Import actual AuthBloc, AuthEvent, AuthState
// import '../blocs/auth/auth_bloc.dart';
// TODO: Import actual HomeScreen, SignupScreen, ForgotPasswordScreen
// import '../home/home_screen.dart';
// import 'signup_screen.dart';
// import 'forgot_password_screen.dart';

// Placeholder BLoC components - Uncommented for temporary fix

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      if (event.email == 'test@example.com' && event.password == 'password') {
        emit(AuthSuccess(userId: 'user123'));
      } else {
        emit(const AuthFailure('Invalid credentials'));
      }
    });
  }
}
abstract class AuthEvent extends Equatable { const AuthEvent(); @override List<Object?> get props => []; }
class LoginRequested extends AuthEvent { final String email; final String password; const LoginRequested({required this.email, required this.password}); @override List<Object?> get props => [email, password]; }
abstract class AuthState extends Equatable { const AuthState(); @override List<Object?> get props => []; }
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState { final String userId; const AuthSuccess({required this.userId}); @override List<Object?> get props => [userId]; }
class AuthFailure extends AuthState { final String message; const AuthFailure(this.message); @override List<Object?> get props => [message]; }

// End Placeholder BLoC components

// Placeholder Screens for Navigation
class PlaceholderHomeScreen extends StatelessWidget { const PlaceholderHomeScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Home - Placeholder")), body: const Center(child: Text("Welcome!"))); }
class PlaceholderSignupScreen extends StatelessWidget { const PlaceholderSignupScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Sign Up - Placeholder")), body: const Center(child: Text("Sign Up Form"))); }
class PlaceholderForgotPasswordScreen extends StatelessWidget { const PlaceholderForgotPasswordScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Forgot Password - Placeholder")), body: const Center(child: Text("Forgot Password Form"))); }
// End Placeholder Screens

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Use actual AuthBloc
      // context.read<AuthBloc>().add(
      //   LoginRequested(
      //     email: _emailController.text.trim(),
      //     password: _passwordController.text,
      //   ),
      // );
      // print("Login submitted: Email=${_emailController.text.trim()}, Password=${_passwordController.text}");
      // Simulate login for placeholder
      final ThemeData theme = Theme.of(context); // Define theme here for SnackBar
      if (_emailController.text.trim() == 'test@example.com' && _passwordController.text == 'password') {
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PlaceholderHomeScreen()),
          );
      } else {
         ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: const Text("Invalid credentials"), backgroundColor: theme.colorScheme.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Taxi Ai - Login / تسجيل الدخول"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        // TODO: Use actual AuthBloc
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              // TODO: Use actual HomeScreen
              MaterialPageRoute(builder: (context) => const PlaceholderHomeScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: theme.colorScheme.error));
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo (Placeholder)
                  Icon(
                    Icons.local_taxi,
                    size: 80,
                    color: theme.primaryColor,
                    semanticLabel: 'Taxi Ai Logo / شعار تاكسي الذكاء الاصطناعي', // Accessibility Step 018
                  ),
                  const SizedBox(height: 40),
                  // Email Field
                  Semantics(
                    label: 'Email or Phone Number Input Field / حقل إدخال البريد الإلكتروني أو رقم الهاتف', // Accessibility Step 018
                    child: TextFormField(
                      controller: _emailController,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Email or Phone / البريد الإلكتروني أو الهاتف',
                        labelStyle: theme.inputDecorationTheme.labelStyle,
                        prefixIcon: Icon(Icons.person_outline, color: theme.inputDecorationTheme.prefixIconColor),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.0, style: BorderStyle.none)), // Fixed BorderSide.none
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email or phone / يرجى إدخال بريدك الإلكتروني أو هاتفك';
                        }
                        // Basic email validation (can be improved)
                        // if (!value.contains('@')) {
                        //   return 'Please enter a valid email / يرجى إدخال بريد إلكتروني صالح';
                        // }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  Semantics(
                    label: 'Password Input Field / حقل إدخال كلمة المرور', // Accessibility Step 018
                    child: TextFormField(
                      controller: _passwordController,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Password / كلمة المرور',
                        labelStyle: theme.inputDecorationTheme.labelStyle,
                        prefixIcon: Icon(Icons.lock_outline, color: theme.inputDecorationTheme.prefixIconColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: theme.iconTheme.color,
                          ),
                          tooltip: _obscurePassword ? 'Show Password / إظهار كلمة المرور' : 'Hide Password / إخفاء كلمة المرور', // Accessibility Step 018
                          onPressed: _togglePasswordVisibility,
                        ),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.0, style: BorderStyle.none)), // Fixed BorderSide.none
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password / يرجى إدخال كلمة المرور الخاصة بك';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          // TODO: Use actual ForgotPasswordScreen
                          MaterialPageRoute(builder: (context) => const PlaceholderForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password? / نسيت كلمة المرور؟',
                        style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.secondary),
                      ),
                    ),
                  ),
                       const SizedBox(height: 30),
                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    // TODO: Use actual AuthBloc
                    builder: (context, state) {
                      return Semantics(
                        label: 'Login Button / زر تسجيل الدخول', // Accessibility Step 018
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : _submitLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                            foregroundColor: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: theme.elevatedButtonTheme.style?.textStyle?.resolve({}),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: state is AuthLoading
                              ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 3))
                              : const Text('Login / تسجيل الدخول'),
                          // TODO: Add animation on tap (Knowledge ID: user_47)
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? / ليس لديك حساب؟", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            // TODO: Use actual SignupScreen
                            MaterialPageRoute(builder: (context) => const PlaceholderSignupScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up / إنشاء حساب',
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

