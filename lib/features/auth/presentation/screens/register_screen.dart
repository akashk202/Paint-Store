import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:c_h_p/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:c_h_p/features/auth/presentation/bloc/auth_event.dart';
import 'package:c_h_p/features/auth/presentation/bloc/auth_state.dart';
import 'package:c_h_p/features/auth/presentation/screens/login_screen.dart';
import 'package:c_h_p/pages/core/home_page.dart';

/// Register screen — uses BLoC for auth. Zero Firebase logic in UI.
class RegisterScreen extends StatefulWidget {
  final String? prefilledEmail;
  const RegisterScreen({super.key, this.prefilledEmail});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController =
        TextEditingController(text: widget.prefilledEmail ?? '');
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _slideAnimations = List.generate(
      7,
      (index) => Tween<Offset>(
              begin: const Offset(0, 0.8), end: Offset.zero)
          .animate(CurvedAnimation(
              parent: _animationController,
              curve:
                  Interval(0.1 * index, 1.0, curve: Curves.easeOutCubic))),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final address = _addressController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty ||
        password.isEmpty || address.isEmpty) {
      _showSnackBar('Please fill all fields', isError: true);
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showSnackBar('Please enter a valid email address', isError: true);
      return;
    }
    if (password != confirm) {
      _showSnackBar('Passwords do not match', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters', isError: true);
      return;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _showSnackBar('Password must contain an uppercase letter', isError: true);
      return;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _showSnackBar('Password must contain a number', isError: true);
      return;
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _showSnackBar('Password must contain a special character', isError: true);
      return;
    }

    // Dispatch event to BLoC
    context.read<AuthBloc>().add(RegisterRequested(
          name: name, email: email, phone: phone,
          password: password, address: address));
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(20),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          _showSnackBar('Registration successful!', isError: false);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false);
        } else if (state is AuthError) {
          _showSnackBar(state.message, isError: true);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.deepOrange.shade400, Colors.orange.shade200],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Positioned(top: -100, left: -100, child: _glassCircle(200)),
            Positioned(bottom: -150, right: -120, child: _glassCircle(300)),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _slideAnimations[0],
                        child: Text('Create Account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 30),
                      _buildFormCard(),
                      const SizedBox(height: 20),
                      SlideTransition(
                        position: _slideAnimations[6],
                        child: _loginRedirect()),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _glassCircle(double size) => Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.08)));

  Widget _buildFormCard() {
    final emailPrefilled = widget.prefilledEmail?.isNotEmpty == true;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.3), width: 1.5)),
          child: Column(children: [
            SlideTransition(position: _slideAnimations[1],
                child: _field(_nameController, 'Full Name', Icons.person_outline)),
            const SizedBox(height: 16),
            SlideTransition(position: _slideAnimations[2],
                child: _field(_emailController, 'Email', Icons.email_outlined,
                    readOnly: emailPrefilled,
                    keyboardType: TextInputType.emailAddress)),
            const SizedBox(height: 16),
            SlideTransition(position: _slideAnimations[3],
                child: _field(_phoneController, 'Phone', Icons.phone_outlined,
                    keyboardType: TextInputType.phone)),
            const SizedBox(height: 16),
            SlideTransition(position: _slideAnimations[4],
                child: _field(_addressController, 'Address', Icons.home_outlined)),
            const SizedBox(height: 16),
            SlideTransition(position: _slideAnimations[5],
                child: _field(_passwordController, 'Password', Icons.lock_outline,
                    obscure: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                          color: Colors.white.withValues(alpha: 0.7)),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword)))),
            const SizedBox(height: 16),
            SlideTransition(position: _slideAnimations[6],
                child: _field(_confirmPasswordController, 'Confirm Password',
                    Icons.lock_person_outlined,
                    obscure: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                          color: Colors.white.withValues(alpha: 0.7)),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword)))),
            const SizedBox(height: 30),
            SlideTransition(
              position: _slideAnimations[6],
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 8),
                      onPressed: _onRegister,
                      child: Text('Register',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      {bool obscure = false, bool readOnly = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon}) {
    return TextField(
      controller: c, obscureText: obscure, readOnly: readOnly,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(icon, color: Colors.white, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: readOnly
            ? Colors.black.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.5), width: 1)),
      ),
    );
  }

  Widget _loginRedirect() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Already have an account? ',
          style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.9))),
      GestureDetector(
        onTap: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LoginScreen())),
        child: Text('Login',
            style: GoogleFonts.poppins(color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline)),
      ),
    ],
  );
}
