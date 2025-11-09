import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/vendor_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env").catchError((_) {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Success Marketplace',
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const EntryPoint(),
          '/home': (ctx) => const HomeScreen(),
          '/vendor': (ctx) => const VendorDashboard(),
        },
      ),
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (auth.isAuth) {
          if (auth.userRole == 'store' || auth.userRole == 'vendor') {
            return const VendorDashboard();
          }
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
