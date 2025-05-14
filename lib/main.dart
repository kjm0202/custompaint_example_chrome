import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrome Icon',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: ChromeIconWidget()),
      ),
    );
  }
}

class ChromeIconWidget extends StatelessWidget {
  const ChromeIconWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(painter: _ChromeIconPainter()),
    );
  }
}

class _ChromeIconPainter extends CustomPainter {
  static const Color _red = Color(0xFFDD5144);
  static const Color _yellow = Color(0xFFFFCD46);
  static const Color _green = Color(0xFF1DA462);
  static const Color _blue = Color(0xFF4C8BF5);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = min(size.width, size.height) / 2;
    final innerR = outerR * 0.5;
    final blueR = outerR * 0.4;
    final t = sqrt(outerR * outerR - innerR * innerR);

    // ← 여기를 수정 ↓
    final phi = <double>[
      5 * pi / 6, // 150°
      1 * pi / 6, //  30°
      3 * pi / 2, // 270°
    ];

    final Ts =
        phi.map((a) => center + Offset(cos(a), sin(a)) * innerR).toList();

    final Ps = phi.map((a) {
      final Ti = Offset(cos(a), sin(a)) * innerR;
      final v = Offset(-sin(a), cos(a));
      return center + Ti + v * t;
    }).toList();

    final colors = <Color>[
      _green, // φ[0]→φ[1]: 위쪽
      _yellow, // φ[1]→φ[2]: 오른쪽
      _red, // φ[2]→φ[0]: 왼쪽
    ];

    final outerRect = Rect.fromCircle(center: center, radius: outerR);
    const sweep = -2 * pi / 3; // CW 120°

    for (var i = 0; i < 3; i++) {
      final j = (i + 1) % 3;
      final path = Path()
        ..moveTo(Ps[i].dx, Ps[i].dy)
        ..arcTo(outerRect, atan2(Ps[i].dy - center.dy, Ps[i].dx - center.dx),
            sweep, false)
        ..lineTo(Ts[j].dx, Ts[j].dy)
        ..lineTo(Ts[i].dx, Ts[i].dy)
        ..close();

      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = colors[i]);
    }

    // 흰색 링 & 파란 원
    canvas.drawCircle(
        center,
        innerR,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
    canvas.drawCircle(
        center,
        blueR,
        Paint()
          ..style = PaintingStyle.fill
          ..color = _blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
