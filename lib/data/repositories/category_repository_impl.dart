
import '../data/repositories/abstract/category_repository.dart';
import '../data/model/category.dart';
import '../data/error/exceptions.dart';
import '../data/local/local_category_repository.dart';
import '../data/network/network_status.dart';
import '../data/woocommerce/repositories/category_remote_repository.dart';
import '../locator.dart';

//Uses remote or local data depending on NetworkStatus
class CategoryRepositoryImpl extends CategoryRepository {

  @override
  Future<List<ProductCategory>?> getCategories({int? parentCategoryId = 0}) async {
    try
    {
      NetworkStatus networkStatus = sl();
      CategoryRepository categoryRepository;
      if ( networkStatus.isConnected != null ) {
        categoryRepository = RemoteCategoryRepository(woocommerce: sl());
      } else {
        categoryRepository = LocalCategoryRepository();
      }

      return await categoryRepository.getCategories(parentCategoryId: parentCategoryId);
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }

  @override
  Future<ProductCategory?> getCategoryDetails(int categoryId) async {
    // TODO: implement getCategoryDetails
    List<ProductCategory> categories = await (getCategories() as FutureOr<List<ProductCategory>>);
    return categories.isNotEmpty ? categories[0] : null;
  }
}
