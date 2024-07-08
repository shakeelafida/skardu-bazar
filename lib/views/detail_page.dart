// import 'package:flutter/material.dart';

// //import 'package:foodapp/screen/cart_page.dart';
// //import 'package:foodapp/screen/home_page.dart';
// import 'package:provider/provider.dart';

// import '../provider/my_provider.dart';
// import 'home_page.dart';

// class DetailPage extends StatefulWidget {
//   final String image;
//   final String number;
//   final String name;
//   final String address;
//   final String description;
//   DetailPage(
//       {required this.image,
//       required this.name,
//       required this.number,
//       required this.address,
//       required this.description});

//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   int quantity = 1;
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     MyProvider provider = Provider.of<MyProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//             child: Text('Details',
//                 style: TextStyle(color: Colors.white, fontSize: 20))),
//         elevation: 0.0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const Home_Page()));
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           // SizedBox(
//           //   height: 10,
//           // ),
//           Expanded(
//             child: Container(
//                 width: size.width,
//                 height: size.height * .2,
//                 decoration: BoxDecoration(
//                     color: Colors.greenAccent,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Image.network(
//                   widget.image,
//                   fit: BoxFit.fill,
//                 )
//                 //  CircleAvatar(
//                 //   radius: 110,
//                 //   backgroundImage: NetworkImage(widget.image),
//                 // ),
//                 ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               width: double.infinity,
//               // height: ,
//               decoration: const BoxDecoration(
//                   color: Color(0xff3a3e3e),
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10))),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.name,
//                       style: const TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'Contact No:',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           widget.number,
//                           style: const TextStyle(
//                               fontSize: 20, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'Address:',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: Text(
//                             widget.address,
//                             style: const TextStyle(
//                                 fontSize: 15, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     const Text(
//                       "Description",
//                       style: TextStyle(
//                           fontSize: 25,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       widget.description,
//                       style: TextStyle(fontSize: 15, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
