import 'package:flutter/material.dart';
import '../data/model/category.dart';
import '../data/model/filter_rules.dart';
import '../data/model/product_attribute.dart';
import '../presentation/features/filters/accept_bottom_navigation.dart';
import '../presentation/widgets/independent/price_slider.dart';

import 'filter_selectable_item.dart';
import 'filter_selectable_visible_option.dart';

class FiltersScreen extends StatefulWidget {
  final FilterRules? initialRules;

  const FiltersScreen(
    this.initialRules, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  FilterRules? rules;

  @override
  void initState() {
    rules = widget.initialRules;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(' selected attributes: ${rules!.selectableAttributes}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
                OpenFlutterPriceRangeSlider(
                  selectedMin: rules!.selectedPriceRange!.minPrice,
                  selectedMax: rules!.selectedPriceRange!.maxPrice,
                  label: 'Price range',
                  min: 0,
                  max: 300,
                  onChanged: _changeSelectedPrice,
                )
              ] +
              rules!.selectableAttributes!
                  .map((attribute, selectedValues) => MapEntry(
                      attribute,
                      FilterSelectableVisibleOption<String>(
                        title: attribute!.name,
                        onSelected: (String value) {
                          _onAttributeSelected(attribute, value);
                        },
                        children: Map.fromEntries(
                            attribute.options!.map((option) => MapEntry(
                                option,
                                FilterSelectableItem(
                                  text: option,
                                  isSelected: rules!.selectedAttributes[attribute] != null
                                    ? rules!.selectedAttributes[attribute]!.contains(option) : false,
                                )))),
                      )))
                  .values
                  .toList(growable: false) +
              [
                FilterSelectableVisibleOption<ProductCategory>(
                  title: 'Category',
                  children:
                      rules!.categories!.map((category, isSelected) => MapEntry(
                          category,
                          FilterSelectableItem(
                            text: category.name,
                            isSelected: isSelected,
                          ))),
                  onSelected: _onCategorySelected,
                ),
              ],
        ),
      ),
      bottomNavigationBar: AcceptBottomNavigation(
        onApply: () {
          Navigator.of(context).pop(rules);
        },
      ),
    );
  }

  void _onCategorySelected(ProductCategory value) {
    setState(() {
      rules!.categories![value] = !rules!.categories![value]!;
    });
  }

  void _onAttributeSelected(ProductAttribute? attribute, String value) {
    if ( rules!.selectedAttributes[attribute] == null ) {
      rules!.selectedAttributes[attribute] = [];
    }
    if (rules!.selectedAttributes[attribute]!.contains(value)) {
      setState(() {
        rules!.selectedAttributes[attribute]!.remove(value);
      });
    } else {
      setState(() {
        rules!.selectedAttributes[attribute]!.add(value);
      });
    }
  }

  void _changeSelectedPrice(RangeValues value) {
    setState(() {
      rules = rules!.copyWithPriceRange(PriceRange(value.start, value.end));
    });
  }
}
