import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

import 'guidPlannig.dart';

final pages = [
  const PageData(
    icon: Icons.food_bank_outlined,
    title: "Search for your favourite food",
    bgColor: Color(0xff3b1791),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.shopping_bag_outlined,
    title: "Add it to cart",
    bgColor: Color(0xfffab800),
    textColor: Color(0xff3b1790),
  ),
  const PageData(
    icon: Icons.delivery_dining,
    title: "Order and wait",
    bgColor: Color.fromARGB(255, 223, 3, 69),
    textColor: Color(0xff3b1790),
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 1,
        nextButtonBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 3), // visual center
            child: Icon(
              Icons.navigate_next,
              size: screenWidth * 0.08,
            ),
          );
        },
        itemBuilder: (index) {
          final page = pages[index % pages.length];

          if (index == pages.length ) {
            // Navigate to the home page after the last onboarding page
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaningSecreen(), // Replace with your home page
                ),
              );
            });
          }

          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final AnimatedTextKit? animatedTitle;

  const PageData(
      {this.title,
      this.icon,
      this.bgColor = Colors.white,
      this.textColor = Colors.black,
      this.animatedTitle});
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: page.textColor),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              page.title ?? "",
              textStyle: TextStyle(fontSize: 30, letterSpacing: 30),
              speed: Duration(milliseconds: 100),
              curve: Curves.fastOutSlowIn,
              cursor: "...",
            ),
          ],
          totalRepeatCount: 5,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
        ),
      ],
    );
  }
}
