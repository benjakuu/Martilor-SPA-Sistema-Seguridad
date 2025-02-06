import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/dashboarduser_screen.dart';
import 'screens/history_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/support_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/roleselection_screen.dart';
import 'screens/forgotpassword_screen.dart';
import 'screens/aud_screen.dart';
import 'screens/func_admin_screen.dart';
import 'screens/func_std_screen.dart';
import 'screens/restrictions_screen.dart';
import 'screens/warning_screen.dart';
import 'screens/func_sch_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_school_screen.dart';
import 'screens/school_manag_screen.dart';
import 'screens/student_manag_screen.dart';
import 'screens/mapping_rules_screen.dart';
import 'screens/mapping_points_screen.dart';
import 'screens/pupil_status_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistemas Martilor',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/roleselection',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/userdashboard': (context) => const StandardUserDashboard(),
        '/history': (context) => const HistoryScreen(),
        '/documents': (context) => const DocumentsScreen(),
        '/support': (context) => const SupportScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/roleselection': (context) => const RoleSelectionScreen(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
        '/auditreg': (context) => const AuditScreen(),
        '/funcadmin': (context) => const adminFuctionScreen(),
        '/funcstds': (context) => const StudentDashboardScreen(),
        '/restrictions': (context) => const RestrictionsScreen(),
        '/warnings': (context) => const WarningsScreen(),
        '/school': (context) => const SchoolDashboardScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/pupilstatus': (context) => const PupilStateScreen(),
        '/schoolsettings': (context) => const SchoolSettingsScreen(),
        '/schools': (context) => const SchoolManagementScreen(),
        '/students': (context) => const StudentManagementScreen(),
        '/mappingrules': (context) => const MappingRulesScreen(),
        '/mappingpoints': (context) => const MappingPointsScreen(),
      },
    );
  }
}
