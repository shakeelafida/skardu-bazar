import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

   Widget categoriesContainer(
      {required Function() onTap,
      required String image,
      required String name}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(image)),
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        )
      ],
    );
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(children: [
        
      ],),
    );
  }
}