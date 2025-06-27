import 'package:flutter/material.dart';

class TopWaveClipper extends CustomClipper<Path> {
  final double waveHeight;

  TopWaveClipper({this.waveHeight = 50.0});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - waveHeight);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - waveHeight / 1.5);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - waveHeight * 1.6);
    var secondEndPoint = Offset(size.width, size.height - waveHeight);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // Reclip if the parameters change
  }
}

class WaveClipperWidget extends StatelessWidget {
  final double height;
  final Color color;
  final double waveHeight;

  const WaveClipperWidget({
    super.key,
    required this.height,
    required this.color,
    this.waveHeight = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(waveHeight: waveHeight), // Use TopWaveClipper here
      child: Container(
        height: height,
        color: color,
      ),
    );
  }
}
