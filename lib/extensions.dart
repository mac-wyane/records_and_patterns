import 'package:flutter/material.dart';

extension ThemeOnAll on BuildContext {
  TextTheme get textThemeExt => Theme.of(this).textTheme;
}
