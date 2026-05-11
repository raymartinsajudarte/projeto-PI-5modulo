import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {

  // Tesoura subindo
  late AnimationController _scissorsController;
  late Animation<double> _scissorsY;

  // Tesoura sumindo quando logo aparece
  late AnimationController _scissorsFadeController;
  late Animation<double> _scissorsFade;

  // Linha se partindo
  late AnimationController _lineController;
  late Animation<double> _lineLeftX;
  late Animation<double> _lineRightX;
  late Animation<double> _lineOpacity;

  // Logo aparecendo
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;

  // Fade out da tela
  late AnimationController _fadeOutController;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // 1. Tesoura sobe (0ms → 900ms)
    _scissorsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scissorsY = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: _scissorsController, curve: Curves.easeOutCubic),
    );

    // 2. Tesoura some (junto com logo aparecendo)
    _scissorsFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scissorsFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _scissorsFadeController, curve: Curves.easeOut),
    );

    // 3. Linha se parte (900ms → 1300ms)
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _lineLeftX = Tween<double>(begin: 0.0, end: -200.0).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInCubic),
    );
    _lineRightX = Tween<double>(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInCubic),
    );
    _lineOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeIn),
    );

    // 4. Logo aparece (1300ms → 2000ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // 5. Fade out da tela
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // 1. Tesoura sobe
    await _scissorsController.forward();

    // 2. Linha se parte + tesoura some ao mesmo tempo
    await Future.wait([
      _lineController.forward(),
      _scissorsFadeController.forward(),
    ]);

    // 3. Logo aparece
    await _logoController.forward();

    // 4. Pausa com logo visível
    await Future.delayed(const Duration(milliseconds: 800));

    // 5. Fade out
    await _fadeOutController.forward();

    // 6. Navega
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void dispose() {
    _scissorsController.dispose();
    _scissorsFadeController.dispose();
    _lineController.dispose();
    _logoController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _fadeOutController,
      builder: (context, _) {
        return Opacity(
          opacity: _fadeOut.value,
          child: Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            body: Center(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // ── Linha horizontal ──────────────────────────────────
                    AnimatedBuilder(
                      animation: _lineController,
                      builder: (context, _) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: _lineOpacity.value,
                              child: Transform.translate(
                                offset: Offset(_lineLeftX.value, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: size.width / 2,
                                    height: 2,
                                    color: const Color(0xFF6CAB5B),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: _lineOpacity.value,
                              child: Transform.translate(
                                offset: Offset(_lineRightX.value, 0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: size.width / 2,
                                    height: 2,
                                    color: const Color(0xFF6CAB5B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // ── Tesoura subindo e sumindo ─────────────────────────
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _scissorsController,
                        _scissorsFadeController,
                      ]),
                      builder: (context, _) {
                        return Opacity(
                          opacity: _scissorsFade.value,
                          child: Transform.translate(
                            offset:
                                Offset(0, _scissorsY.value * size.height),
                            child: SvgPicture.asset(
                              'assets/images/scissors.svg',
                              width: 80,
                              height: 80,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF6CAB5B),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // ── Logo aparecendo ───────────────────────────────────
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, _) {
                        return Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/logo_barbearia.png',
                                  width: 220, // maior
                                  height: 220,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Barbearia Avenida',
                                  style: TextStyle(
                                    color: Color(0xFF157C00),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }
}