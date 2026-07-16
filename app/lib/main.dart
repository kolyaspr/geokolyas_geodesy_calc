import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/home_page.dart';

void main() => runApp(const GeoApp());

class GeoApp extends StatelessWidget {
  const GeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geodesy Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF40D5A4),
          secondary: Color(0xFF40D5A4),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
          error: Colors.redAccent,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
              opacity: 0.25,
              colorFilter: ColorFilter.mode(
                const Color(0xFF40D5A4).withOpacity(0.15),
                BlendMode.overlay,
              ),
            ),
          ),
          child: Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              child!,
            ],
          ),
        );
      },
      home: const HomePage(),
    );
  }
}

class UrlLauncher {
  static Future<void> launchSocialMedia(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}