import 'package:card_scroll/data/data.dart';
import 'package:card_scroll/data/mountain.dart';
import 'package:card_scroll/utils/sizing.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Mountain> data =
      allMountains.map((item) => Mountain.fromJson(item)).toList();
  List<Mountain> mountains = [];
  late PageController pageController;

  @override
  void initState() {
    mountains = data.reversed.toList();
    pageController = PageController(
      initialPage: mountains.length - 2,
      viewportFraction: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return PageView.builder(
            itemCount: mountains.length,
            clipBehavior: Clip.none,
            controller: pageController,
            onPageChanged: (page) {},
            itemBuilder: (c, i) {
              final mountain = mountains[i];
              return Container(
                padding: const EdgeInsets.all(10),
                width: AppSizing.width(context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(mountain.image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            });
      }),
    );
  }
}
