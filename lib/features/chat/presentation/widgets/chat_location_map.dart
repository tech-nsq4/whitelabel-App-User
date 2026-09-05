import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChatLocationMap extends StatelessWidget {
  const ChatLocationMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.width,
    required this.height,
    this.zoom = 16,
  });

  final double lat;
  final double lng;
  final double width;
  final double height;
  final int zoom;

  @override
  Widget build(BuildContext context) {
    final tilesAcross = math.pow(2, zoom).toDouble();
    final centerTileX = (lng + 180) / 360 * tilesAcross;
    final latRad = lat * math.pi / 180;
    final centerTileY = (1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) / 2 * tilesAcross;

    final originPxX = centerTileX * 256 - width / 2;
    final originPxY = centerTileY * 256 - height / 2;

    final tileXStart = (originPxX / 256).floor();
    final tileXEnd = ((originPxX + width) / 256).floor();
    final tileYStart = (originPxY / 256).floor();
    final tileYEnd = ((originPxY + height) / 256).floor();

    final tiles = <Widget>[];
    for (var tx = tileXStart; tx <= tileXEnd; tx++) {
      for (var ty = tileYStart; ty <= tileYEnd; ty++) {
        final wrappedX = tx % tilesAcross.toInt();
        tiles.add(Positioned(
          left: tx * 256 - originPxX,
          top: ty * 256 - originPxY,
          width: 256,
          height: 256,
          child: Image.network(
            'https://tile.openstreetmap.org/$zoom/$wrappedX/$ty.png',
            fit: BoxFit.cover,
            headers: const {'User-Agent': 'VivacareWhiteLabel/1.0'},
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE7E3DA)),
          ),
        ));
      }
    }

    return ClipRect(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(children: tiles),
      ),
    );
  }
}
