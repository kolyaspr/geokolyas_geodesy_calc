import 'package:flutter/material.dart';
import '../utils/geo_math.dart';
import '../utils/responsive.dart';
import '../utils/clipboard_helper.dart';

class DirectPage extends StatefulWidget {
  const DirectPage({super.key});

  @override
  State<DirectPage> createState() => _DirectPageState();
}

class _DirectPageState extends State<DirectPage> {
  final _xa = TextEditingController();
  final _ya = TextEditingController();
  final _d = TextEditingController();
  final _ad = TextEditingController();
  final _am = TextEditingController();
  final _asec = TextEditingController();

  final _xaFocus = FocusNode();
  final _yaFocus = FocusNode();
  final _dFocus = FocusNode();
  final _adFocus = FocusNode();
  final _amFocus = FocusNode();
  final _asecFocus = FocusNode();

  Map<String, double>? _res;
  String? _error;

  static const resultGrey = Color(0xFF2C2C2C);
  static const green = Color(0xFF40D5A4);

  double? _pd(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.'));
  int? _pi(TextEditingController c) => int.tryParse(c.text.trim());

  void _calc() {
    // Принудительно скрываем клавиатуру
    FocusManager.instance.primaryFocus?.unfocus();
    
    setState(() {
      _error = null;
      _res = null;

      final xa = _pd(_xa);
      final ya = _pd(_ya);
      final dist = _pd(_d);
      final ad = _pi(_ad);
      final am = _pi(_am);
      final asec = _pd(_asec);

      if (xa == null ||
          ya == null ||
          dist == null ||
          ad == null ||
          am == null ||
          asec == null) {
        _error = 'Проверь ввод: все поля должны быть числами';
        return;
      }

      _res = GeoMath.directProblem(xa, ya, dist, ad, am, asec);
    });
  }

  void _copyResult() {
    if (_res != null) {
      final text = 'Xb: ${_f(_res!['Xb']!)}, Yb: ${_f(_res!['Yb']!)}, dX: ${_f(_res!['deltaX']!)}, dY: ${_f(_res!['deltaY']!)}';
      ClipboardHelper.copyToClipboard(context, text);
    }
  }

  String _f(num v) => v.toDouble().toStringAsFixed(3);

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _xa.dispose();
    _ya.dispose();
    _d.dispose();
    _ad.dispose();
    _am.dispose();
    _asec.dispose();
    _xaFocus.dispose();
    _yaFocus.dispose();
    _dFocus.dispose();
    _adFocus.dispose();
    _amFocus.dispose();
    _asecFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dx = _res?['deltaX'];
    final dy = _res?['deltaY'];
    final xb = _res?['Xb'];
    final yb = _res?['Yb'];

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
          if (_res != null)
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

                            Row(
                              children: [
                                Expanded(
                                  child: _LineField(
                                    ctrl: _xa, 
                                    hint: 'Xa',
                                    focusNode: _xaFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _xaFocus, _yaFocus),
                                  ),
                                ),
                                SizedBox(width: spacing * spacingMultiplier),
                                Expanded(
                                  child: _LineField(
                                    ctrl: _ya, 
                                    hint: 'Ya',
                                    focusNode: _yaFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _yaFocus, _dFocus),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing * spacingMultiplier),
                            _LineField(
                              ctrl: _d, 
                              hint: 'D (расстояние)',
                              focusNode: _dFocus,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _fieldFocusChange(context, _dFocus, _adFocus),
                            ),

                            SizedBox(height: spacing * spacingMultiplier),
                            Row(
                              children: [
                                Expanded(
                                  child: _LineField(
                                    ctrl: _ad, 
                                    hint: 'ГГ',
                                    focusNode: _adFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _adFocus, _amFocus),
                                  ),
                                ),
                                SizedBox(width: spacing * spacingMultiplier),
                                Expanded(
                                  child: _LineField(
                                    ctrl: _am, 
                                    hint: 'ММ',
                                    focusNode: _amFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _amFocus, _asecFocus),
                                  ),
                                ),
                                SizedBox(width: spacing * spacingMultiplier),
                                Expanded(
                                  child: _LineField(
                                    ctrl: _asec, 
                                    hint: 'СС',
                                    focusNode: _asecFocus,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) {
                                      _asecFocus.unfocus();
                                      _calc();
                                    },
                                  ),
                                ),
                              ],
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
                              onTap: _res != null ? _copyResult : null,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: resultGrey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: _res != null
                                      ? Border.all(
                                          color: green,
                                          width: 1,
                                        )
                                      : null,
                                ),
                                padding: EdgeInsets.all(spacing),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _cell('Xb', xb == null ? '—' : _f(xb), resultTextSize)),
                                        const SizedBox(width: 10),
                                        Expanded(child: _cell('Yb', yb == null ? '—' : _f(yb), resultTextSize)),
                                      ],
                                    ),
                                    const Divider(height: 14, color: Colors.grey),
                                    Row(
                                      children: [
                                        Expanded(child: _cell('dX', dx == null ? '—' : _f(dx), resultTextSize)),
                                        const SizedBox(width: 10),
                                        Expanded(child: _cell('dY', dy == null ? '—' : _f(dy), resultTextSize)),
                                      ],
                                    ),
                                    if (_res != null) ...[
                                      const SizedBox(height: 8),
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

  Widget _cell(String label, String value, double fontSize) {
    final textSize = Responsive.getTextSize(context);
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: textSize,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ],
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

class _LineField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const _LineField({
    required this.ctrl, 
    required this.hint,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final textSize = Responsive.getTextSize(context);
    
    return TextField(
      controller: ctrl,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: textSize,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }
}