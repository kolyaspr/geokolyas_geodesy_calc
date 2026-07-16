import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardHelper {
  static void copyToClipboard(BuildContext context, String text, {String? message}) {
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Скопировано в буфер обмена'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF40D5A4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}