import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomeSliderProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _rowData = [];
  List<Map<String, dynamic>> get rowData => _rowData;

  Future<void> fetchData() async {
    const String sheetId = '1j1k6RQIyopHwUba3ki04uLfa1fdYJiM2qXWToKhvUwc';
    const String sheetTitle = 'slider';
    const String sheetRange = 'A2:C7';

    var cacheManager = DefaultCacheManager();

    var fileInfo = await cacheManager.getFileFromCache(
        'https://docs.google.com/spreadsheets/d/$sheetId/gviz/tq?sheet=$sheetTitle&range=$sheetRange');

    if (fileInfo != null && fileInfo.file.existsSync()) {
      final jsonString = await fileInfo.file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonString);
      _updateData(data['table']['rows']);
    } else {
      final response = await http.get(Uri.parse(
          'https://docs.google.com/spreadsheets/d/$sheetId/gviz/tq?sheet=$sheetTitle&range=$sheetRange'));

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final startIndex = responseBody.indexOf('({') + 1;
        final endIndex = responseBody.lastIndexOf('})') + 1;
        final jsonString = responseBody.substring(startIndex, endIndex);

        final Map<String, dynamic> data = json.decode(jsonString);
        _updateData(data['table']['rows']);

        final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonString));

        cacheManager.putFile(
          'https://docs.google.com/spreadsheets/d/$sheetId/gviz/tq?sheet=$sheetTitle&range=$sheetRange',
          bytes,
        );
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  void _updateData(List<dynamic> rows) {
    _rowData = rows.map((row) {
      final List<dynamic> cells = row['c'];
      String title = cells.length > 0 && cells[0] != null ? cells[0]['v'] : '';
      String subtitle =
          cells.length > 1 && cells[1] != null ? cells[1]['v'] : '';
      String imagePath =
          cells.length > 2 && cells[2] != null ? cells[2]['v'] : '';

      return {
        'title': title,
        'subtitle': subtitle,
        'imagePath': imagePath,
      };
    }).toList();

    notifyListeners();
  }
}
