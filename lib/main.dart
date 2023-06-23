// main.dart: The main entry point for the app.
//It sets up the MaterialApp and initializes any global services.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/splash_screen.dart';
import '../services/api_service.dart';
import '../services/mqtt_service.dart';
import '../utils/app_routes.dart';
import '../screens/login_page.dart';
import '../screens/main_page.dart';
import '../screens/register_page.dart';
import '../screens/available_lockers_page.dart';
import '../screens/locker_details_page.dart';
import 'models/locker.dart';
import 'utils/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => MqttService()),
      ],
      child: SmartLockerApp(),
    ),
  );
}

class SmartLockerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: MaterialColor(primaryColorValue, colorSwatch),
        accentColor: Color(accentColorValue),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => SplashScreen());
          case AppRoutes.mainPage:
            return MaterialPageRoute(builder: (context) => MainPage());
          case AppRoutes.loginPage:
            return MaterialPageRoute(builder: (context) => LoginPage());
          case AppRoutes.registerPage:
            return MaterialPageRoute(builder: (context) => RegisterPage());
          case AppRoutes.availableLockers:
            return MaterialPageRoute(
                builder: (context) => AvailableLockersPage());
          case AppRoutes.lockerDetails:
            final Locker locker = settings.arguments as Locker;
            return MaterialPageRoute(
              builder: (context) => LockerDetailsPage(locker: locker),
            );
          default:
            return MaterialPageRoute(builder: (context) => MainPage());
        }
      },
    );
  }
}
