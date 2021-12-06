import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AppService extends GetxService {
  AppService({
    this.httpApiUrl = '',
    this.enabledAPIService = false,
    this.enabledStorageService = false,
  });

  final bool enabledAPIService;

  final bool enabledStorageService;

  // VARIABLES FOR API SERVICES
  GetConnect connect;
  final String httpApiUrl;
  static const API_TIMEOUT_DURATION = Duration(seconds: 30);
  static const API_URI = "";

  // SHELL STORAGE
  GetStorage shellStorage;

  // CART SERVICE
  Map<String, List<dynamic>> cartdata;

  // FOR CART ICON COT OIF ITEMS IN THE CART
  RxInt cartItems = 0.obs;

  // FOR CURRENT ROUTE
  RxString title = ''.obs;

  Future<AppService> init() async {
    // SHELL STORAGE SERVICES
    if (enabledStorageService) {
      await GetStorage.init();
      shellStorage = GetStorage();
    }

    // API SERVICE
    if (enabledAPIService) {
      connect = GetConnect();
      connect.baseUrl = httpApiUrl;
      connect.timeout = API_TIMEOUT_DURATION;
    }

    // CART SERVICE
    cartdata = Map<String, List<dynamic>>();
    return this;
  }

  // CART SERVICES METHODS - S

  ///ADDS DYNAMIC OBJECTS TO THE CART AND CAN BE ACCESSED THROUGHOUT THE APP
  void addToCart({
    @required String key,
    @required dynamic object,
  }) {
    if (cartdata[key] != null) {
      var item =
          getCartItembyId(fieldName: 'id', key: key, uniqueValue: object['id']);
      if (item != null) {
        cartdata[key].removeAt(cartdata[key].indexOf(item));
      }

      cartItems++;

      cartdata[key].add(object);
    } else
      cartdata[key] = [object];
    cartItems++;

    print('cartdata');
    print(cartdata);
  }

  ///RETURNS THE CART DATA FOR REQUESTED KEY
  List<dynamic> getCartData(String key) {
    return cartdata[key];
  }

  void deleteCartRecord(
    @required String key,
    @required dynamic object,
  ) {
    try {
      cartdata.remove(key);
      cartItems--;
      print('deleteCartRecord else');
    } catch (e) {}
  }

  ///RETURNS ALL THE CARTS DATA
  dynamic getAllCartData() {
    return cartdata;
  }

  /// TO CHECK WHETHER THE ITEM ALREADT EXIST IN THE CART

  dynamic getCartItembyId({String fieldName, String uniqueValue, String key}) {
    try {
      return cartdata[key].firstWhere(
        (element) => element[fieldName] == uniqueValue,
        orElse: () => null,
      );
    } catch (e) {
      print('Error in getCartItembyId Of Cart service');
      print(e);
      return null;
    }
  }

  dynamic getCarttotal() {
    double cartTotal = 0.0;
    try {
      cartdata.values.forEach((element) {
        var qty = element[0]['Quantity'];
        var price = element[0]['price'];
        var total = price * qty;

        cartTotal += double.parse(total.toString());
      });
    } catch (e) {
      print('Error in getCarttotal function');
      print(e);
      return cartTotal;
    }

    return cartTotal;
  }

  // CART SERVICE METHOD - E

  // API METHODS
  ///IT MAKES THE NORMAL POST REQUEST
  Future getconnectPost({
    Map<String, String> headers,
    @required String uri,
    body,
  }) async {
    try {
      final response = await GetConnect().post(
        uri,
        body,
        headers: {if (headers != null) ...headers},
      );

      return Future.value(response);
    } catch (e) {
      print('Error inside API SERVICE POST REQUEST ');
      print(e.message);
      return Future.error(e);
    }
  }

  ///IT MAKES THE NORMAL POST REQUEST
  Future getHttpPost({
    Map<String, String> headers,
    @required String uri,
    body,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(uri),
            headers: {if (headers != null) ...headers},
            body: body,
          )
          .timeout(API_TIMEOUT_DURATION);

      return Future.value(jsonDecode(response.body));
    } catch (e) {
      print('Error inside API SERVICE POST REQUEST ');
      print(e);
      return Future.error(e);
    }
  }
}
