import 'package:flutter/cupertino.dart';
import 'package:shopping_app/src/data/product_provider.dart';

class ProductRepository {
  ProductRepository(this.productProvider);
  final ProductProvider productProvider;

  Future<dynamic> fetchProducts({
    int pageSize,
    int pageNumber,
  }) {
    return productProvider.fetchProducts(
      recordCount: pageSize,
      recordPage: pageNumber,
    );
  }
}
