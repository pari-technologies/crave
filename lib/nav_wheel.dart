import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
// import 'package:flutter_haptic/haptic.dart';

import 'homeBase.dart';

@immutable
class NavigationSelector extends StatefulWidget {
  const NavigationSelector({
    key,
    required this.filters,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
  });

  final List<String> filters;
  final void Function(int index) onFilterChanged;
  final EdgeInsets padding;

  @override
  _NavigationSelectorState createState() => _NavigationSelectorState();
}

class _NavigationSelectorState extends State<NavigationSelector> {
  static const _filtersPerScreen = 8;
  static const _viewportFractionPerItem = 0.65 / _filtersPerScreen;

  late final PageController _controller;
  late int _page;

  int get filterCount => widget.filters.length;

  String itemImg(int index) => widget.filters[index % filterCount];
  List<Color> itemColor = [
    Colors.white38,
    Colors.white38,
    Colors.white38,
    Colors.white38,
    Colors.white38,
    Colors.white38,
    Colors.white38,
    Colors.white38,
  ];

  List<double> imgSize = [
    50,
    50,
    50,
    50,
    50,
    50,
    40,
    50,
  ];

  @override
  void initState() {
    super.initState();
    _page = 2;
    itemColor[2] = Colors.white;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);

  }


  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
        setState(() {
          itemColor[page] = Colors.white;
          HapticFeedback.selectionClick();
          // var _type = FeedbackType.medium;
          // Vibrate.feedback(_type);
          // Haptic.onSelection();
          SystemSound.play(SystemSoundType.click);
        });

      }
    else{
      setState(() {
        for (int i = 0; i < itemColor.length; i++)
          if(i!=page)
            itemColor[i] = Colors.white38;
      });


      widget.onFilterChanged(page);
    }

  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
    PageViewDemo.of(context)!.onWheelClicked(index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            final itemSize = 90.00;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // _buildShadowGradient(itemSize),
                _buildCarousel(
                  viewportOffset: viewportOffset,
                  itemSize: itemSize,
                ),
                // _buildSelectionRing(itemSize),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildCarousel({
    required ViewportOffset viewportOffset,
    required double itemSize,
  }) {
    return Stack(
      children:[
        Container(
          padding:EdgeInsets.only(left:10,right:10),
          margin:EdgeInsets.only(left:50,right:150),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/round_bg_2.png",),
              fit: BoxFit.fill,
              // colorFilter: ColorFilter.mode(Color(0xFF2CBFC6).withOpacity(1), BlendMode.modulate,)
            ),
          ),
        height: itemSize+ 70,
        child: Flow(
          delegate: CarouselFlowDelegate(
            viewportOffset: viewportOffset,
            filtersPerScreen: _filtersPerScreen,
          ),
          children: [
            for (int i = 0; i < filterCount; i++)
              Container(
                margin:EdgeInsets.only(bottom:80),
                child: NavItem(
                  onFilterSelected: () => _onFilterTapped(i),
                  imgName: itemImg(i),
                  imgColor: itemColor[i],
                  imgSize: imgSize[i],
                ),
              ),

          ],
        ),
      ),
      ]
    );


  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // All available painting width
    final size = context.size.width;

    // The distance that a single item "page" takes up from the perspective
    // of the scroll paging system. We also use this size for the width and
    // height of a single item.
    final itemExtent = size / filtersPerScreen;

    // The current scroll position expressed as an item fraction, e.g., 0.0,
    // or 1.0, or 1.3, or 2.9, etc. A value of 1.3 indicates that item at
    // index 1 is active, and the user has scrolled 30% towards the item at
    // index 2.
    final active = viewportOffset.pixels / itemExtent;

    // Index of the first item we need to paint at this moment.
    // At most, we paint 3 items to the left of the active item.
    final min = math.max(0, active.floor() - 3).toInt();

    // Index of the last item we need to paint at this moment.
    // At most, we paint 3 items to the right of the active item.
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Generate transforms for the visible items and sort by distance.
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 2.0 - (itemXFromCenter / (size / 4)).abs();
      // final itemScale = 0.5 + (percentFromCenter * 0.5);
      // final opacity = 0.25 + (percentFromCenter * 0.75);
      final padding = itemExtent / (0.35 + (percentFromCenter * 0.5));
      final itemScale = 0.5 + (0.5);
      final opacity = 0.25 + ( 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, padding)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 3, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class NavItem extends StatelessWidget {
  const NavItem({
    key,
    required this.imgName,
    required this.imgColor,
    required this.imgSize,
    this.onFilterSelected,
  });

  final String imgName ;
  final double imgSize;
  final Color imgColor;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: Container(
        height:100,
        padding: const EdgeInsets.all(8.0),
        child:RotatedBox(
          quarterTurns: 1,
          child:Container(
            child: Image(
              image: AssetImage(imgName),
              height:imgSize,
              color:imgColor,),
          ),

        ),

      ),
    );
  }
}
