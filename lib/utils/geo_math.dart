import 'dart:math' as math;

class GeoMath {
  // Метод 1: ГМС -> градусы
  static double gmsToDeg(int degrees, int minutes, double seconds) {
    return degrees + minutes / 60.0 + seconds / 3600.0;
  }

  // Метод 2: градусы -> ГМС
  static List<double> degToGms(double deg) {
    final d = deg.truncate();
    final m = ((deg - d) * 60).truncate();
    final s = ((deg - d) * 60 - m) * 60;
    return [d.toDouble(), m.toDouble(), s];
  }

  static double _gmsToRad(int d, int m, double s) {
    return gmsToDeg(d, m, s) * math.pi / 180.0;
  }

  // Метод 3: Прямая задача
  static Map<String, double> directProblem(
    double xa,
    double ya,
    double dist,
    int ad,
    int am,
    double asec,
  ) {
    final arad = _gmsToRad(ad, am, asec);
    final dx = dist * math.cos(arad);
    final dy = dist * math.sin(arad);
    return {
      'Xb': xa + dx,
      'Yb': ya + dy,
      'deltaX': dx,
      'deltaY': dy,
    };
  }

  // Метод 4: Обратная задача (через румб + четверти)
  static Map<String, dynamic> inverseProblem(
    double xa,
    double ya,
    double xb,
    double yb,
  ) {
    final dx = xb - xa;
    final dy = yb - ya;

    final d = math.sqrt(dx * dx + dy * dy);

    // r = arctg(|ΔY/ΔX|)
    double rDeg;
    if (dx.abs() < 1e-12) {
      rDeg = 90.0;
    } else {
      rDeg = math.atan(dy.abs() / dx.abs()) * 180.0 / math.pi;
    }

    late final String quadrant;
    late final double alpha;

    if (dx >= 0 && dy >= 0) {
      quadrant = 'СВ';
      alpha = rDeg;
    } else if (dx < 0 && dy >= 0) {
      quadrant = 'ЮВ';
      alpha = 180.0 - rDeg;
    } else if (dx < 0 && dy < 0) {
      quadrant = 'ЮЗ';
      alpha = 180.0 + rDeg;
    } else {
      quadrant = 'СЗ';
      alpha = 360.0 - rDeg;
    }

    return {
      'd': d,
      'deltaX': dx,
      'deltaY': dy,
      'rDeg': rDeg,
      'quadrant': quadrant,
      'alpha': alpha,
    };
  }
}