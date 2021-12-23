import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/src/controller/product_controller.dart';

class ProductCatalogView extends GetView<ProductController> {
  bool _isSelected = false;

  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => Container(
            child: Obx(() => NotificationListener<ScrollNotification>(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width < 450 ? 350 : 220,
                        crossAxisSpacing: 3.0,
                        mainAxisSpacing: 3.0),
                    itemCount: controller.productList.value.length,
                    itemBuilder: (context, index) {
                      return buildWidgets(controller.productList.value, index);
                    },
                  ),
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      // print('In Next Paged event');

                      controller.getProductlist(isinitialloading: true);
                    }
                    return true;
                  },
                ))),
        onLoading: Center(child: CircularProgressIndicator()));
  }

  buildWidgets(dynamic items, int index) {
    // print('in build widgets');
    return Container(
      height: 370,
      // width: 170,
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(3.0),
                child: SizedBox(
                    height: 100,
                    child: Image.network(
                      '${items[index]['featured_image']}',
                      fit: BoxFit.fill,

                      ///SHOWS THE LOADER TILL IMAGE IS LOADED COMPLETELY
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            height: 90.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },

                      ///HANDLES ERROR OCCURRED DURING FETCHING OR LOADING THE IMAGE AND SHOWS NO_PREVIEW_TEXT
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Icon(Icons.image_not_supported);
                      },
                    )
                    // Image.network(
                    //     'http://205.134.254.135/~mobile/MtProject/uploads/product_image/58444.jpg'),
                    )),
            SizedBox(
              height: 2.0,
            ),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    '${items[index]['title']}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.0,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      controller.addtoCart(
                          items[index]['id'].toString(), items[index]);
                      Get.snackbar(
                        "",
                        "Product added to the cart",
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.white,
                        backgroundColor: Colors.greenAccent.shade700,
                      );
                    },
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Icon(Icons.shopping_cart)),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text('Add To Cart'),
                      )
                    ])))
          ],
        ),
      ),
    );
  }
}
