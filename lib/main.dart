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
import 'models/user.dart';
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
        hintColor: Color(accentColorValue),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Object? args = settings.arguments;

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
            final User user = args as User;
            return MaterialPageRoute(
                builder: (context) => AvailableLockersPage(user: user));
          case AppRoutes.lockerDetails:
            final Map<String, dynamic> lockerAndUser =
                args as Map<String, dynamic>;
            final Locker locker = lockerAndUser['locker'] as Locker;
            final User user = lockerAndUser['user'] as User;
            return MaterialPageRoute(
              builder: (context) =>
                  LockerDetailsPage(locker: locker, user: user),
            );
          default:
            return MaterialPageRoute(builder: (context) => MainPage());
        }
      },
    );
  }
}
