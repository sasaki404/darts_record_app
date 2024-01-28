import 'package:flutter/material.dart';
import 'package:darts_record_app/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  const home = Home();
  var app = const MaterialApp(
    // theme: ThemeData(
    //   brightness: Brightness.dark,
    // ),
    home: home,
    debugShowCheckedModeBanner: false,
  );
  runApp(ProviderScope(child: app));
}
