import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'models/models.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_room_screen.dart';
import 'screens/fix_booking_screen.dart';
import 'screens/booked_screen.dart';
import 'screens/face_verify_screen.dart';
import 'screens/calendar_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const BFKApp());
}

class BFKApp extends StatelessWidget {
  const BFKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BFK Room Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(const SplashScreen(), settings);
      case '/login':
        return _buildRoute(const LoginScreen(), settings);
      case '/otp':
        return _buildRoute(const OtpScreen(), settings);
      case '/home':
        return _buildRoute(const HomeScreen(), settings);
      case '/detail':
        final room = settings.arguments as Room;
        return _buildRoute(DetailRoomScreen(room: room), settings);
      case '/fix-booking':
        final room = settings.arguments as Room;
        return _buildRoute(FixBookingScreen(room: room), settings);
      case '/booked':
        return _buildRoute(const BookedScreen(), settings);
      case '/face-verify':
        return _buildRoute(const FaceVerifyScreen(), settings);
      case '/calendar':
        return _buildRoute(const CalendarScreen(), settings);
      default:
        return _buildRoute(const SplashScreen(), settings);
    }
  }

  Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
