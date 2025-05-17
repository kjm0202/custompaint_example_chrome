import 'dart:math'; // 삼각함수 및 sqrt 등 수학 함수 사용을 위해 import
import 'package:flutter/material.dart';

void main() => runApp(const MyApp()); // 앱 시작점

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrome Icon',
      home: Scaffold(
        backgroundColor: Colors.black, // 배경을 검은색으로 설정
        body: const Center(child: ChromeIconWidget()), // 가운데에 아이콘 배치
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
      child: CustomPaint(painter: _ChromeIconPainter()), // 커스텀 페인터 적용
    );
  }
}

class _ChromeIconPainter extends CustomPainter {
  // 색상 상수 정의 (Chrome 로고 색상)
  static const Color _red = Color(0xFFDD5144);
  static const Color _yellow = Color(0xFFFFCD46);
  static const Color _green = Color(0xFF1DA462);
  static const Color _blue = Color(0xFF4C8BF5);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2); // 중심 좌표
    final outerR = min(size.width, size.height) / 2; // 바깥 반지름
    final innerR = outerR * 0.5; // 흰 링 반지름
    final blueR = outerR * 0.4; // 파란 원 반지름
    final t = sqrt(outerR * outerR - innerR * innerR); // 중심삼각형 외접좌표를 위한 거리 계산

    // φ: 각 꼭짓점의 중심각 (150°, 30°, 270°)
    final phi = <double>[
      5 * pi / 6, // 초록 영역 기준
      1 * pi / 6, // 노랑 영역 기준
      3 * pi / 2, // 빨강 영역 기준
    ];

    // Ts: 중심으로부터 내부 반지름 길이만큼 떨어진 꼭짓점 좌표
    final Ts =
        phi.map((a) => center + Offset(cos(a), sin(a)) * innerR).toList();

    // Ps: 바깥 아크의 시작점 좌표 (내부 점에서 수직 벡터로 t만큼 이동)
    final Ps = phi.map((a) {
      final Ti = Offset(cos(a), sin(a)) * innerR;
      final v = Offset(-sin(a), cos(a)); // 단위 벡터에 수직인 방향으로 회전
      return center + Ti + v * t;
    }).toList();

    // 색상 배열: 각 섹션 색상 (CW 순서)
    final colors = <Color>[
      _green,  // φ[0] → φ[1]
      _yellow, // φ[1] → φ[2]
      _red,    // φ[2] → φ[0]
    ];

    final outerRect = Rect.fromCircle(center: center, radius: outerR); // 바깥 원 경계
    const sweep = -2 * pi / 3; // 시계 방향 120도 (각 영역의 호 길이)

    // 삼각형 + 호 영역을 그리기 (3개)
    for (var i = 0; i < 3; i++) {
      final j = (i + 1) % 3;
      final path = Path()
        ..moveTo(Ps[i].dx, Ps[i].dy) // 바깥 호 시작점
        ..arcTo(
            outerRect,
            atan2(Ps[i].dy - center.dy, Ps[i].dx - center.dx), // 호 시작 각도
            sweep, // 호 길이
            false)
        ..lineTo(Ts[j].dx, Ts[j].dy) // 안쪽 꼭짓점 (다음)
        ..lineTo(Ts[i].dx, Ts[i].dy) // 안쪽 꼭짓점 (현재)
        ..close(); // 패스 닫기

      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = colors[i]); // 각 영역 색상 채우기
    }

    // 중심 흰색 링
    canvas.drawCircle(
        center,
        innerR,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);

    // 파란 원 (중심)
    canvas.drawCircle(
        center,
        blueR,
        Paint()
          ..style = PaintingStyle.fill
          ..color = _blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false; // 정적인 그림이라 다시 그릴 필요 없음
}
