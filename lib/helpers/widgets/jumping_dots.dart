import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final Color? color;
  final double? radius;

  const DotWidget({
    super.key,
    @required this.color,
    @required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      height: radius,
      width: radius,
    );
  }
}

class JumpingDots extends StatefulWidget {
  final int numberOfDots;
  final Color color;
  final double radius;
  final double innerPadding;
  final Duration animationDuration;
  final double verticalOffset;
  final int delay;

  JumpingDots({
    super.key,
    this.numberOfDots = 3,
    this.radius = 10,
    this.innerPadding = 2.5,
    this.animationDuration = const Duration(milliseconds: 200),
    this.color = const Color(0xfff2c300),
    this.verticalOffset = -20,
    this.delay = 0,
  })  : assert(
          verticalOffset.isFinite,
          'Non-finite values cannot be set as an animation offset.',
        ),
        assert(
          verticalOffset != 0,
          'Zero values (0) cannot be set as an animation offset.',
        );

  @override
  State<JumpingDots> createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots>
    with TickerProviderStateMixin {
  List<AnimationController>? _animationControllers;

  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers!) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initAnimation() {
    _animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(
          vsync: this,
          duration: widget.animationDuration,
        );
      },
    ).toList();

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(
        Tween<double>(
          begin: 0,
          end: -widget.verticalOffset.abs(), // Ensure the offset is negative.
        ).animate(_animationControllers![i]),
      );
    }

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers![i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationControllers![i].reverse();

          if (i != widget.numberOfDots - 1) {
            _animationControllers![i + 1].forward();
          }
        }
        if (i == widget.numberOfDots - 1 &&
            status == AnimationStatus.dismissed) {
          if (widget.delay == 0) {
            _animationControllers![0].forward();
          } else {
            Future.delayed(Duration(milliseconds: widget.delay), () {
              if (mounted) {
                _animationControllers![0].forward();
              }
            });
          }
        }
      });
    }
    _animationControllers!.first.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(widget.numberOfDots, (index) {
            return AnimatedBuilder(
              animation: _animationControllers![index],
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.all(widget.innerPadding),
                  child: Transform.translate(
                    offset: Offset(0, _animations[index].value),
                    child:
                        DotWidget(color: widget.color, radius: widget.radius),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
