import 'package:equatable/equatable.dart';
import '../data/error/exceptions.dart';
import '../domain/entities/entity.dart';
import '../domain/entities/product/product_category_entity.dart';

import 'commerce_image.dart';

class ProductCategory extends Equatable {
  final int? id;
  final int parentId;
  final String? name;
  final String? description;
  final CommerceImage? image;
  final bool isCategoryContainer;

  ProductCategory(
    this.id, {
    int? parentId,
    this.name,
    this.description,
    this.image,
    bool? isCategoryContainer,
  })  : parentId = parentId ?? 0,
        isCategoryContainer = isCategoryContainer ?? false;

  @override
  List<Object?> get props => [id, parentId, name, image];

  @override
  bool get stringify => true;

  @override
  factory ProductCategory.fromEntity(Entity entity) {
    if ( entity is ProductCategoryEntity ) {
      return ProductCategory(
        entity.id, 
        parentId: entity.parentId,
        name: entity.title,
        description: entity.description,
        image: CommerceImage(
          0,//TODO: remove id from CommerceImage
          entity.image,
          ''
        )
      );
    } else {
      throw EntityModelMapperException(message: 'Entity should be of type ProductCategoryEntity');
    }
  }
}
