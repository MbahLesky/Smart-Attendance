import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          _showSuccessDialog();
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(16),
            const Icon(PhosphorIconsFill.checkCircle, color: AppColors.success, size: 64),
            const Gap(24),
            Text(
              'Account Created!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Gap(12),
            const Text(
              'Your account has been successfully created. You can now sign in.',
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            ElevatedButton(
              onPressed: () {
                context.pop(); // Close dialog
                context.go(AppRouter.login);
              },
              child: const Text('Back to Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(PhosphorIconsRegular.caretLeft),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(8),
                Text(
                  'Join Smart Attendance to track your presence easily.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const Gap(32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('First Name', style: Theme.of(context).textTheme.labelLarge),
                          const Gap(8),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(hintText: 'John'),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Name', style: Theme.of(context).textTheme.labelLarge),
                          const Gap(8),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(hintText: 'Doe'),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Text('Email Address', style: Theme.of(context).textTheme.labelLarge),
                const Gap(8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'john@example.com',
                    prefixIcon: Icon(PhosphorIconsRegular.envelopeSimple),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Invalid email';
                    return null;
                  },
                ),
                const Gap(20),
                Text('Phone Number', style: Theme.of(context).textTheme.labelLarge),
                const Gap(8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '+237 670 000 000',
                    prefixIcon: Icon(PhosphorIconsRegular.phone),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const Gap(20),
                Text('Password', style: Theme.of(context).textTheme.labelLarge),
                const Gap(8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    prefixIcon: const Icon(PhosphorIconsRegular.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? PhosphorIconsRegular.eyeClosed : PhosphorIconsRegular.eye),
                    ),
                  ),
                  validator: (value) => value!.length < 6 ? 'Min 6 characters' : null,
                ),
                const Gap(20),
                Text('Confirm Password', style: Theme.of(context).textTheme.labelLarge),
                const Gap(8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Repeat password',
                    prefixIcon: const Icon(PhosphorIconsRegular.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(_obscureConfirmPassword ? PhosphorIconsRegular.eyeClosed : PhosphorIconsRegular.eye),
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const Gap(40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Account'),
                ),
                const Gap(24),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text('Sign In', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
