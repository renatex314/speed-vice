import 'dart:math';

import 'package:flutter/material.dart';

class SpeedometerLimit {
  double limitFactor;
  Color color;

  SpeedometerLimit({required this.limitFactor, required this.color});
}

class _Painter extends CustomPainter {
  late List<SpeedometerLimit> limits;
  late double currentFactor;

  _Painter({
    required List<SpeedometerLimit> limits,
    required double currentFactor,
  }) {
    this.limits = List.from(limits);
    this.limits.sort((a, b) => b.limitFactor.compareTo(a.limitFactor));

    this.currentFactor = max(0.0, min(1.0, currentFactor));
  }

  void _drawArc(
    double cx,
    double cy,
    double size,
    double factor,
    Paint paint,
    Canvas canvas,
  ) {
    canvas.drawArc(
      Rect.fromLTWH(
        cx - size / 2.0,
        cy - size / 2.0,
        size,
        size,
      ),
      5 / 6 * pi,
      (4 / 3 * pi) * factor,
      false,
      paint,
    );
  }

  void _drawLimits(Canvas canvas, Size size) {
    final arcSize = min(size.width, size.height) - 40;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30
      ..color = Colors.black;

    _drawArc(
      size.width / 2.0,
      size.height / 2.0,
      arcSize,
      1,
      basePaint,
      canvas,
    );

    for (var limit in limits) {
      final limitPaint = Paint.from(basePaint)
        ..strokeWidth = 12
        ..color = limit.color;

      _drawArc(
        size.width / 2.0,
        size.height / 2.0,
        arcSize,
        min(limit.limitFactor, currentFactor),
        limitPaint,
        canvas,
      );
    }
  }

  void _drawInnerDot(Canvas canvas, Size size) {
    const double dotSize = 15;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawCircle(
      Offset(
        size.width / 2.0,
        size.height / 2.0,
      ),
      dotSize,
      dotPaint,
    );
  }

  void _drawPointer(Canvas canvas, Size size) {
    final middleX = size.width / 2.0;
    final middleY = size.height / 2.0;
    const strokeSize = 10.0;
    final pointerSize = min(size.width, size.height) / 4.0;

    final pointerStrokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeSize
      ..strokeCap = StrokeCap.round
      ..color = Colors.black;

    final pointerFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    final pointerFillPath = Path()
      ..moveTo(-strokeSize, 0)
      ..lineTo(0, pointerSize)
      ..lineTo(0 + strokeSize, 0)
      ..lineTo(0 - strokeSize, 0)
      ..close();

    final pointerStrokePath = Path()
      ..moveTo(-strokeSize, 0)
      ..lineTo(0, pointerSize)
      ..moveTo(0, pointerSize)
      ..lineTo(strokeSize, 0)
      ..moveTo(strokeSize, 0)
      ..lineTo(-strokeSize, 0)
      ..close();

    canvas.save();
    canvas.translate(middleX, middleY);
    canvas.rotate(pi / 3 + ((4 / 3 * pi) * currentFactor));

    canvas.drawPath(
      pointerStrokePath,
      pointerStrokePaint,
    );
    canvas.drawPath(
      pointerFillPath,
      pointerFillPaint,
    );

    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawLimits(canvas, size);
    _drawInnerDot(canvas, size);
    _drawPointer(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Speedometer extends StatefulWidget {
  final bool animated;
  final double factor;

  const Speedometer({super.key, required this.factor, this.animated = false});

  @override
  State<StatefulWidget> createState() {
    return SpeedometerState();
  }
}

class SpeedometerState extends State<Speedometer>
    with SingleTickerProviderStateMixin {
  double _currentFactor = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;
  late Tween<double> _tween;

  void updateCurrentFactor() {
    final newFactor = widget.factor;

    if (_currentFactor != newFactor) {
      if (!widget.animated) {
        setState(() {
          _currentFactor = widget.factor;
        });

        return;
      }

      _tween.begin = _tween.end;
      _animationController.reset();
      _tween.end = widget.factor;
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tween = Tween(begin: _currentFactor, end: widget.factor);
    _animation = _tween.animate(_animationController)
      ..addListener(() {
        setState(() {
          _currentFactor = _animation.value;
        });
      });
    updateCurrentFactor();
  }

  @override
  void didUpdateWidget(covariant Speedometer oldWidget) {
    updateCurrentFactor();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: CustomPaint(
        painter: _Painter(
          limits: [
            SpeedometerLimit(limitFactor: 0.5, color: Colors.blue),
            SpeedometerLimit(limitFactor: 0.7, color: Colors.orange),
            SpeedometerLimit(limitFactor: 1, color: Colors.red),
          ],
          currentFactor: _currentFactor,
        ),
      ),
    );
  }
}
