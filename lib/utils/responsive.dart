import 'package:flutter/material.dart';

class Responsive {
  static double getMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    if (isPortrait) {
      if (width < 600) return width * 0.95;
      if (width < 900) return 600;
      return 720;
    } else {
      if (width < 800) return width * 0.85;
      if (width < 1100) return 700;
      return 800;
    }
  }

  static double getButtonWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    if (isPortrait) {
      if (width < 600) return 220;
      if (width < 900) return 280;
      return 360;
    } else {
      if (width < 800) return 200;
      if (width < 1100) return 240;
      return 300;
    }
  }

  static double getButtonHeight(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    if (isPortrait) {
      if (width < 600) return 44;
      if (width < 900) return 52;
      return 60;
    } else {
      if (width < 800) return 38;
      if (width < 1100) return 44;
      return 52;
    }
  }

  static double getHeaderSize(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    if (isPortrait) {
      if (width < 600) return 44;
      if (width < 900) return 56;
      return 68;
    } else {
      if (width < 800) return 36;
      if (width < 1100) return 44;
      return 56;
    }
  }

  static double getHeaderTextSize(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    if (isPortrait) {
      if (width < 600) return 44;
      if (width < 900) return 52;
      return 64;
    } else {
      if (width < 800) return 32;
      if (width < 1100) return 40;
      return 52;
    }
  }

  static double getPadding(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    if (isPortrait) {
      if (width < 600) return 16;
      if (width < 900) return 24;
      return 32;
    } else {
      if (width < 800) return 12;
      if (width < 1100) return 20;
      return 28;
    }
  }

  static double getSpacing(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    if (isPortrait) {
      if (width < 600) return 10;
      if (width < 900) return 16;
      return 24;
    } else {
      if (width < 800) return 6;
      if (width < 1100) return 10;
      return 16;
    }
  }

  static double getTextSize(BuildContext context, {double multiplier = 1.0}) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    double baseSize;
    if (isPortrait) {
      if (width < 600) baseSize = 14;
      else if (width < 900) baseSize = 16;
      else baseSize = 18;
    } else {
      if (width < 800) baseSize = 12;
      else if (width < 1100) baseSize = 14;
      else baseSize = 16;
    }
    return baseSize * multiplier;
  }

  static double getResultTextSize(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    
    if (isPortrait) {
      if (width < 600) return 18;
      if (width < 900) return 20;
      return 24;
    } else {
      if (width < 800) return 16;
      if (width < 1100) return 18;
      return 22;
    }
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        mediaQuery.viewInsets.bottom;
    return availableHeight;
  }

  static double getSpacingMultiplier(BuildContext context) {
    return isPortrait(context) ? 1.0 : 0.7;
  }
}