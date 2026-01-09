import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _autoNavigate();
  }

  void _autoNavigate() async {
    // Auto-navigate to login after 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/login');
    }
  }

  void _skipSplash() {
    // Navigate immediately when tapped
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _skipSplash,
        child: Center(
          child: _buildSplashImage(),
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
