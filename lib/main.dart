import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skardubazar/provider/Garment/garment_shop.dart';

import 'package:skardubazar/provider/phmarcy_shop_provider.dart';
import 'package:skardubazar/provider/stationary/stationry_product.dart';
import 'package:skardubazar/provider/stationary_shop.dart';
import 'package:skardubazar/views/home_page.dart';

import 'auth/login_screen.dart';
import 'provider/Garment/garment_product.dart';
import 'provider/General_store_shop.dart';
import 'provider/category_provider.dart';
import 'provider/generalstore_product.dart';
import 'provider/home_slider_provider.dart';
import 'provider/newRegistershop.dart';
import 'provider/product_details_provider.dart';
import 'provider/shop_provider.dart';
import 'provider/stationary/statioanry_shop.dart';
import 'provider/tosellproduct.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                //ChangeNotifierProvider(create: (_) => MyProvider()),
                ChangeNotifierProvider(create: (_) => CategoryProvider()),
                ChangeNotifierProvider(create: (_) => ShopProvider()),
                ChangeNotifierProvider(create: (_) => PharmcayShopProvider()),
                ChangeNotifierProvider(create: (_) => General_store_shop()),

                ChangeNotifierProvider(create: (_) => New_register_shop()),
                ChangeNotifierProvider(
                    create: (_) => GeneralstoreProductsProvider()),
                ChangeNotifierProvider(create: (_) => ProductsProvider()),
                ChangeNotifierProvider(create: (_) => Garment_shop()),

                ChangeNotifierProvider(create: (_) => GarmentProdcut()),
                ChangeNotifierProvider(create: (_) => StationaryProdcut()),
                ChangeNotifierProvider(create: (_) => Stationary_shop()),
                ChangeNotifierProvider(create: (_) => Topsellprod()),
                ChangeNotifierProvider(create: (_) => HomeSliderProvider()),
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: SplaschScreen()),
            );
          }
          return Container();
        });
  }
}
