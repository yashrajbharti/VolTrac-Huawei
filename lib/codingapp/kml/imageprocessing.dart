import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:huawei_map/components/bitmapDescriptor.dart';
import 'package:huawei_map/components/components.dart';
import 'package:huawei_map/map.dart';

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
    String path, int width) async {
  final Uint8List imageData = await getBytesFromAsset(path, width);
  return BitmapDescriptor.fromBytes(imageData);
}
