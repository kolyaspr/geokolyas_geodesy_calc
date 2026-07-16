import 'package:flutter/material.dart';
import '../utils/geo_math.dart';
import '../utils/responsive.dart';
import '../utils/clipboard_helper.dart';

class GmsPage extends StatefulWidget {
  const GmsPage({super.key});

  @override
  State<GmsPage> createState() => _GmsPageState();
}

class _GmsPageState extends State<GmsPage> {
  final _d = TextEditingController();
  final _m = TextEditingController();
  final _s = TextEditingController();

  final _dFocus = FocusNode();
  final _mFocus = FocusNode();
  final _sFocus = FocusNode();

  double? _deg;
  String? _error;

  static const resultGrey = Color(0xFF2C2C2C);
  static const green = Color(0xFF40D5A4);

  int? _pi(TextEditingController c) => int.tryParse(c.text.trim());
  double? _pd(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.'));

  void _calc() {
    // Принудительно скрываем клавиатуру
    FocusManager.instance.primaryFocus?.unfocus();
    
    setState(() {
      _error = null;
      _deg = null;

      final d = _pi(_d);
      final m = _pi(_m);
      final s = _pd(_s);

      if (d == null || m == null || s == null) {
        _error = 'Введите ГГ, ММ, СС числами';
        return;
      }

      _deg = GeoMath.gmsToDeg(d, m, s);
    });
  }

  void _copyResult() {
    if (_deg != null) {
      final text = '${_deg!.toStringAsFixed(6)}°';
      ClipboardHelper.copyToClipboard(context, text);
    }
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _d.dispose();
    _m.dispose();
    _s.dispose();
    _dFocus.dispose();
    _mFocus.dispose();
    _sFocus.dispose();
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
          if (_deg != null)
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

                            _ResultTitle(
                              buttonHeight: buttonHeight, 
                              textSize: textSize,
                            ),
                            SizedBox(height: spacing * 1.4 * spacingMultiplier),

                            Row(
                              children: [
                                Expanded(
                                  child: _LineField(
                                    ctrl: _d, 
                                    hint: 'ГГ',
                                    focusNode: _dFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _dFocus, _mFocus),
                                  ),
                                ),
                                SizedBox(width: spacing * spacingMultiplier),
                                Expanded(
                                  child: _LineField(
                                    ctrl: _m, 
                                    hint: 'ММ',
                                    focusNode: _mFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _fieldFocusChange(context, _mFocus, _sFocus),
                                  ),
                                ),
                                SizedBox(width: spacing * spacingMultiplier),
                                Expanded(
                                  child: _LineField(
                                    ctrl: _s, 
                                    hint: 'СС',
                                    focusNode: _sFocus,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) {
                                      _sFocus.unfocus();
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
                              onTap: _deg != null ? _copyResult : null,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(spacing),
                                decoration: BoxDecoration(
                                  color: resultGrey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: _deg != null
                                      ? Border.all(
                                          color: green,
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _deg == null ? '' : '${_deg!.toStringAsFixed(6)}°',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: resultTextSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (_deg != null) ...[
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

class _ResultTitle extends StatelessWidget {
  final double buttonHeight;
  final double textSize;

  const _ResultTitle({required this.buttonHeight, required this.textSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: buttonHeight * 0.8,
      alignment: Alignment.center,
      child: Text(
        'Введите ГМС',
        style: TextStyle(
          fontSize: textSize * 1.2,
          fontWeight: FontWeight.w800,
          color: Colors.white,
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