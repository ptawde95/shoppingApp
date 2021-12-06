import 'package:get/get.dart';
import 'package:shopping_app/src/controller/product_controller.dart';
import 'package:shopping_app/src/data/product_repository.dart';

class ProductListBinding extends Bindings {
  ProductListBinding();

  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() {
      return ProductController();
    });
  }
}
