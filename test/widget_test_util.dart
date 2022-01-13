import 'package:flutter_test/flutter_test.dart';

T evaluateWidget<T>(Finder finder) {
  return finder.evaluate().single.widget as T;
}
