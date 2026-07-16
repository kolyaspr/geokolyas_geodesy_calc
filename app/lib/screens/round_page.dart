import 'package:flutter/material.dart';
import '../utils/geo_math.dart';
import '../utils/responsive.dart';
import '../utils/clipboard_helper.dart';

class RoundPage extends StatefulWidget {
  const RoundPage({super.key});

  @override
  State<RoundPage> createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  final _xa = TextEditingController();
  final _ya = TextEditingController();
  final _xb = TextEditingController();
  final _yb = TextEditingController();

  final _xaFocus = FocusNode();
  final _yaFocus = FocusNode();
  final _xbFocus = FocusNode();
  final _ybFocus = FocusNode();

  Map<String, dynamic>? _res;
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
      _res = null;

      final xa = _pd(_xa);
      final ya = _pd(_ya);
      final xb = _pd(_xb);
      final yb = _pd(_yb);

      if (xa == null || ya == null || xb == null || yb == null) {
        _error = 'Проверь ввод: все поля должны быть числами';
        return;
      }

      _res = GeoMath.inverseProblem(xa, ya, xb, yb);
    });
  }

  void _copyResult() {
    if (_res != null) {
      final d = _res!['d'];
      final dx = _res!['deltaX'];
      final dy = _res!['deltaY'];
      final r = _res!['rDeg'];
      final a = _res!['alpha'];
      
      final text = 'D: ${_f(d)}, dX: ${_f(dx)}, dY: ${_f(dy)}, r: ${_f(r)}°, α: ${_f(a)}°, четверть: ${_res!['quadrant']}';
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
    _xb.dispose();
    _yb.dispose();
    _xaFocus.dispose();
    _yaFocus.dispose();
    _xbFocus.dispose();
    _ybFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = _res?['d'];
    final dx = _res?['deltaX'];
    final dy = _res?['deltaY'];
    final r = _res?['rDeg'];
    final a = _res?['alpha'];

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
                                    onSubmitted: (_) => _fieldFocusChange(context, _yaFocus, _xbFocus),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing * spacingMultiplier),
                            Row(
                              children: [
                                Expanded(
                                  child: _LineField(
                                    ctrl: _xb, 
                                    hint: 'Xb',
                                    focusNode: _xbFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _xbFocus, _ybFocus),
                                  ),
                                ),
                                SizedBox(width: spacing * spacingMultiplier),
                                Expanded(
                                  child: _LineField(
                                    ctrl: _yb, 
                                    hint: 'Yb',
                                    focusNode: _ybFocus,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) {
                                      _ybFocus.unfocus();
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
                                        Expanded(child: _cell('D', d == null ? '—' : _f(d), resultTextSize)),
                                        const SizedBox(width: 10),
                                        Expanded(child: _cell('dX', dx == null ? '—' : _f(dx), resultTextSize)),
                                      ],
                                    ),
                                    const Divider(height: 14, color: Colors.grey),
                                    Row(
                                      children: [
                                        Expanded(child: _cell('dY', dy == null ? '—' : _f(dy), resultTextSize)),
                                        const SizedBox(width: 10),
                                        Expanded(child: _cell('r', r == null ? '—' : _f(r), resultTextSize)),
                                      ],
                                    ),
                                    const Divider(height: 14, color: Colors.grey),
                                    Row(
                                      children: [
                                        Expanded(child: _cell('α', a == null ? '—' : '${_f(a)}°', resultTextSize)),
                                      ],
                                    ),
                                    if (_res != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.all(spacing * 0.5),
                                        decoration: BoxDecoration(
                                          color: resultGrey.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Четверть: ${_res!['quadrant']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: textSize,
                                          ),
                                        ),
                                      ),
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