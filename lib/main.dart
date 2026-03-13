import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SmartAttendanceApp());
}

class SmartAttendanceApp extends StatelessWidget {
  const SmartAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Smart Attendance',
          debugShowCheckedModeBanner: false,
          // theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme,
          // themeMode: themeController.themeMode,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            // Dynamic status bar styling based on theme
            // final isDark = Theme.of(context).brightness == Brightness.dark;
            final isDark = true;
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ));
            return child!;
          },
        );
      },
    );
  }
}
