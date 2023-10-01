import 'package:flutter/material.dart';
import 'package:darts_record_app/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  const home = Home();
  const app = MaterialApp(
    home: home,
    debugShowCheckedModeBanner: false,
  );
  runApp(const ProviderScope(child: app));
}
