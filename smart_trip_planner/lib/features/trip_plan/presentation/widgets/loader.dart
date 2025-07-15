import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  final String message;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double size;
  final double strokeWidth;
  final TextStyle? textStyle;

  const CustomLoader({
    Key? key,
    this.message = 'Loading...',
    this.primaryColor,
    this.backgroundColor,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.textStyle,
  }) : super(key: key);

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: CustomPaint(
                  painter: LoaderPainter(
                    primaryColor:
                        widget.primaryColor ?? Theme.of(context).primaryColor,
                    backgroundColor:
                        widget.backgroundColor ?? Colors.grey.shade300,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.message,
          style:
              widget.textStyle ??
              const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class LoaderPainter extends CustomPainter {
  final Color primaryColor;
  final Color backgroundColor;
  final double strokeWidth;

  LoaderPainter({
    required this.primaryColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const sweepAngle = 1.5; // About 1/4 of the circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57, // Start from top (-90 degrees in radians)
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
