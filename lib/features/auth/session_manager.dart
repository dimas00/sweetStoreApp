import 'dart:ui';

class SessionManager {
  static VoidCallback? onLogout;

  static void logout() {
    if (onLogout != null) {
      onLogout!();
    }
  }
}