import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Stationary_shop extends ChangeNotifier {
  final List<Map<String, dynamic>> _rowData = [];

  List<Map<String, dynamic>> get rowData => _rowData;

  Future<void> fetchData() async {
    const String sheetId = '1j1k6RQIyopHwUba3ki04uLfa1fdYJiM2qXWToKhvUwc';
    const String sheetTitle = 'stationaryshop';
    const String sheetRange = 'A2:F';
    try {
      final response = await http.get(Uri.parse(
          'https://docs.google.com/spreadsheets/d/$sheetId/gviz/tq?sheet=$sheetTitle&range=$sheetRange'));

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final startIndex = responseBody.indexOf('({') + 1;
        final endIndex = responseBody.lastIndexOf('})') + 1;
        final jsonString = responseBody.substring(startIndex, endIndex);
        final Map<String, dynamic> data = json.decode(jsonString);
        final List<dynamic> rows = data['table']['rows'];

        _rowData.clear();

        _rowData.addAll(rows.map((row) {
          final List<dynamic> cells = row['c'];
          return {
            'name': cells[0]['v'],
            'imagePath': cells[1]['v'],
            'address': cells[2]['v'],
            'phoneno': _formatPhoneNumber(
              cells[3]['v'],
            ),
            'productname': cells[4]['v'],
            'rating': cells[5]['v'],
          };
        }).toList());

        notifyListeners();
      } else {
        throw Exception(
            'Failed to load data. Server responded with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: ${error}');
      throw Exception(
          'Failed to load data. Please check your internet connection and try again.');
    }
  }

  String _formatPhoneNumber(dynamic phoneNumber) {
    if (phoneNumber == null) {
      return '';
    }
    if (phoneNumber is double) {
      return phoneNumber.toInt().toString();
    }
    return phoneNumber.toString();
  }
}
