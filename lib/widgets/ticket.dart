import 'package:flutter/material.dart';

class TicketPainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;

  static const _cornerGap = 20.0;
  static const _cutoutRadius = 20.0;
  static const _cutoutDiameter = _cutoutRadius * 2;

  TicketPainter({required this.bgColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = size.width;
    final maxHeight = size.height;

    final cutoutStartPos = maxHeight - maxHeight * 0.35;
    final leftCutoutStartY = cutoutStartPos;
    final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;
    final dottedLineY = cutoutStartPos - _cutoutRadius;
    double dottedLineStartX = _cutoutRadius;
    final double dottedLineEndX = maxWidth - _cutoutRadius;
    const double dashWidth = 8.5;
    const double dashSpace = 4;

    final paintBg = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = bgColor;

    final paintBorder = Paint()
      ..strokeWidth = 0.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = borderColor;

    final paintDottedLine = Paint()
      ..color = borderColor.withOpacity(0.5)
      ..strokeWidth = 1.2;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    var path = Path();

    path.moveTo(_cornerGap, 0);
    path.lineTo(maxWidth - _cornerGap, 0);
    _drawCornerArc(path, maxWidth, _cornerGap);
    path.lineTo(maxWidth, rightCutoutStartY);
    _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);
    path.lineTo(maxWidth, maxHeight - _cornerGap);
    _drawCornerArc(path, maxWidth - _cornerGap, maxHeight);
    path.lineTo(_cornerGap, maxHeight);
    _drawCornerArc(path, 0, maxHeight - _cornerGap);
    path.lineTo(0, leftCutoutStartY);
    _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);
    path.lineTo(0, _cornerGap);
    _drawCornerArc(path, _cornerGap, 0);

    canvas.drawShadow(path, Colors.black, 5.0, true);

    canvas.drawPath(path, paintBg);
    canvas.drawPath(path, paintBorder);

    while (dottedLineStartX < dottedLineEndX) {
      canvas.drawLine(
        Offset(dottedLineStartX, dottedLineY),
        Offset(dottedLineStartX + dashWidth, dottedLineY),
        paintDottedLine,
      );
      dottedLineStartX += dashWidth + dashSpace;
    }
  }

  _drawCutout(Path path, double startX, double endY) {
    path.arcToPoint(
      Offset(startX, endY),
      radius: const Radius.circular(_cutoutRadius),
      clockwise: false,
    );
  }

  _drawCornerArc(Path path, double endPointX, double endPointY) {
    path.arcToPoint(
      Offset(endPointX, endPointY),
      radius: const Radius.circular(_cornerGap),
    );
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
}

// import 'package:flutter/material.dart';

// class TicketPainter extends CustomPainter {
//   final Color bgColor;
//   final Color shadowColor;

//   static const _cornerGap = 20.0;
//   static const _cutoutRadius = 20.0;
//   static const _cutoutDiameter = _cutoutRadius * 2;

//   TicketPainter({required this.bgColor, required this.shadowColor});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final maxWidth = size.width;
//     final maxHeight = size.height;

//     final cutoutStartPos = maxHeight - maxHeight * 0.4;
//     final leftCutoutStartY = cutoutStartPos;
//     final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;
//     final dottedLineY = cutoutStartPos - _cutoutRadius;
//     double dottedLineStartX = _cutoutRadius;
//     final double dottedLineEndX = maxWidth - _cutoutRadius - 10;
//     const double dashWidth = 8.5;
//     const double dashSpace = 4;

//     final paintBg = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeCap = StrokeCap.round
//       ..color = bgColor;

//     final paintShadow = Paint()
//       ..color = shadowColor.withOpacity(0.5)
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

//     var path = Path();

//     path.moveTo(_cornerGap, 0);
//     path.lineTo(maxWidth - _cornerGap, 0);
//     _drawCornerArc(path, maxWidth, _cornerGap);
//     path.lineTo(maxWidth, rightCutoutStartY);
//     _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);
//     path.lineTo(maxWidth, maxHeight - _cornerGap);
//     _drawCornerArc(path, maxWidth - _cornerGap, maxHeight);
//     path.lineTo(_cornerGap, maxHeight);
//     _drawCornerArc(path, 0, maxHeight - _cornerGap);
//     path.lineTo(0, leftCutoutStartY);
//     _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);
//     path.lineTo(0, _cornerGap);
//     _drawCornerArc(path, _cornerGap, 0);

//     // Draw the shadow
//     canvas.drawShadow(path, Colors.black, 5.0, false);

//     // Draw the background
//     canvas.drawPath(path, paintBg);

//     // Draw the dotted line
//     while (dottedLineStartX < dottedLineEndX) {
//       canvas.drawLine(
//         Offset(dottedLineStartX, dottedLineY),
//         Offset(dottedLineStartX + dashWidth, dottedLineY),
//         paintShadow, // Use the shadow paint for the dotted line
//       );
//       dottedLineStartX += dashWidth + dashSpace;
//     }
//   }

//   _drawCutout(Path path, double startX, double endY) {
//     path.arcToPoint(
//       Offset(startX, endY),
//       radius: const Radius.circular(_cutoutRadius),
//       clockwise: false,
//     );
//   }

//   _drawCornerArc(Path path, double endPointX, double endPointY) {
//     path.arcToPoint(
//       Offset(endPointX, endPointY),
//       radius: const Radius.circular(_cornerGap),
//     );
//   }

//   @override
//   bool shouldRepaint(TicketPainter oldDelegate) => false;

//   @override
//   bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
// }
