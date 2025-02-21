import '../config/theme.dart';
import '../data/model/filter_rules.dart';
import '../data/model/product.dart';
import '../data/model/sort_rules.dart';
import '../data/repositories/abstract/product_repository.dart';

class LocalProductRepository implements ProductRepository {
  @override
  Future<Product> getProduct(int id) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getSimilarProducts(int categoryId,
      {int pageIndex = 0, int pageSize = AppConsts.page_size}) {
    // TODO: implement getSimilarProducts
    throw UnimplementedError();
  }

  @override
  Future<List<Product>>? getProducts(
      {int pageIndex = 0,
      int pageSize = AppConsts.page_size,
      int? categoryId = 0,
      bool isFavorite = false,
      SortRules sortRules = const SortRules(),
      FilterRules? filterRules}) {
    // TODO: implement getProducts
    return null;
  }

  @override
  Future<FilterRules>? getPossibleFilterOptions(int categoryId) {
    // TODO: implement getPossibleFilterOptions
    return null;
  }
}
