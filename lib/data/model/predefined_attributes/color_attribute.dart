import 'dart:ui';

import '../data/model/product_attribute.dart';

class ColorAttribute extends ProductAttribute {
  final Map<String, Color> visibleColors;

  ColorAttribute({int? id, String? info, required this.visibleColors})
      : super(id: id, name: 'Color', info: info, options: visibleColors.keys as List<String>?);
}
