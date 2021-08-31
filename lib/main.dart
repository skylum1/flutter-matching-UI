import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Custom Painter',
      home: Scaffold(
        body: CustomPainterDraggable(),
      ),
    );
  }
}

class CustomPainterDraggable extends StatefulWidget {
  @override
  _CustomPainterDraggableState createState() => _CustomPainterDraggableState();
}

class _CustomPainterDraggableState extends State<CustomPainterDraggable> {
  var xPosf = 20.0;
  var yPosf = 100.0;
  final width = 120.0;
  final height = 80.0;
  bool _dragging = false;
  late double xPos;
  late double yPos;

  /// Is the point (x, y) inside the rect
  bool _insideRect(double x, double y) =>
      x >= xPos && x <= xPos + 20 && y >= yPos && y <= yPos + 20;
  @override
  void initState() {
    xPos = xPosf + width;
    yPos = yPosf + height / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _dragging = _insideRect(
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      onPanEnd: (details) {
        setState(() {
          _dragging = false;
          xPos = xPosf + width;
          yPos = yPosf + height / 2;
        });
      },
      onPanUpdate: (details) {
        if (_dragging) {
          setState(() {
            xPos += details.delta.dx;
            yPos += details.delta.dy;
          });
        }
      },
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: RectanglePainter(Rect.fromLTWH(xPosf, yPosf, width, height),
              srect: Rect.fromLTWH(xPos, yPos, 20, 20)),
          child: Container(),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect, {required this.srect});
  final Rect rect;
  final Rect srect;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.red[800]!
      ..style = PaintingStyle.stroke;
    double x = srect.left;
    double y = (srect.top + srect.bottom) / 2;
    final path = new Path()
      ..moveTo(rect.right, (rect.top + rect.bottom) / 2)
      ..cubicTo(
        (rect.right + (x - rect.right) / 2),
        (rect.top + rect.bottom) / 2,
        (x - (x - rect.right) / 2),
        y,
        x,
        y,
      );
    // Rect temp = Rect.fromLTWH(rect.right, (rect.top + rect.bottom) / 2, 20, 20);

    canvas.drawPath(path, paint);
    canvas.drawRect(rect, Paint());
    canvas.drawRect(srect, Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
