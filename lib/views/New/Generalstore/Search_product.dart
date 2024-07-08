
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:skardubazar/provider/generalstore_product.dart';
import 'package:skardubazar/provider/product_details_provider.dart';
import 'dart:convert';

import 'general_store_product_detail.dart';

class GeneralstoreSearchScreen extends StatefulWidget {
  @override
  _GeneralstoreSearchScreenState createState() => _GeneralstoreSearchScreenState();
}

class _GeneralstoreSearchScreenState extends State<GeneralstoreSearchScreen> {
  String _searchQuery = '';

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _updateSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _updateSearchQuery('');
            },
          ),
        ],
      ),
      body: Consumer<GeneralstoreProductsProvider>(
        builder: (context, shopProvider, _) {
          final List<Map<String, dynamic>> searchData =
              shopProvider.productData.where((item) {
            final name = item['name'].toString().toLowerCase();
            final query = _searchQuery.toLowerCase();
            return name.contains(query);
          }).toList();

          return ListView.builder(
            itemCount: searchData.length,
            itemBuilder: (context, index) {
              final item = searchData[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerlstoreProductsDetails(
                        Id: item['id'].toString(),
                          
                          ),
                    ),
                  );
                },
                leading: Image.network(
                  item['imagePath'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item['name']),
                subtitle: Text(
                    item['description']), // Adjust this according to your data
              );
            },
          );
        },
      ),
    );
  }
}
