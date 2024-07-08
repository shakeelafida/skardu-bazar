// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:skardubazar/models/shopmodel.dart';
// import 'package:skardubazar/provider/my_provider.dart';
// import 'package:skardubazar/views/home_page.dart';

// class shops extends StatefulWidget {
//   @override
//   State<shops> createState() => _shopsState();
// }

// class _shopsState extends State<shops> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<MyProvider>(context, listen: false).getShops();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'List of Menu',
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//         elevation: 0.0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => const Home_Page()),
//             );
//           },
//         ),
//       ),
//       body: Consumer<MyProvider>(
//         builder: (context, provider, _) {
//           List<shopModle> shopList = provider.throwshopList;
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//             child: GridView.count(
//               shrinkWrap: true,
//               crossAxisCount: 2,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 20,
//               children: shopList.map((shop) {
//                 return categoriesContainer(
//                   image: shop.image,
//                   name: shop.name,
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }

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
//                 image: NetworkImage(image),
//                 fit: BoxFit.cover,
//               ),
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
// }