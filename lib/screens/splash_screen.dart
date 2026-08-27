import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/zen_tokens.dart';
import '../providers/app_state.dart';
import '../widgets/enso_circle.dart';
import 'onboarding/onb_welcome_screen.dart';
import 'main/home_screen.dart';

/// Splash (ZenSplash) — アプリ起動時の第一印象
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minTimeElapsed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _minTimeElapsed = true);
    });
  }

  void _goNext() {
    if (_navigated) return;
    _navigated = true;
    final appState = context.read<AppState>();
    final onboardingDone = appState.settings?.onboardingComplete ?? false;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            onboardingDone ? const HomeScreen() : const OnbWelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.isReady && _minTimeElapsed && !_navigated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _goNext();
          });
        }
        return Scaffold(
          backgroundColor: ZenColors.bg,
          body: GestureDetector(
            onTap: appState.isReady ? _goNext : null,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const EnsoCircle(
                          size: 160,
                          color: ZenColors.accent,
                          strokeBase: 7,
                          animate: true,
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOut,
                          builder: (context, value, child) =>
                              Opacity(opacity: value, child: child),
                          child: const Text(
                            '9',
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w200,
                              letterSpacing: -1.5,
                              color: ZenColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, value, child) =>
                        Opacity(opacity: value, child: child),
                    child: Column(
                      children: [
                        const Text(
                          '1日9問',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 5.3,
                            color: ZenColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '衛 生 管 理 者',
                          style: TextStyle(
                            fontSize: 17,
                            color: ZenColors.inkSub,
                            letterSpacing: 4.8,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                  Text(
                    'FOCUS & RHYTHM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ZenColors.inkMute,
                      letterSpacing: 2.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
