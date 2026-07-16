import 'package:flutter/material.dart';
import '../utils/geo_math.dart';
import '../utils/responsive.dart';
import '../utils/clipboard_helper.dart';

class DegPage extends StatefulWidget {
  const DegPage({super.key});

  @override
  State<DegPage> createState() => _DegPageState();
}

class _DegPageState extends State<DegPage> {
  final _deg = TextEditingController();
  final _degFocus = FocusNode();

  List<double>? _gms;
  String? _error;

  static const resultGrey = Color(0xFF2C2C2C);
  static const green = Color(0xFF40D5A4);

  double? _pd(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.'));

  void _calc() {
    // Принудительно скрываем клавиатуру
    FocusManager.instance.primaryFocus?.unfocus();
    
    setState(() {
      _error = null;
      _gms = null;

      final deg = _pd(_deg);
      if (deg == null) {
        _error = 'Введите десятичные градусы числом';
        return;
      }

      _gms = GeoMath.degToGms(deg);
    });
  }

  void _copyResult() {
    if (_gms != null) {
      final text = '${_gms![0].toStringAsFixed(0)}° ${_gms![1].toStringAsFixed(0)}\' ${_gms![2].toStringAsFixed(2)}"';
      ClipboardHelper.copyToClipboard(context, text);
    }
  }

  @override
  void dispose() {
    _deg.dispose();
    _degFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = Responsive.isPortrait(context);
    final spacing = Responsive.getSpacing(context);
    final maxWidth = Responsive.getMaxWidth(context);
    final buttonWidth = Responsive.getButtonWidth(context);
    final buttonHeight = Responsive.getButtonHeight(context);
    final headerSize = Responsive.getHeaderSize(context);
    final textSize = Responsive.getTextSize(context);
    final resultTextSize = Responsive.getResultTextSize(context);
    final spacingMultiplier = Responsive.getSpacingMultiplier(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_gms != null)
            IconButton(
              icon: const Icon(Icons.copy, color: Color(0xFF40D5A4)),
              onPressed: _copyResult,
              tooltip: 'Копировать результат',
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getPadding(context),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: spacing * spacingMultiplier),
                            _Header(size: headerSize),
                            SizedBox(height: spacing * (isPortrait ? 1.8 : 1.0)),

                            Container(
                              width: double.infinity,
                              height: buttonHeight * 0.8,
                              alignment: Alignment.center,
                              child: Text(
                                'Введите данные в градусах',
                                style: TextStyle(
                                  fontSize: textSize * 1.2,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing * 1.4 * spacingMultiplier),

                            TextField(
                              controller: _deg,
                              focusNode: _degFocus,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) {
                                _degFocus.unfocus();
                                _calc();
                              },
                              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(), // по тапу скип клавы
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textSize,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: '— — — —',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: textSize * 0.9,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF40D5A4)),
                                ),
                              ),
                            ),

                            SizedBox(height: spacing * 1.8 * spacingMultiplier),

                            SizedBox(
                              width: buttonWidth,
                              height: buttonHeight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: _calc,
                                child: Text(
                                  'РАССЧИТАТЬ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    fontSize: textSize,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: spacing * 1.6 * spacingMultiplier),

                            // КЛИКАБЕЛЬНЫЙ БЛОК С РЕЗУЛЬТАТОМ
                            GestureDetector(
                              onTap: _gms != null ? _copyResult : null,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(spacing),
                                decoration: BoxDecoration(
                                  color: resultGrey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: _gms != null
                                      ? Border.all(
                                          color: green,
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _gms == null
                                          ? ''
                                          : '${_gms![0].toStringAsFixed(0)}° ${_gms![1].toStringAsFixed(0)}\' ${_gms![2].toStringAsFixed(2)}"',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: resultTextSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (_gms != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Нажмите, чтобы скопировать',
                                        style: TextStyle(
                                          fontSize: textSize * 0.7,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            if (_error != null) ...[
                              SizedBox(height: spacing * spacingMultiplier),
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ],

                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                top: spacing * spacingMultiplier,
                              ),
                              child: Text(
                                '© МИИГАиК, 2026, Колясинский',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: Responsive.getTextSize(context, multiplier: 0.9),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing * 0.8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
          backgroundColor: const Color(0xFF2C2C2C).withOpacity(0.9),
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
            fontSize: size * 1.2,
            fontWeight: FontWeight.w800,
            height: 0.95,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}