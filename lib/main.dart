import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:aroghya_ai/models/user.dart';
import 'package:aroghya_ai/auth.dart' as auth;
import 'package:aroghya_ai/services/auth_service.dart';
import 'package:aroghya_ai/home.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register the User adapter
  Hive.registerAdapter(UserAdapter());
  
  // Open the users box
  await Hive.openBox<User>('users');
  
  runApp(const MedicalOnboardingApp());
}

class MedicalOnboardingApp extends StatelessWidget {
  const MedicalOnboardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Onboarding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const MedicalOnboardingScreen(),
    );
  }
}

class MedicalOnboardingScreen extends StatefulWidget {
  const MedicalOnboardingScreen({super.key});

  @override
  State<MedicalOnboardingScreen> createState() =>
      _MedicalOnboardingScreenState();
}

class _MedicalOnboardingScreenState extends State<MedicalOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Floating animation for continuous movement
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Define animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() {
    _mainController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _floatingController]),
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06), // 6% of screen width
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05), // 5% of screen height
                  
                  // Main illustration area
                  Expanded(
                    flex: 3,
                    child: OnboardingPageContent(
                      scaleAnimation: _scaleAnimation,
                      floatingAnimation: _floatingAnimation,
                      fadeAnimation: _fadeAnimation,
                      slideAnimation: _slideAnimation,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                  ),
                  
                  // Bottom spacing
                  SizedBox(height: screenHeight * 0.05), // 5% of screen height
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//--- Onboarding Page Content Widget ---//
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.scaleAnimation,
    required this.floatingAnimation,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.screenHeight,
    required this.screenWidth,
  });

  final Animation<double> scaleAnimation;
  final Animation<double> floatingAnimation;
  final Animation<double> fadeAnimation;
  final Animation<double> slideAnimation;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    // Responsive font sizes
    final double titleFontSize = screenHeight * 0.035; // 3.5% of screen height

    return Column(
      children: [
        // Illustration
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Transform.scale(
                scale: scaleAnimation.value,
                child: Container(
                  width: screenWidth * 0.8, // 80% of screen width
                  height: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ),
              // Main SVG illustration
              Transform.translate(
                offset: Offset(0, floatingAnimation.value),
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: Opacity(
                    opacity: fadeAnimation.value,
                    child: SvgPicture.asset(
                      'assets/medecine.svg', // Your SVG file path
                      width: screenWidth * 0.6, // 60% of screen width
                      height: screenWidth * 0.6,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) =>
                          const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content section
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Transform.translate(
                offset: Offset(0, slideAnimation.value),
                child: Opacity(
                  opacity: fadeAnimation.value,
                  child: Text(
                    'Find the best\ndoctor and medicine\nfor you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize > 28 ? 28 : titleFontSize, // Max size 28
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                      height: 1.3,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: screenHeight * 0.05), // 5% of screen height
              
              // Get Started Button
              Transform.translate(
                offset: Offset(0, slideAnimation.value * 1.5),
                child: Opacity(
                  opacity: fadeAnimation.value,
                  child: const GetStartedButton(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//--- Get Started Button Widget ---//
class GetStartedButton extends StatefulWidget {
  const GetStartedButton({super.key});

  @override
  State<GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_buttonController);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) => _buttonController.reverse(),
      onTapCancel: () => _buttonController.reverse(),
      onTap: () async {
        // Check if user is already logged in
        final isLoggedIn = await AuthService.isUserLoggedIn();
        if (isLoggedIn) {
          // Navigate directly to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Navigate to the auth page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const auth.AuthScreen()),
          );
        }
      },
      child: AnimatedBuilder(
        animation: _buttonController,
        builder: (context, child) {
          return Transform.scale(
            scale: _buttonScaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}