import '../data/model/filter_rules.dart';
import '../data/model/sort_rules.dart';

class ProductsByFilterParams {
  final int? categoryId;
  final SortRules? sortBy;
  final FilterRules? filterRules;

  ProductsByFilterParams({
    this.categoryId,
    this.sortBy, 
    this.filterRules, 
  });

  bool get filterByCategory => categoryId != null;
}