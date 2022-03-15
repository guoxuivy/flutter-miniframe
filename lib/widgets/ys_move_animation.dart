import 'package:flutter/material.dart';
import 'dart:math';

class YsMoveAnimation extends StatefulWidget {
  final Duration? duration;
  final Offset startPosition;
  final Offset endPosition;
  final Widget child;
  final VoidCallback? onCompleted;
  final Offset startOffset;
  YsMoveAnimation({Key? key,
    this.duration,
    required this.startPosition,
    required this.endPosition,
    required this.child,
    this.onCompleted,
    required this.startOffset
  }):super(key:key);
  @override
  State<YsMoveAnimation> createState()  => MoveAnimationState();
}

class MoveAnimationState extends State<YsMoveAnimation> with TickerProviderStateMixin{
  late AnimationController _controller;
  double left=0;
  double top=0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    Animation _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    double x0 = widget.startPosition.dx;
    double y0 = widget.startPosition.dy;
    if (widget.startOffset != null) {
      x0 += widget.startOffset.dx;
      y0 += widget.startOffset.dy;
    }
    left = x0;
    top = y0;
    List<double> _passBy = getPassPoint();
    double x1 = _passBy[0];
    double y1 = _passBy[1];
    double x2 = widget.endPosition.dx;
    double y2 = widget.endPosition.dy;
    _animation.addListener(() {
      var t = _animation.value;
      if (mounted) {
        setState(() {
          left = pow(1 - t, 2) * x0 + 2 * t * (1 - t) * x1 + pow(t, 2) * x2;
          top = pow(1 - t, 2) * y0 + 2 * t * (1 - t) * y1 + pow(t, 2) * y2;
        });
      }
    });
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onCompleted != null && widget.onCompleted is Function) {
        Future.delayed(Duration.zero, widget.onCompleted);
      }
    });
    _controller.forward();
  }
  getPassPoint() {
    return [
      widget.startPosition.dx - 100,
      widget.startPosition.dy - 50
    ];
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
