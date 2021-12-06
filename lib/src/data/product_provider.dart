import 'dart:io';

import 'package:get/get.dart';

import '../constants.dart';
import '../core_services.dart';

class ProductProvider {
  Future<dynamic> fetchProducts({
    int recordCount,
    int recordPage,
  }) async {
    try {
      final dynamic result = await Get.find<AppService>().getHttpPost(
          uri: AppConstants.BASEURL + AppConstants.PRODUCTAPIENDPOINT,
          body: {
            'page': recordPage.toString(),
            'perPage': recordCount.toString()
          },
          headers: {
            'token':
                'eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz'
          });
      //print(result);
      return Future.value(result);
    } catch (e) {
      print('Error inside Productprovider fetchproducts ');
      print(e);
      return Future.error(e);
    }
  }
}
