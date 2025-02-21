/*
 * @author Andrew Poteryahin <openflutterproject@gmail.com>
 * @copyright 2020 Open E-commerce App
 * @see promo_repository_impl.dart
 */

import '../data/model/promo.dart';
import '../data/repositories/abstract/promo_repository.dart';
import '../data/error/exceptions.dart';
import '../data/local/local_promo_repository.dart';
import '../data/network/network_status.dart';
import '../data/woocommerce/repositories/promo_remote_repository.dart';
import '../locator.dart';

class PromoRepositoryImpl extends PromoRepository{
  static PromoDataStorage promoDataStorage = PromoDataStorage();

  @override
  Future<List<Promo>> getPromoList() async {
    try
    {
      NetworkStatus networkStatus = sl();
      PromoRepository promoRepository;
      if ( networkStatus.isConnected != null ) {
        promoRepository = RemotePromoRepository(woocommerce: sl());
      } else {
        promoRepository = LocalPromoRepository();
      }

      promoDataStorage.items = await promoRepository.getPromoList()!;

      return promoDataStorage.items;
    } on HttpRequestException {
      throw RemoteServerException();
    }
  }
}

class PromoDataStorage {
  List<Promo> items = [];
}