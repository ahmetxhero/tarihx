import 'package:flutter/material.dart';

class GoogleLogoIcon extends StatelessWidget {
  final double size;

  const GoogleLogoIcon({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 24.0;
    canvas.scale(scale, scale);

    // Red Path
    final Path redPath = Path()
      ..moveTo(12.0, 5.0)
      ..cubicTo(14.07, 5.0, 15.93, 5.76, 17.38, 7.12)
      ..lineTo(20.8, 3.7)
      ..cubicTo(18.52, 1.57, 15.52, 0.33, 12.0, 0.33)
      ..cubicTo(7.31, 0.33, 3.26, 3.03, 1.29, 6.96)
      ..lineTo(5.17, 9.97)
      ..cubicTo(6.12, 7.12, 8.77, 5.0, 12.0, 5.0)
      ..close();
    canvas.drawPath(redPath, Paint()..color = const Color(0xFFEA4335));

    // Blue Path
    final Path bluePath = Path()
      ..moveTo(23.49, 12.27)
      ..cubicTo(23.49, 11.47, 23.41, 10.74, 23.3, 10.0)
      ..lineTo(12.0, 10.0)
      ..lineTo(12.0, 14.51)
      ..lineTo(18.47, 14.51)
      ..cubicTo(18.18, 15.99, 17.31, 17.24, 16.05, 18.09)
      ..lineTo(19.93, 21.1)
      ..cubicTo(22.2, 19.01, 23.49, 15.92, 23.49, 12.27)
      ..close();
    canvas.drawPath(bluePath, Paint()..color = const Color(0xFF4285F4));

    // Green Path
    final Path greenPath = Path()
      ..moveTo(12.0, 23.67)
      ..cubicTo(15.52, 23.67, 18.47, 22.51, 20.61, 20.54)
      ..lineTo(16.73, 17.53)
      ..cubicTo(15.52, 18.34, 13.91, 18.84, 12.0, 18.84)
      ..cubicTo(8.77, 18.84, 6.12, 16.72, 5.16, 13.87)
      ..lineTo(1.28, 16.88)
      ..cubicTo(3.26, 20.81, 7.31, 23.67, 12.0, 23.67)
      ..close();
    canvas.drawPath(greenPath, Paint()..color = const Color(0xFF34A853));

    // Yellow Path
    final Path yellowPath = Path()
      ..moveTo(5.16, 13.87)
      ..cubicTo(4.91, 13.12, 4.77, 12.32, 4.77, 11.5)
      ..cubicTo(4.77, 10.68, 4.91, 9.88, 5.16, 9.13)
      ..lineTo(1.28, 6.12)
      ..cubicTo(0.46, 7.75, 0.0, 9.57, 0.0, 11.5)
      ..cubicTo(0.0, 13.43, 0.46, 15.25, 1.28, 16.88)
      ..lineTo(5.16, 13.87)
      ..close();
    canvas.drawPath(yellowPath, Paint()..color = const Color(0xFFFBBC05));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppleLogoIcon extends StatelessWidget {
  final double size;
  final Color color;

  const AppleLogoIcon({super.key, this.size = 20.0, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AppleLogoPainter(color: color),
      ),
    );
  }
}

class _AppleLogoPainter extends CustomPainter {
  final Color color;

  _AppleLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Standard normalized Apple logo
    final Path normApple = Path()
      ..moveTo(14.86, 11.82)
      ..cubicTo(14.83, 9.38, 16.85, 8.16, 16.94, 8.1)
      ..cubicTo(15.8, 6.44, 14.04, 6.2, 13.43, 6.17)
      ..cubicTo(11.94, 6.02, 10.5, 7.06, 9.74, 7.06)
      ..cubicTo(8.98, 7.06, 7.8, 6.19, 6.55, 6.21)
      ..cubicTo(4.92, 6.24, 3.41, 7.16, 2.58, 8.61)
      ..cubicTo(0.88, 11.56, 2.15, 15.93, 3.8, 18.32)
      ..cubicTo(4.61, 19.49, 5.56, 20.8, 6.83, 20.75)
      ..cubicTo(8.05, 20.7, 8.52, 19.96, 9.99, 19.96)
      ..cubicTo(11.46, 19.96, 11.89, 20.75, 13.17, 20.72)
      ..cubicTo(14.47, 20.7, 15.29, 19.52, 16.08, 18.36)
      ..cubicTo(17.01, 17.02, 17.39, 15.71, 17.41, 15.64)
      ..cubicTo(17.36, 15.62, 14.89, 14.67, 14.86, 11.82)
      ..close()
      ..moveTo(11.84, 4.41)
      ..cubicTo(12.5, 3.6, 12.96, 2.47, 12.83, 1.34)
      ..cubicTo(11.86, 1.38, 10.66, 1.99, 9.97, 2.8)
      ..cubicTo(9.35, 3.52, 8.81, 4.67, 8.96, 5.78)
      ..cubicTo(10.05, 5.86, 11.18, 5.22, 11.84, 4.41)
      ..close();

    canvas.save();
    canvas.scale(size.width / 20.0, size.height / 22.0);
    canvas.drawPath(normApple, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppleLogoPainter oldDelegate) => oldDelegate.color != color;
}
