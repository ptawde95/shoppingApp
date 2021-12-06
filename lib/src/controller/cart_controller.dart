import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core_services.dart';

class CartController extends GetxController with StateMixin {
  Rx<List<dynamic>> itemsCart = Rx<List<dynamic>>([]);
  double total;
  int cartCount;

  @override
  void onInit() async {
    getCartData(fromInit: true);

    super.onInit();
  }

  void getCartData({bool fromInit = false}) {
    try {
      var data = Get.find<AppService>().cartdata;
      print(data);
      if (fromInit) {
        print('datalength');

        data.forEach((key, value) {
          itemsCart.value.add({key: value});
        });

        // STORING DATA IN THE STORAGE
        Get.find<AppService>().shellStorage.write('CartItems', itemsCart.value);
        getTotal();
        change('Success', status: RxStatus.success());
      } else {
        itemsCart.update((val) {
          val.clear();
          data.forEach((key, value) {
            val.add({key: value});
          });
        });

        // STORING DATA IN THE STORAGE
        Get.find<AppService>().shellStorage.write('CartItems', itemsCart.value);
        getTotal();
        change('Success', status: RxStatus.success());
      }
    } catch (e) {
      print('Error in getCartData');
      change('Error', status: RxStatus.error());
      print(e);
    }
  }

  void removeItem(String index, dynamic object) {
    try {
      print('removeItem');
      print(object);
      Get.find<AppService>().deleteCartRecord(index, object);
      getCartData();
    } catch (e) {}
  }

  getTotal() {
    try {
      cartCount = Get.find<AppService>().cartItems.value;
      total = Get.find<AppService>().getCarttotal();
    } catch (e) {
      print('Error in getTotal');
      print(e);
    }
  }
}
