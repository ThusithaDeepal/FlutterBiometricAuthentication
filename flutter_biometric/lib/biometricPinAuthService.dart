import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricPinAuthService {
  static final LocalAuthentication _localAuthentication = LocalAuthentication();

//check Biometric support
  static Future<bool> canCheckBiometrics() async {
    return await _localAuthentication.canCheckBiometrics;
  }

//check devicelevel auth
  static Future<bool> deviceLevelAuth() async {
    return await _localAuthentication.isDeviceSupported();
  }

//check biometric or devicelevel
  static Future<bool> checkDeviceAuthSupport() async {
    bool isSupport = await canCheckBiometrics() || await deviceLevelAuth();
    return isSupport;
  }

//check wheter fingerprint or face id biometrics enrolled
  static Future<List<BiometricType>> checkEnrolledBiometrics() async {
    return await _localAuthentication.getAvailableBiometrics();
  }

  static Future<bool> authenticateBioMetrics() async {
    WidgetsFlutterBinding.ensureInitialized();
    bool didAuthenticate;
    try {
      didAuthenticate = await _localAuthentication.authenticate(
          localizedReason: "Please authenticate to continue",
          options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
              useErrorDialogs: true,
              sensitiveTransaction: false));
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        print("device does not have hardware support for biometrics");
        didAuthenticate = true; //to handle no hardware auth
      } else {
        didAuthenticate = false;
      }
      //else if (e.code == auth_error.notEnrolled) {
      //   print("user has not enrolled any biometrics on the device");
      // }
      print(e);
    }
    return didAuthenticate;
  }

//  static Future<bool> checkEnrolledBiometrics() async {
//     List<BiometricType> enrolledBioMetricsList =
//         await _localAuthentication.getAvailableBiometrics();

//     print(enrolledBioMetricsList);

//     if (enrolledBioMetricsList.isEmpty) {
//       //
//       print("no biometrics enrolled");
//       return false;
//     } else {
//       return true;
//     }
//   }

}
