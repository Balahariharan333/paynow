import 'dart:ui' as ui;

class Responsive {
  Responsive._();

  // Reference design dimensions (typically standard mobile screen sizes)
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  /// Gets the current logical screen width, capped at 600px for tablet layout scaling.
  static double get screenWidth {
    final view = ui.PlatformDispatcher.instance.implicitView;
    if (view == null) return _designWidth;
    final width = view.physicalSize.width / view.devicePixelRatio;
    return width.clamp(0.0, 600.0);
  }

  /// Gets the current logical screen height.
  static double get screenHeight {
    final view = ui.PlatformDispatcher.instance.implicitView;
    if (view == null) return _designHeight;
    return view.physicalSize.height / view.devicePixelRatio;
  }

  /// Scale width relative to the design layout.
  static double w(double width) {
    return (screenWidth / _designWidth) * width;
  }

  /// Scale height relative to the design layout.
  static double h(double height) {
    return (screenHeight / _designHeight) * height;
  }
}
