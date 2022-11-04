import 'dart:convert';

import 'package:flutter/services.dart';

class DataChannel {
  static const channel = MethodChannel('DataChannel');
  final _dataStopwatch = Stopwatch();
  final _imageStopwatch = Stopwatch();

  Future<Map<String, dynamic>> getData() async {
    try {
      _dataStopwatch.reset();
      _dataStopwatch.start();
      final data =
          (await channel.invokeMethod<Map>('getData'))!.map<String, dynamic>(
        (key, value) => MapEntry(
          key,
          json.decode(value),
        ),
      );
      _dataStopwatch.stop();
      print('getData: ${_dataStopwatch.elapsed}');
      return data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Uint8List> getImage() async {
    try {
      _imageStopwatch.reset();
      _imageStopwatch.start();
      final data = (await channel.invokeMethod<Uint8List>('getImage'))!;
      _imageStopwatch.stop();
      print('getImage: ${_imageStopwatch.elapsed}');
      return data;
    } catch (e) {
      print(e);
      return Uint8List.fromList([]);
    }
  }
}
