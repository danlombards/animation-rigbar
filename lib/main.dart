import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(RightBarApp());
}

class RightBarApp extends StatefulWidget {
  @override
  _RightBarAppState createState() => _RightBarAppState();
}

class _RightBarAppState extends State<RightBarApp>
    with SingleTickerProviderStateMixin {
  Color backgroundColor = Colors.white;
  Color? selectedColor;
  double opacity = 0.5;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.indigo,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
  ];
  Color textColor = Colors.black;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _rotationAnimation2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _rotationAnimation2 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Center(
                      child: DefaultTextStyle(
                        style: GoogleFonts.pacifico(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: _opacityAnimation.value,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText('Hello',
                                  speed: Duration(milliseconds: 200)),
                              TypewriterAnimatedText('World',
                                  speed: Duration(milliseconds: 200)),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 50,
                  height: 720,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50,
                            child: FadeInAnimation(
                              child: Column(
                                children: [
                                  buildColorBox(colors[index], index),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildColorBox(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedColor == color) {
            selectedColor = null;
            opacity = 0.5;
            backgroundColor = Colors.white;
            textColor = Colors.black;
          } else {
            selectedColor = color;
            opacity = 1.0;
            backgroundColor = color;
            textColor =
                color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
            playAnimation();
            playNewAnimation();
          }
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            opacity = 0.5;
          });
        });
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: selectedColor == color ? 1.0 : opacity,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.1415,
              child: AnimatedBuilder(
                animation: _rotationAnimation2,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _rotationAnimation2.value * 2 * 3.1415,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: selectedColor == color
                            ? color.withOpacity(0.8)
                            : color,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: selectedColor == color
                                ? color.withOpacity(0.8)
                                : color,
                            blurRadius: selectedColor == color ? 8.0 : 0.0,
                            spreadRadius: selectedColor == color ? 1.0 : 0.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void playAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void playNewAnimation() {
    _animationController.reset();
    _animationController.forward();
  }
}
