import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/storage_service.dart';
import 'utils/theme.dart';
import 'screens/setup_screen.dart';
import 'screens/pin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFFF0A0E1A),
    ),
  );

  final storage = StorageService();
  await storage.init();

  runApp(NovaApp(storage: storage));
}

class NovaApp extends StatelessWidget {
  final StorageService storage;

  const NovaApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOVA',
      debugShowCheckedModeBanner: false,
      theme: NovaTheme.darkTheme,
      home: storage.isSetupComplete()
          ? const PinScreen()
          : const SetupScreen(),
    );
  }
}
