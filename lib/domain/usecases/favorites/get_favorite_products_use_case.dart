import '../config/theme.dart';
/// # 7. Product Favorites Screen
/// 7.1. Favorite product listing use-case: 
/// User clicks favorite icon at the bottom menu. 
/// The list of favorite products is displayed from local database. 
/// User clicks on tile view and tile view is displayed 
/// with all the latest price updates.
/// https://medium.com/@openflutterproject/open-flutter-project-e-commerce-app-use-cases-and-features-6b7414a6e708

import '../data/repositories/abstract/favorites_repository.dart';
import '../data/model/favorite_product.dart';
import '../data/model/filter_rules.dart';
import '../data/model/sort_rules.dart';
import '../domain/usecases/base_use_case.dart';
import '../locator.dart';

abstract class GetFavoriteProductsUseCase
  implements BaseUseCase<GetFavoriteProductResult, GetFavoriteProductParams> {}

    
class GetFavoriteProductsUseCaseImpl implements GetFavoriteProductsUseCase {
  @override
  Future<GetFavoriteProductResult> execute(GetFavoriteProductParams params) async {
    try {
      FavoritesRepository favoriteRepository = sl();
      var favoriteProducts = await favoriteRepository.getFavoriteProducts(
        pageIndex: params.pageIndex,
        pageSize: params.pageSize,
        sortRules: params.sortRules,
        filterRules: params.filterRules,
      );

      return GetFavoriteProductResult(
        products: favoriteProducts,
        filterRules: FilterRules.getFavoriteSelectableAttributes(favoriteProducts),
        result: true
      );
    } catch (e) {
      return GetFavoriteProductResult(  
        result: false,
        exception: GetFavoriteProductException()
      );
    }
  }

}
class GetFavoriteProductParams {
  final int pageIndex;
  final int pageSize;
  final SortRules? sortRules;
  final FilterRules? filterRules;

  GetFavoriteProductParams(
    {
      this.pageIndex  = 0,
      this.pageSize =AppConsts.page_size,
      this.sortRules  = const SortRules(),
      this.filterRules
    }
  );
}

class GetFavoriteProductResult extends UseCaseResult {
  final List<FavoriteProduct>? products;
  final FilterRules? filterRules;

  GetFavoriteProductResult({
    this.products, 
    this.filterRules,
    Exception? exception, 
    bool? result
  }) 
  : super(exception: exception, result: result);
}

class GetFavoriteProductException implements Exception {}
