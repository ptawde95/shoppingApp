import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/src/binding/cart_view_binding.dart';
import 'package:shopping_app/src/binding/product_list_binding.dart';
import 'package:shopping_app/src/view/cart_view.dart';
import 'package:shopping_app/src/view/product_catalog_view.dart';

import 'src/core_services.dart';
import 'src/widgets/index.dart';

void main() async {
  // // INITIALIZE COMMOM SERVICES WHICH WILL AVAILABLE THROUGHTOUT THE APPLICATION
  initializeServices() async {
    await Get.putAsync(() => AppService(
          enabledAPIService: true,
          enabledStorageService: true,
        ).init());
  }

  await initializeServices();

  var _materialApp = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    locale: Locale('en_US', 'UK'),
    enableLog: true,
    defaultTransition: Transition.zoom,
    initialRoute: '/products',
    initialBinding: ProductListBinding(),
    smartManagement: SmartManagement.full,
    builder: (context, child) => ShellView(child: child),
    getPages: [
      GetPage(
        name: '/products',
        page: () => ProductCatalogView(),
        transition: Transition.cupertino,
        binding: ProductListBinding(),
        children: [],
      ),
      GetPage(
        name: '/cart',
        page: () => CartView(),
        binding: CartViewBinding(),
        transition: Transition.cupertino,
        children: [],
      ),
    ],
  );

  ///WITHOUT LAYOUT_BUILDER AND SIZE_CONFIG
  runApp(_materialApp);
}
