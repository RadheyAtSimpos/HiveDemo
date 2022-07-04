import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarColorUtils extends StatelessWidget {
  const StatusBarColorUtils({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(),
    );
  }
}
