import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import '../../provider/home_slider_provider.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeSliderProvider>(context, listen: false);

    return FutureBuilder(
      future: provider.fetchData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final List<Map<String, dynamic>> _rowData = provider.rowData;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              CarouselSlider(
                items: _rowData.map((data) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: data['imagePath'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // height: getProportionateScreenHeight(237.7),
                        placeholder: (context, url) => const Text(''),
                        errorWidget: (context, url, error) =>
                            Text(error.toString()),
                        //const Icon(Icons.error),
                      ),
                      Positioned(
                        top: (90.4),
                        left: 15,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              data['subtitle'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
                options: CarouselOptions(
                  height: (237.7),
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  autoPlay: true,
                  enlargeCenterPage: false,
                ),
              ),
              // SearchField
              Positioned(
                bottom: (-20.83),
                child: GestureDetector(
                  onTap: () {
                    // CusNavigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SearchScreen(),
                    //   ),
                    // );
                  },
                  // child: SearchField()
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
