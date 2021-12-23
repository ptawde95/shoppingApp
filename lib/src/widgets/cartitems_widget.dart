import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListItem extends StatelessWidget {
  final Function onPressed;
  final dynamic productData;
  final int index;
  dynamic product;
  String keyIndex;

  ProductListItem({
    Key key,
    @required this.onPressed,
    this.productData,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    for (var entry in productData.entries) {
      product = entry.value;
      keyIndex = entry.key;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        elevation: 0.5,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {},
        child: Row(
          children: <Widget>[
            Ink(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(product[0]['featured_image']),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //Text('title'),
                            Text(
                              product[0]['title'] != null
                                  ? "${product[0]['title']}"
                                  : '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Price',
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                      product[0]['price'] != null
                                          ? "${product[0]['price']}"
                                          : '0',
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Quantity',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: Text(
                                      product[0]['Quantity'] != null
                                          ? "${product[0]['Quantity']}"
                                          : '0',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_sharp),
                        onPressed: () {
                          print('tapped');
                          onPressed(keyIndex, product);
                          Get.snackbar(
                            "Product Removed",
                            "Product removed from the cart",
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent.shade700,
                          );
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
