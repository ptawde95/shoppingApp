import 'package:get/get.dart';
import 'package:shopping_app/src/controller/index.dart';

class CartViewBinding extends Bindings {
  CartViewBinding();

  @override
  void dependencies() {
    Get.lazyPut<CartController>(() {
      return CartController();
    });
  }
}
