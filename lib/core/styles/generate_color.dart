import 'dart:math';

import 'package:flutter/material.dart';

class ColorCustom {
  static Color randomColor() {
    final Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    while (red == 255 && green == 255 && blue == 255) {
      red = random.nextInt(256);
      green = random.nextInt(256);
      blue = random.nextInt(256);
    }
    return Color.fromARGB(255, red, green, blue);
  }
}
