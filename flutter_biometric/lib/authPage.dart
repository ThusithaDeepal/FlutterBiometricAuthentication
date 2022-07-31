import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biometric/biometricPinAuthService.dart';
import 'package:local_auth_platform_interface/types/biometric_type.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<void> _checkDeviceSupport() async {
    bool isSupport = await BiometricPinAuthService.checkDeviceAuthSupport();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Device Auth Support"),
              content: isSupport
                  ? const Text("Device Supported")
                  : const Text("Device Not Supported"));
        });
  }

  void goToNextPage() async {
    bool authStatus = await BiometricPinAuthService.authenticateBioMetrics();

    if (authStatus) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
                title: Text(" Auth SuccessStatus"),
                content: Text(
                  "Auth Success",
                  style: TextStyle(color: Colors.green),
                ));
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
                title: Text(" Auth SuccessStatus"),
                content: Text(
                  "Auth Failed",
                  style: TextStyle(color: Colors.red),
                ));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  _checkDeviceSupport();
                },
                child: const Text("Check Device Support")),
            ElevatedButton(
                onPressed: () {
                  goToNextPage();
                },
                child: const Text("Authenticate With Biometrics"))
          ],
        ),
      ),
    );
  }
}
