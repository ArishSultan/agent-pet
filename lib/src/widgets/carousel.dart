import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef CarouselIndicatorBuilder = Widget Function(BuildContext, int, int);

abstract class Carousel extends StatelessWidget {
  static Widget defaultIndicatorBuilder(
      BuildContext context, int len, int selected) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 15),
      child: Row(
        children: List.generate(
          len,
          (index) => Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            ),
          ),
        ),
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  static const _defaultTransitionCurve = Curves.ease;
  static const _defaultShiftDuration = Duration(seconds: 2);
  static const _defaultTransitionDuration = Duration(milliseconds: 500);

  Carousel._();

  factory Carousel({
    PageController controller,
    CarouselIndicatorBuilder indicatorBuilder,
    @required List<Widget> children,
  }) = _Carousel;

  factory Carousel.builder({
    PageController controller,
    CarouselIndicatorBuilder indicatorBuilder,
    @required int itemCount,
    @required IndexedWidgetBuilder itemBuilder,
  }) = _BuilderCarousel;

  factory Carousel.live({
    Duration shiftDuration,
    Curve transitionCurve,
    Duration transitionDuration,
    CarouselIndicatorBuilder indicatorBuilder,
    @required List<Widget> children,
  }) = _AutoShiftableCarousel;

  factory Carousel.liveBuilder({
    Duration shiftDuration,
    Curve transitionCurve,
    Duration transitionDuration,
    CarouselIndicatorBuilder indicatorBuilder,
    @required int itemCount,
    @required IndexedWidgetBuilder itemBuilder,
  }) = _AutoShiftableBuilderCarousel;

  static Widget _build({
    int length,
    PageView view,
    BuildContext context,
    ValueListenable current,
    CarouselIndicatorBuilder builder,
  }) {
    if (builder != null) {
      return Column(
        children: [
          Expanded(child: view),
          ValueListenableBuilder(
              valueListenable: current,
              builder: (context, value, _) {
                return builder(context, length, value);
              })
        ],
      );
    } else {
      return view;
    }
  }
}

class _Carousel extends Carousel {
  _Carousel({
    this.children,
    this.controller,
    this.indicatorBuilder,
  }) : super._() {
    if (controller != null) {
      _currentPage.value = controller.initialPage;
    }
  }

  final List<Widget> children;
  final PageController controller;
  final CarouselIndicatorBuilder indicatorBuilder;

  final _currentPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Carousel._build(
      context: context,
      current: _currentPage,
      length: children.length,
      builder: indicatorBuilder,
      view: PageView(
        children: children,
        controller: controller,
        onPageChanged: (page) => _currentPage.value = page,
      ),
    );
  }
}

class _BuilderCarousel extends Carousel {
  final int itemCount;
  final PageController controller;
  final IndexedWidgetBuilder itemBuilder;
  final CarouselIndicatorBuilder indicatorBuilder;

  final _currentPage = ValueNotifier(0);

  _BuilderCarousel({
    this.itemCount,
    this.controller,
    this.itemBuilder,
    this.indicatorBuilder,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return Carousel._build(
      context: context,
      length: itemCount,
      current: _currentPage,
      builder: indicatorBuilder,
      view: PageView.builder(
        itemCount: itemCount,
        controller: controller,
        itemBuilder: itemBuilder,
        onPageChanged: (page) => _currentPage.value = page,
      ),
    );
  }
}

class _AutoShiftableCarousel extends Carousel {
  final bool allowScroll;
  final List<Widget> children;
  final Curve transitionCurve;
  final Duration shiftDuration;
  final Duration transitionDuration;
  final CarouselIndicatorBuilder indicatorBuilder;

  final _currentPage = ValueNotifier(0);

  _AutoShiftableCarousel({
    this.indicatorBuilder,
    this.allowScroll = true,
    this.children = const [],
    this.shiftDuration = Carousel._defaultShiftDuration,
    this.transitionCurve = Carousel._defaultTransitionCurve,
    this.transitionDuration = Carousel._defaultTransitionDuration,
  }) : super._() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = RestartableTimer(shiftDuration, () {
        if (_controller.hasClients) {
          _timer.cancel();

          var nextPage = _currentPage.value + 1;
          _controller.animateToPage(nextPage == children.length ? 0 : nextPage,
              duration: transitionDuration, curve: transitionCurve);
        }
      });
    });
  }

  RestartableTimer _timer;
  final _controller = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Carousel._build(
        context: context,
        length: children.length,
        builder: indicatorBuilder,
        current: _currentPage,
        view: PageView(
          physics: allowScroll ? null : NeverScrollableScrollPhysics(),
          children: children,
          controller: _controller,
          onPageChanged: (page) {
            _currentPage.value = page;
            _timer.reset();
          },
        ));
  }
}

class _AutoShiftableBuilderCarousel extends Carousel {
  final int itemCount;
  final bool allowScroll;
  final Duration shiftDuration;
  final Curve transitionCurve;
  final Duration transitionDuration;
  final IndexedWidgetBuilder itemBuilder;
  final CarouselIndicatorBuilder indicatorBuilder;

  final _currentPage = ValueNotifier(0);

  _AutoShiftableBuilderCarousel({
    this.itemCount,
    this.itemBuilder,
    this.indicatorBuilder,
    this.allowScroll = true,
    this.shiftDuration = Carousel._defaultShiftDuration,
    this.transitionCurve = Carousel._defaultTransitionCurve,
    this.transitionDuration = Carousel._defaultTransitionDuration,
  }) : super._() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = RestartableTimer(shiftDuration, () {
        if (_controller.hasClients) {
          _timer.cancel();

          var nextPage = _currentPage.value + 1;
          _controller.animateToPage(nextPage == itemCount ? 0 : nextPage,
              duration: transitionDuration, curve: transitionCurve);
        }
      });
    });
  }

  RestartableTimer _timer;
  final _controller = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Carousel._build(
      context: context,
      length: itemCount,
      builder: indicatorBuilder,
      current: _currentPage,
      view: PageView.builder(
        itemCount: itemCount,
        controller: _controller,
        itemBuilder: itemBuilder,
        onPageChanged: (page) {
          _currentPage.value = page;
          _timer?.reset();
        },
      ),
    );
  }
}
