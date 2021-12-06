import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/src/controller/index.dart';
import 'package:shopping_app/src/widgets/index.dart';

class CartView extends GetWidget<CartController> {
  bool _isSelected = false;

  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) => Container(
            child: Column(
          children: [
            Expanded(
                child: Container(
                    child: Obx(
              () => ListView.builder(
                  itemCount: controller.itemsCart.value.length,
                  itemBuilder: (context, index) {
                    return ProductListItem(
                        index: index,
                        productData: controller.itemsCart.value[index],
                        onPressed: controller.removeItem);
                  }),
            ))),
            Padding(
              padding: EdgeInsets.all(5.00),
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Items',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  '${controller.cartCount}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cart Total',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${controller.total}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
            )
          ],
        )));
  }
}
