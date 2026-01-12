import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    // Fade in
    await _controller.forward();

    // Wait for 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));

    // Fade out and navigate
    if (mounted && !_isNavigating) {
      _fadeOutAndNavigate();
    }
  }

  void _fadeOutAndNavigate() async {
    if (_isNavigating) return;
    _isNavigating = true;

    // Fade out
    await _controller.reverse();

    // Navigate to login
    if (mounted) {
      context.go('/login');
    }
  }

  void _skipSplash() {
    // Fade out immediately when tapped
    _fadeOutAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _skipSplash,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildSplashImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashImage() {
    // Try different image formats
    const possiblePaths = [
      'assets/splash/splash.png',
      'assets/splash/splash.jpg',
      'assets/splash/splash.jpeg',
      'assets/splash/splash.gif',
    ];

    // Try each path and use the first one that works
    for (final path in possiblePaths) {
      try {
        return Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // If this path fails, return null to try next one
            return const SizedBox.shrink();
          },
        );
      } catch (e) {
        continue;
      }
    }

    // If no image found, show placeholder
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.style,
          size: 100,
          color: Colors.white,
        ),
        const SizedBox(height: 20),
        Text(
          'SATAT',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Tap to continue',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
