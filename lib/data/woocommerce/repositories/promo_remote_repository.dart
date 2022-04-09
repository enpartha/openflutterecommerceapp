
import 'package:flutter/material.dart';
import '../data/model/promo.dart';
import '../data/repositories/abstract/promo_repository.dart';
import '../data/woocommerce/models/promo_code_model.dart';
import '../data/woocommerce/repositories/woocommerce_wrapper.dart';

class RemotePromoRepository extends PromoRepository {
  final WoocommercWrapperAbstract? woocommerce;

  RemotePromoRepository({required this.woocommerce});

  @override
  Future<List<Promo>> getPromoList() async {
    var promosData = await (woocommerce!.getPromoList() as FutureOr<List<dynamic>>);
    List<Promo> promos = [];
    for(int i = 0; i < promosData.length; i++){
      promos.add(
        Promo.fromEntity(PromoCodeModel.fromJson(promosData[i]))
      );
    }
    return promos;
  }
}