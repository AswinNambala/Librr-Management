import 'package:flutter/material.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';
import 'package:librrr_management/core/services/auth_services.dart';

class AuthUtils {
  static final _authService = AuthService();

  /// Returns true if the app is allowed to proceed.
  static Future<bool> checkAccess(BuildContext context) async {
    final canUse = await _authService.canAuthenticate();
    if (!canUse) {
      if (context.mounted) {
        SnackBarForAll.showError(context, 'No device security is set up');
      }
      return false;
    }

    return await _authService.authenticate();
  }
}