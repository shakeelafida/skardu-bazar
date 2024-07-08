import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skardubazar/provider/category_provider.dart';
import 'package:skardubazar/views/New/pharmacy/pharmacyshopproduct.dart';

import '../../../provider/stationary/statioanry_shop.dart';
import '../../../provider/stationary_shop.dart';
import '../../googlemap/newmap.dart';
import '../../googlemap/userlocation.dart';
import 'stationary_product.dart';

class Stationaryshop extends StatefulWidget {
  Stationaryshop({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  State<Stationaryshop> createState() => _StationaryshopState();
}

class _StationaryshopState extends State<Stationaryshop> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Provider.of<Stationary_shop>(context, listen: false).fetchData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stationary Shop'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<Stationary_shop>(
              builder: (context, shopProvider, _) {
                var filteredData = shopProvider.rowData.where((item) {
                  return item['name']
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      item['productname']
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                }).toList();

                if (shopProvider.rowData.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (filteredData.isEmpty) {
                  return const Center(
                    child: Text('No products found'),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      filteredData.length,
                      (index) {
                        final item = filteredData[index];
                        return InkWell(
                          onDoubleTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapScreen()
                                    //userlocation()

                                    ));
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StationaryProductScreen(
                                    name: item['name'],
                                  ),
                                ));
                          },
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  item['imagePath'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['name'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // const Text(
                                    //   "Address:",
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    Expanded(
                                      child: Text(
                                        item['address'].toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // const Text(
                                    //   "Number:",
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      item['phoneno'].toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     const Icon(
                                //       Icons.star,
                                //       color: Colors.yellow,
                                //     ),
                                //     const SizedBox(
                                //       width: 10,
                                //     ),
                                //     Text(
                                //       item['rating'].toString(),
                                //       style: const TextStyle(fontSize: 16),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
