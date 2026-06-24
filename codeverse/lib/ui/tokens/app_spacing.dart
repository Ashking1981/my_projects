/// Centralized spacing/radius/elevation tokens. Never hardcode a magic
/// number for padding, gaps, or corner radius outside this file.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadii {
  AppRadii._();

  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 999;
}

class AppElevation {
  AppElevation._();

  static const double card = 2;
  static const double raised = 6;
}
