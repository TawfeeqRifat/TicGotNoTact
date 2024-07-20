import 'package:flutter/material.dart';

class customShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define your custom painting operations using canvas methods

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth =1.5
      ..style=PaintingStyle.stroke;

    final path =Path();
    path.moveTo(size.width+5, 0);
    path.lineTo(size.width-(2*size.width/3),0);
    path.lineTo(size.width-(9*size.width/10), size.height);
    path.lineTo(size.width+5, size.height);
    path.close();
    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // Set to true to repaint when notified
  }
}

// class LinePainter extends CustomPainter {
//
//   double _progress;
//
//
//   Paint _paint= Paint()
//       ..color = Colors.green
//       ..strokeWidth = 8.0;
//
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawLine(Offset(0.0, 0.0), Offset(size.width - size.width * _progress, size.height - size.height * _progress), _paint);
//   }
//
//   @override
//   bool shouldRepaint(LinePainter oldDelegate) {
//     return oldDelegate._progress != _progress;
//   }
// }