import 'package:flutter/material.dart';

class SkeuoContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isPressed;

  const SkeuoContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 20,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color baseColor = Color(0xFF1A1C1E);
    
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05),
                  offset: const Offset(-2, -2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05),
                  offset: const Offset(-6, -6),
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(6, 6),
                  blurRadius: 12,
                ),
              ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPressed
              ? [
                  baseColor.withValues(alpha: 0.9),
                  baseColor,
                ]
              : [
                  const Color(0xFF232629),
                  baseColor,
                ],
        ),
      ),
      child: child,
    );
  }
}

class SkeuoButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const SkeuoButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<SkeuoButton> createState() => _SkeuoButtonState();
}

class _SkeuoButtonState extends State<SkeuoButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SkeuoContainer(
        isPressed: _isPressed,
        borderRadius: widget.borderRadius,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
