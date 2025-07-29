import 'package:flutter/material.dart';

abstract class AppState<T extends StatefulWidget> extends State<T> {
  void Function(Locale) get setLocale;
}
