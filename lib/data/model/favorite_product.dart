import 'dart:collection';

import '../data/model/product.dart';
import '../data/model/product_attribute.dart';

class FavoriteProduct {
  final Product? product;
  final HashMap<ProductAttribute, String>? favoriteForm;

  FavoriteProduct(this.product, this.favoriteForm);
}
