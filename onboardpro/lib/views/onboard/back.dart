import 'package:flutter/material.dart';
// import 'package:flutter/onboardpro/main.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyBack extends StatefulWidget {
  const MyBack({super.key});

  @override
  State<MyBack> createState() => _MyBackState();
}

class _MyBackState extends State<MyBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP has been verified!'),
      ),
    );
  }
}
