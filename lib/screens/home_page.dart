import 'package:flutter/material.dart';
import 'deg_page.dart';
import 'gms_page.dart';
import 'direct_page.dart';
import 'round_page.dart';
import '../utils/responsive.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const btnGrey = Color(0xFF2C2C2C);
  static const String telegramUrl = 'https://t.me/realkolyas';

  Future<void> _openTelegram(BuildContext context) async {
    try {
      await UrlLauncher.launchSocialMedia(telegramUrl);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось открыть Telegram: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = Responsive.getMaxWidth(context);
    final spacing = Responsive.getSpacing(context);
    final headerSize = Responsive.getHeaderSize(context);
    final isPortrait = Responsive.isPortrait(context);
    final spacingMultiplier = Responsive.getSpacingMultiplier(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getPadding(context),
              vertical: isPortrait ? 20 : 10,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: spacing * spacingMultiplier),
                    
                    // Кликабельная иконка Telegram над GeoCalc
                    GestureDetector(
                      onTap: () => _openTelegram(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HomePage.btnGrey.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF40D5A4).withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.telegram,
                          color: const Color(0xFF40D5A4),
                          size: headerSize * 0.8,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _Header(size: headerSize),
                    
                    SizedBox(height: spacing * (isPortrait ? 2.0 : 1.5)),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: spacing * spacingMultiplier,
                      mainAxisSpacing: spacing * spacingMultiplier,
                      childAspectRatio: 1.2,
                      children: [
                        _TileButton(
                          title: 'ПЕРЕВЕСТИ В ДЕСЯТИЧНЫЕ ГРАДУСЫ',
                          page: const GmsPage(),
                        ),
                        _TileButton(
                          title: 'ПЕРЕВОД В ГГ ММ СС',
                          page: const DegPage(),
                        ),
                        _TileButton(
                          title: 'ПРЯМАЯ ГЕОДЕЗИЧЕСКАЯ ЗАДАЧА',
                          page: const DirectPage(),
                        ),
                        _TileButton(
                          title: 'ОБРАТНАЯ ГЕОДЕЗИЧЕСКАЯ ЗАДАЧА',
                          page: const RoundPage(),
                        ),
                      ],
                    ),

                    SizedBox(height: spacing * spacingMultiplier * 3),
                    Text(
                      '© МИИГАиК, 2026, Колясинский',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: Responsive.getTextSize(context, multiplier: 0.9),
                      ),
                    ),
                    SizedBox(height: spacing * 0.8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TileButton extends StatelessWidget {
  final String title;
  final Widget page;

  const _TileButton({
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final textSize = Responsive.getTextSize(context, multiplier: 0.8);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: HomePage.btnGrey.withOpacity(0.5),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: textSize,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double size;

  const _Header({required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: size,
          backgroundColor: HomePage.btnGrey.withOpacity(0.9),
          child: Icon(
            Icons.public,
            color: const Color(0xFF40D5A4),
            size: size,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'GeoKolyas',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size * 1.3,
            fontWeight: FontWeight.w800,
            height: 0.95,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}