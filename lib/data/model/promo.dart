import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../data/error/exceptions.dart';
import '../domain/entities/entity.dart';
import '../domain/entities/promo/promo_code_entity.dart';

class Promo extends Equatable {
  final double? discount;
  final String? title;
  final String? promoCode;
  final int daysLeft;
  final String? image;
  final Color textColor;

  Promo(
      {required this.discount,
      required this.title,
      required this.promoCode,
      required this.daysLeft,
      required this.image,
      required this.textColor});

@override
  factory Promo.fromEntity(Entity entity) {
    if ( entity is PromoCodeEntity ) {
      return Promo(
        title: entity.title, 
        promoCode: entity.promoCode,
        discount: entity.discountPercent,
        textColor: Colors.white,
        daysLeft: entity.dateExpires!.difference(DateTime.now()).inDays,
        image: null
      );
    } else {
      throw EntityModelMapperException(message: 'Entity should be of type ProductEntity');
    }
  }
  @override
  List<Object?> get props =>
      [discount, title, promoCode, daysLeft, image, textColor];

  @override
  String toString() => discount!.toStringAsFixed(0) + '%, ' + title!;
}
