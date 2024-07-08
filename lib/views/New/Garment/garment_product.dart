import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skardubazar/provider/category_provider.dart';
import 'package:skardubazar/provider/generalstore_product.dart';
import 'package:skardubazar/provider/phmarcy_shop_provider.dart';
import 'package:skardubazar/views/New/Garment/Search_product.dart';
import 'package:skardubazar/views/New/Generalstore/general_store_product_detail.dart';
import 'package:skardubazar/views/New/search_screen.dart';

import '../../../provider/Garment/garment_product.dart';
import '../../../provider/product_details_provider.dart';
import 'garment_product_details.dart';
import 'garmenttab.dart';

class GarmentProductScreen extends StatefulWidget {
  GarmentProductScreen(
      {Key? key, this.name, this.address, this.description, this.phone})
      : super(key: key);
  final String? name;
  final String? description;
  final String? phone;
  final String? address;

  @override
  State<GarmentProductScreen> createState() => _GarmentProductScreenState();
}

class _GarmentProductScreenState extends State<GarmentProductScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<GarmentProdcut>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toString()),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GarmentSearchScreen()));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: Consumer<GarmentProdcut>(
        builder: (context, shopProivder, _) {
          if (shopProivder.productData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                shopProivder.productData.length,
                (index) {
                  final item = shopProivder.productData[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GarmentProductDetails

                                      // Garmenttab
                                      (
                                    Id: item['id'].toString(),
                                    title: item['name'],
                                    imagePath: item['imagePath'],
                                  ),
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              item['imagePath'],
                              width: 100,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Icon(
                        //       Icons.star,
                        //       color: Colors.yellow,
                        //     ),
                        //     const SizedBox(
                        //       width: 5,
                        //     ),
                        //     Text(
                        //       item['rating'].toString(),
                        //       style: const TextStyle(fontSize: 16),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
