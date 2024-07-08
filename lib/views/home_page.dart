// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';
// import 'package:skardubazar/models/categories_details_model.dart';
// import 'package:skardubazar/models/shopmodel.dart';
// import 'package:skardubazar/provider/my_provider.dart';
// import 'package:skardubazar/views/categories.dart';
// import 'package:skardubazar/views/New/profile_screen.dart';

// import '../models/categories_modle.dart';

// class Home_Page extends StatefulWidget {
//   const Home_Page({super.key});

//   @override
//   State<Home_Page> createState() => _Home_PageState();
// }

// class _Home_PageState extends State<Home_Page> {
//   // 1stcategory
//   List<CategoriesModle> gesthouseList = [];
//   //2category
//   List<CategoriesModle> hotelList = [];
//   //3category
//   List<CategoriesModle> placeList = [];
//   //4 category
//   List<CategoriesModle> transportList = [];
//   List<shopModle> shopList = [];

// // Home show list all list
//   // List<PlaceModle> singlePlaceList = [];
//   // // list of  placecategories details
//   List<PlaceCategoriesModle> garmentCategoriesList = [];
//   List<PlaceCategoriesModle> generalstoreCategoriesList = [];
//   List<PlaceCategoriesModle> pharmacyCategoriesList = [];
//   List<PlaceCategoriesModle> transportCategoriesList = [];

//   Widget categoriesContainer(
//       {Function()? onTap, required String image, required String name}) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             margin: const EdgeInsets.only(left: 30),
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: NetworkImage(image), fit: BoxFit.cover),
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 30),
//           child: Text(
//             name,
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   ////1st
//   Widget gesthouse() {
//     return Row(
//       children: gesthouseList
//           .map((e) => categoriesContainer(
//               image: e.image,
//               name: e.name,
//               onTap: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         Categories(list: generalstoreCategoriesList
//                             // gesthouseCategoriesList,
//                             ),
//                   ),
//                 );
//               }))
//           .toList(),
//     );
//   }

//   ////2nd
//   Widget hotel() {
//     return Row(
//       children: hotelList
//           .map((e) => categoriesContainer(
//                 image: e.image,
//                 name: e.name,
//                 onTap: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           Categories(list: pharmacyCategoriesList
//                               //hotelCategoriesList,
//                               ),
//                     ),
//                   );
//                 },
//               ))
//           .toList(),
//     );
//   }

//   //3 category
//   Widget Garment() {
//     return Row(
//       children: placeList
//           .map((e) => categoriesContainer(
//                 image: e.image,
//                 name: e.name,
//                 onTap: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           Categories(list: garmentCategoriesList
//                               //visitplaceCategoriesList,
//                               ),
//                     ),
//                   );
//                 },
//               ))
//           .toList(),
//     );
//   }

//   // //4
//   Widget stationary() {
//     return Row(
//       children: transportList
//           .map((e) => categoriesContainer(
//                 image: e.image,
//                 name: e.name,
//                 onTap: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => Categories(
//                         list: transportCategoriesList,
//                       ),
//                     ),
//                   );
//                 },
//               ))
//           .toList(),
//     );
//   }

// // shops

//   @override
//   Widget build(BuildContext context) {
//     MyProvider provider = Provider.of<MyProvider>(context);
//     //1 name of categroy
//     provider.getGestHouseCategory();
//     gesthouseList = provider.throwGestHouseList;
//     //2name of categroy
//     provider.getHotelCategory();
//     hotelList = provider.throwHotelList;
//     ////3 name of categroy
//     provider.getGermentCategory();
//     placeList = provider.throwPlaceList;
//     // //4 name of categroy
//     provider.getCarBookCategory();
//     transportList = provider.throwCarBookList;
//     //shops
//     provider.getShops();
//     shopList = provider.throwshopList;

//     // // singleplace
//     // provider.getplaceList();
//     // singlePlaceList = provider.throwSinglePlaceModleList;
//     // //2

//     //for palcecategory details page
//     provider.getGarmentCategoriesList();
//     garmentCategoriesList = provider.throwGetsHouseCategoriesList;
//     provider.generalStoreCategoriesList();
//     generalstoreCategoriesList = provider.throwHotelCategoriesList;
//     provider.pharmacyCategoriesList();
//     pharmacyCategoriesList = provider.throwPlaceCategoriesList;
//     // provider.getTransportCategoriesList();
//     // transportCategoriesList = provider.throwTransportCategoriesList;

//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 104, 103, 103),
//         appBar: AppBar(
//           title: Center(
//             child: const Text('Home page'),
//           ),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => ProfileScreen()));
//                 },
//                 icon: Icon(Icons.person))
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 child: TextField(
//                   style: const TextStyle(
//                     color: Colors.white,
//                   ),
//                   decoration: InputDecoration(
//                       hintText: "Search ",
//                       hintStyle: const TextStyle(color: Colors.white),
//                       prefixIcon: const Icon(
//                         Icons.search,
//                         color: Colors.white,
//                       ),
//                       filled: true,
//                       fillColor: const Color(0xff3a3e3e),
//                       border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10))),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 40),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Category',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     gesthouse(), hotel(), Garment(), stationary()
//                     //  visitplace(), transport()
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Explorer Shop',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               // Container(
//               //   margin: const EdgeInsets.symmetric(horizontal: 10),
//               //   height: MediaQuery.of(context).size.height,
//               //   // width: 500,
//               //   child: GridView.count(
//               //       shrinkWrap: false,
//               //       primary: false,
//               //       crossAxisCount: 2,
//               //       childAspectRatio: 0.8,
//               //       crossAxisSpacing: 20,
//               //       mainAxisSpacing: 20,
//               //       children: singlePlaceList
//               //           .map(
//               //             (e) => BottomContainer(
//               //               onTap: () {
//               //                 Navigator.of(context).pushReplacement(
//               //                   MaterialPageRoute(
//               //                     builder: (context) => DetailPage(
//               //                       image: e.image,
//               //                       name: e.name,
//               //                       number: e.number,
//               //                       address: e.address,
//               //                       description: e.description,
//               //                     ),
//               //                   ),
//               //                 );
//               //               },
//               //               image: e.image,
//               //               number: e.number,
//               //               name: e.name,
//               //             ),
//               //           )
//               //           .toList()),
//               // )
//             ],
//           ),
//         ));
//   }
// }

// // const SizedBox(
// //   height: 20,
// // ),
// // Container(
// //   margin: EdgeInsets.symmetric(horizontal: 10),
// //   height: 510,
// //   // width: 500,
// //   child: GridView.count(
// //       shrinkWrap: false,
// //       primary: false,
// //       crossAxisCount: 2,
// //       childAspectRatio: 0.8,
// //       crossAxisSpacing: 20,
// //       mainAxisSpacing: 20,
// //       children: singlePlaceList
// //           .map(
// //             (e) => BottomContainer(
// //               onTap: () {
// //                 Navigator.of(context).pushReplacement(
// //                   MaterialPageRoute(
// //                     builder: (context) => DetailPage(
// //                       image: e.image,
// //                       name: e.name,
// //                       number: e.number,
// //                     ),
// //                   ),
// //                 );
// //               },
// //               image: e.image,
// //               number: e.number,
// //               name: e.name,
// //             ),
// //           )
// //           .toList()),
// // )
