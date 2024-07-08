import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  const GetTextField({
    Key? key,
    required this.labelText,
    required this.textEditingController,
    this.readOnly = false,
  }) : super(key: key);

  final String labelText;
  final bool? readOnly;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 235, 232, 232),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                readOnly: readOnly!,
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.black, // Set the text color to black
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
