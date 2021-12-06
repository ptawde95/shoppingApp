import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shopping_app/src/data/product_provider.dart';
import 'package:shopping_app/src/data/product_repository.dart';

import '../core_services.dart';

class ProductController extends GetxController with StateMixin {
  //PRODUCT ITEM LIST
  Rx<List> productList = Rx<List>([]);

  var prodProvider;
  var prodRepository;

  //VARIABLES FOR PAGINATION
  bool isdataRemaining = true;
  bool isprocessingRequest = false;
  int currentPage = 1;
  int pageSize = 5;

  @override
  void onInit() async {
    Get.find<AppService>().title.value = 'Shopping Mall';

    prodProvider = new ProductProvider();
    prodRepository = new ProductRepository(prodProvider);

    getProductlist(isinitialloading: true);

    super.onInit();
  }

  void getProductlist({
    bool isinitialloading = false,
  }) async {
    if (isdataRemaining && isprocessingRequest == false) {
      print('fetching product records..');
      isprocessingRequest = true;
      prodRepository
          .fetchProducts(
            pageSize: pageSize,
            pageNumber: currentPage,
          )
          .then((proddata) => {
                // print('proddata'),
                //print(proddata['data']),

                if (proddata['data'].length < pageSize)
                  {
                    print('norecordsfound'),
                    isdataRemaining = false,
                  },

                // HANDLE FOR INITIAL LOADING
                if (isinitialloading)
                  {
                    productList.value = proddata['data'],
                  }
                else
                  {
                    productList.update((val) {
                      val.addAll(proddata['data']);
                    }),
                  },

                productList.value.forEach((element) {
                  element['Quantity'] = 1;
                }),
                isprocessingRequest = false,
                currentPage++,
                change('Success', status: RxStatus.success()),
              })
          .catchError((e) => {
                print('products error response '),
                print(e),
                isprocessingRequest = false,
                isdataRemaining = true,

                ///CHANGING THE CONTROLLER STATUS TO ERROR BY PASSING ERROR TEXT
                change(null, status: RxStatus.error(e.toString())),
              });
    }
  }

  void addtoCart(String id, dynamic item) {
    try {
      Get.find<AppService>().addToCart(key: id.toString(), object: item);
    } catch (e) {
      print('Error in addtoCart');
    }
  }
}
