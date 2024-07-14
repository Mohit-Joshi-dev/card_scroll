import 'dart:math';

import 'package:card_scroll/data/data.dart';
import 'package:card_scroll/data/mountain.dart';
import 'package:card_scroll/utils/colors.dart';
import 'package:card_scroll/utils/helper.dart';
import 'package:card_scroll/utils/sizing.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Mountain> data =
      allMountains.map((item) => Mountain.fromJson(item)).toList();
  List<Mountain> mountains = [];
  final duration = const Duration(milliseconds: 500);
  late PageController pageController;
  int activeIndex = 1;
  int previousIndex = 0;

  @override
  void initState() {
    mountains = data.reversed.toList();
    activeIndex = mountains.length - 2;
    previousIndex = mountains.length - 2;
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9,
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
      body: Container(
        color: Helper.hexToColor(mountains[activeIndex].bg),
        height: AppSizing.height(context),
        width: AppSizing.width(context),
        alignment: Alignment.center,
        child: Stack(
          children: [
            mountainNamesAndCoordinates(context),
            Positioned(
              child: SizedBox(
                height: AppSizing.height(context),
                width: AppSizing.width(context),
                child: Transform.rotate(
                  angle: pi * 1.2,
                  child: Builder(builder: (context) {
                    return PageView.builder(
                        itemCount: mountains.length,
                        clipBehavior: Clip.none,
                        controller: pageController,
                        onPageChanged: (page) {
                          print(["page", page]);
                          if (page == mountains.length - 1 || page == 1) {
                            setState(() {
                              mountains = [...mountains, ...mountains];
                            });
                          }
                          setState(() {
                            previousIndex = activeIndex;
                            activeIndex = page;
                          });
                        },
                        itemBuilder: (c, i) {
                          final mountain = mountains[i];
                          return Center(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateZ(pi * -1.2),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      pageController.nextPage(
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              AppSizing.width(context) * 0.15),
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            AppSizing.height(context) * 0.4,
                                      ),
                                      width: AppSizing.width(context),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(mountain.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned mountainNamesAndCoordinates(BuildContext context) {
    return Positioned(
      top: AppSizing.height(context) * 0.1,
      child: Container(
        alignment: Alignment.center,
        height: AppSizing.height(context) * 0.8,
        width: AppSizing.width(context),
        child: Builder(builder: (context) {
          List<String> items = mountains[activeIndex].name.split("\n");
          List<String> coordinates =
              mountains[activeIndex].coordinates.split(",");
          String north = coordinates.isNotEmpty ? coordinates[0] : "----";
          String east = coordinates.isNotEmpty ? coordinates[0] : "----";
          String formattedCoord =
              "${north.substring(0, 5)}N - ${east.substring(0, 5)}E";

          return TweenAnimationBuilder(
              duration: duration,
              tween: Tween<double>(begin: 1, end: 0),
              key: ValueKey(activeIndex),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                final isLeft = previousIndex < activeIndex;
                final leftOffset = isLeft
                    ? value * AppSizing.width(context) * 0.5
                    : value * AppSizing.width(context) * -0.5;
                final rightOffset = isLeft
                    ? value * AppSizing.width(context) * -0.5
                    : value * AppSizing.width(context) * 0.5;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: Offset(leftOffset, 0),
                      child: Text(
                        items.isNotEmpty ? items[0] : "----",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                              color:
                                  Helper.hexToColor(mountains[activeIndex].fg),
                            ),
                      ),
                    ),
                    Column(
                      children: [
                        Transform.translate(
                          offset: Offset(rightOffset, 0),
                          child: Text(
                            items.length > 1 ? items[1] : "----",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: Helper.hexToColor(
                                      mountains[activeIndex].fg),
                                ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(leftOffset, 0),
                          child: Column(
                            children: [
                              Text(
                                mountains[activeIndex].location,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: AppColors.white),
                              ),
                              Text(
                                formattedCoord,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              });
        }),
      ),
    );
  }
}
