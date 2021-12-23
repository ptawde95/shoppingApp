import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core_services.dart';

class ShellView extends StatelessWidget {
  final Widget child;
  ShellView({@required this.child});
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var count = Get.find<AppService>().cartItems.value;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              title: Obx(() => Text('${Get.find<AppService>().title.value}')),
              leading: Obx(() => IconButton(
                  icon: Get.find<AppService>().title.value == 'Cart'
                      ? Icon(Icons.arrow_back)
                      : Icon(Icons.shopping_bag),
                  onPressed: () {
                    //Get.offAllNamed('/products');
                    Get.find<AppService>().title.value == 'Shopping Mall';
                    Get.back();
                  })),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner_sharp,
                      size: 30,
                    ),
                    onPressed: () {
                      Get.find<AppService>().scanBarcodeNormal();
                      //Get.offNamed('/cart');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(children: <Widget>[
                    new IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                      onPressed: () {
                        Get.find<AppService>().title.value = 'Cart';
                        Get.toNamed('/cart');
                      },
                    ),
                    new Positioned(
                      right: 5,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Obx(() => Text(
                              '${Get.find<AppService>().cartItems.value}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    )
                  ]),
                )
              ]),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: child,
                ),
              ),
            ],
          ),
        ));
  }
}
