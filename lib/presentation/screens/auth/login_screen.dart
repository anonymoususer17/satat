import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authController = ref.read(authControllerProvider.notifier);
    await authController.signIn(
      emailOrUsername: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    // Check for errors
    final authState = ref.read(authControllerProvider);
    authState.whenOrNull(
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      },
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Title with fire animation
                    Center(
                      child: _FireBackground(
                        child: Image.asset(
                          'assets/title/satat.png',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),

                    // Email or Username field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Email or Username',
                        hintText: 'Enter your email or username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or username';
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // Login button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.textPrimaryColor,
                              ),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Register link
                    TextButton(
                      onPressed: isLoading ? null : _navigateToRegister,
                      child: const Text('Don\'t have an account? Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fire animation background widget
class _FireBackground extends StatefulWidget {
  final Widget child;

  const _FireBackground({required this.child});

  @override
  State<_FireBackground> createState() => _FireBackgroundState();
}

class _FireBackgroundState extends State<_FireBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: RadialGradient(
              center: Alignment.bottomCenter,
              radius: 1.5,
              colors: [
                Color.lerp(
                  Colors.red.shade900,
                  Colors.orange.shade800,
                  _controller.value,
                )!,
                Color.lerp(
                  Colors.orange.shade700,
                  Colors.red.shade800,
                  _controller.value,
                )!,
                Color.lerp(
                  Colors.yellow.shade600,
                  Colors.orange.shade600,
                  _controller.value,
                )!,
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
