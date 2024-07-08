import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  final String image;
  final String name;
  final String number;
  final Function() onTap;
  BottomContainer(
      {required this.onTap,
      required this.image,
      required this.number,
      required this.name});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 290,
        width: 220,
        decoration: const BoxDecoration(
          color: Color(0xff3a3e3e),
          // borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 130,
              width: 158,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
            // CircleAvatar(
            //   radius: 60,
            //   backgroundImage: NetworkImage(image),
            // ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                name,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            // ListTile(
            //   leading: Text(
            //     name,
            //     style: TextStyle(fontSize: 20, color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
