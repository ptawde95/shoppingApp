import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

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

  //FOR PRODUCTS LIST
  Rx<List> availbleproductList = Rx<List>([]);

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
    try {
      print('Inside cartdata');

      if (cartdata.length > 0) {
        print('inside cartdata length > 0 ');
        // if (cartdata[key] != null) {

        //print(cartdata[key]);
        var item = getCartItembyId(
            fieldName: 'id', key: key, uniqueValue: object['id']);
        print('After item check ');
        print(item);
        if (item != null) {
          print('if item already exists');

          int qty = cartdata[key][0]['Quantity'];
          qty++;
          cartdata[key][0]['Quantity'] = qty;
        } else {
          print('else item == null ');

          cartdata[key] = [object];

          cartItems++;
        }
      } else {
        cartdata[key] = [object];
        cartItems++;
      }
      print('cartdata after operation');
      print(cartdata);
    } catch (e) {
      print('Error in addToCart service');
      print(e);
    }
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

  dynamic getCartItembyId({String fieldName, int uniqueValue, String key}) {
    try {
      print('getCartItembyId');
      return cartdata.keys.firstWhere(
        (element) => element == uniqueValue.toString(),
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

  // TO SCAN THE BARCODE USING SCANNER AND CAPTURE THE CODE.

  String searchFieldContent;
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print('barcodeScanRes');
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = BarcodeScanHelper.PLATFORM_VERSION_ERROR;
    }

    if (barcodeScanRes != BarcodeScanHelper.PLATFORM_VERSION_ERROR &&
        barcodeScanRes != '-1') {
      // Get.snackbar(
      //   'Barcode Scanned Successfully',
      //   barcodeScanRes,
      //   duration: Duration(seconds: 5),
      //   backgroundColor: Colors.lightBlueAccent,
      // );
      Get.defaultDialog(
          title: 'Barcode Scanned',
          middleText: barcodeScanRes,
          middleTextStyle: Theme.of(Get.context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
          titleStyle: Theme.of(Get.context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.normal));
    } else if (barcodeScanRes == BarcodeScanHelper.PLATFORM_VERSION_ERROR) {
      Get.snackbar('Scan operation Failed',
          'Something went wrong while scanning barcode, Please Try again!');
    }
  }

  void addtoCartUsingScan(String scanBarcode) {
    try {
      var data = availbleproductList.value.firstWhere(
          (element) => element['UPC'].toString() == scanBarcode,
          orElse: () => null);
      print('Scan Product data');
      print(data);
      if (data != null) {
        var id = data['id'];

        // ADDING THE SCANNED PRODUCT TO CART
        addToCart(key: data['id'].toString(), object: data);
        Get.snackbar(
          "Product Added",
          "Product added to the cart",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.greenAccent.shade700,
        );
      } else {
        Get.snackbar('Non - Inventory Product', 'We don"t sale this Product');
      }
    } catch (e) {
      print('Error in addtoCart');
    }
  }
}
