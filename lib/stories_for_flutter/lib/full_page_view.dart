import 'dart:async';

import 'package:flutter/material.dart';
import 'stories_for_flutter.dart';

class FullPageView extends StatefulWidget {
  final List<StoryItem>? storiesMapList;
  final int? storyNumber;
  final TextStyle? fullPagetitleStyle;

  /// Choose whether progress has to be shown
  final bool? displayProgress;

  /// Color for visited region in progress indicator
  final Color? fullpageVisitedColor;

  /// Color for non visited region in progress indicator
  final Color? fullpageUnvisitedColor;

  /// Whether image has to be show on top left of the page
  final bool? showThumbnailOnFullPage;

  /// Size of the top left image
  final double? fullpageThumbnailSize;

  /// Whether image has to be show on top left of the page
  final bool? showStoryNameOnFullPage;

  /// Status bar color in full view of story
  final Color? storyStatusBarColor;

  /// Function to run when page changes
  final Function? onPageChanged;

  /// Duration after which next story is displayed
  /// Default value is infinite.
  final Duration? autoPlayDuration;

  const FullPageView({
    Key? key,
    required this.storiesMapList,
    required this.storyNumber,
    this.fullPagetitleStyle,
    this.displayProgress,
    this.fullpageVisitedColor,
    this.fullpageUnvisitedColor,
    this.showThumbnailOnFullPage,
    this.fullpageThumbnailSize,
    this.showStoryNameOnFullPage,
    this.storyStatusBarColor,
    this.onPageChanged,
    this.autoPlayDuration,
  }) : super(key: key);
  @override
  FullPageViewState createState() => FullPageViewState();
}

class FullPageViewState extends State<FullPageView> {
  List<StoryItem>? storiesMapList;
  int? storyNumber;
  late List<Widget> combinedList;
  late List listLengths;
  int? selectedIndex;
  PageController? _pageController;
  late bool displayProgress;
  Color? fullpageVisitedColor;
  Color? fullpageUnvisitedColor;
  bool? showThumbnailOnFullPage;
  double? fullpageThumbnailSize;
  late bool showStoryNameOnFullPage;
  Color? storyStatusBarColor;
  Timer? changePageTimer;

  nextPage(index) {
    if (index == combinedList.length - 1) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      selectedIndex = index + 1;
    });

    _pageController!.animateToPage(selectedIndex!,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  prevPage(index) {
    if (index == 0) return;
    setState(() {
      selectedIndex = index - 1;
    });
    _pageController!.animateToPage(selectedIndex!,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  initPageChangeTimer() {
    if (widget.autoPlayDuration != null) {
      changePageTimer = Timer.periodic(widget.autoPlayDuration!, (timer) {
        nextPage(selectedIndex);
      });
    }
  }

  @override
  void initState() {
    storiesMapList = widget.storiesMapList;
    storyNumber = widget.storyNumber;

    combinedList = getStoryList(storiesMapList!);
    listLengths = getStoryLengths(storiesMapList!);
    selectedIndex = getInitialIndex(storyNumber!, storiesMapList);

    displayProgress = widget.displayProgress ?? true;
    fullpageVisitedColor = widget.fullpageVisitedColor;
    fullpageUnvisitedColor = widget.fullpageUnvisitedColor;
    showThumbnailOnFullPage = widget.showThumbnailOnFullPage;
    fullpageThumbnailSize = widget.fullpageThumbnailSize;
    showStoryNameOnFullPage = widget.showStoryNameOnFullPage ?? true;
    storyStatusBarColor = widget.storyStatusBarColor;

    initPageChangeTimer();

    super.initState();
  }

  @override
  void dispose() {
    if (changePageTimer != null) changePageTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: selectedIndex!);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            onPageChanged: (page) {
              setState(() {
                selectedIndex = page;
              });
              // Running on pageChanged
              if (widget.onPageChanged != null) widget.onPageChanged!();
            },
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              combinedList.length,
              (index) => Stack(
                children: <Widget>[
                  Scaffold(
                    body: combinedList[index],
                  ),
                  // Overlay to detect taps for next page & previous page
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        color:Colors.transparent,
                        height:MediaQuery.of(context).size.height * 0.8,
                        child: InkWell(
                          onTap: () {
                            prevPage(index);
                          },
                          child: const Center(),
                        ),
                      ),
                      Container(
                        color:Colors.transparent,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      Container(
                        color:Colors.transparent,
                        height:MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width / 3,
                        child: InkWell(
                          onTap: () {
                            nextPage(index);
                          },
                          child: const Center(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // The progress of story indicator
          Column(
            children: <Widget>[
              Container(
                color: storyStatusBarColor ?? Colors.black,
                child: Center(),
                // const SafeArea(
                //   child:
                // ),
              ),
              const SizedBox(height: 60),
              displayProgress
                  ? Row(
                      children: List.generate(
                            numOfCompleted(
                                listLengths as List<int>, selectedIndex!),
                            (index) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                height: 2.5,
                                decoration: BoxDecoration(
                                    color: fullpageVisitedColor ??
                                        const Color(0xff444444),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black,
                                      )
                                    ]),
                              ),
                            ),
                          ) +
                          List.generate(
                            getCurrentLength(
                                    listLengths as List<int>, selectedIndex!) -
                                numOfCompleted(listLengths as List<int>,
                                    selectedIndex!) as int,
                            (index) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: widget.fullpageUnvisitedColor ??
                                      Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(blurRadius: 2)],
                                ),
                              ),
                            ),
                          ),
                    )
                  : const Center(),
              const SizedBox(height: 5),
              // Story name
              Row(
                children: [
                  Container(
                    // width: fullpageThumbnailSize ?? 40,
                    // height: fullpageThumbnailSize ?? 40,
                    // decoration: const BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: (showThumbnailOnFullPage == null ||
                            showThumbnailOnFullPage!)
                        ?
                      CircleAvatar(
                        radius: 20,
                          child: ClipOval(
                            child: Image(
                                  fit: BoxFit.cover,
                                  width: fullpageThumbnailSize ?? 40,
                                  height: fullpageThumbnailSize ?? 40,
                                  image: storiesMapList![getStoryIndex(
                                          listLengths as List<int>, selectedIndex!)]
                                      .user_thumbnail,
                                ),
                        ),
                      )
                    // Image(
                    //         width: fullpageThumbnailSize ?? 40,
                    //         height: fullpageThumbnailSize ?? 40,
                    //         image: storiesMapList![getStoryIndex(
                    //                 listLengths as List<int>, selectedIndex!)]
                    //             .thumbnail,
                    //       )
                        : const Center(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          showStoryNameOnFullPage
                              ? storiesMapList![getStoryIndex(
                                      listLengths as List<int>, selectedIndex!)]
                                  .name
                              : "",
                          style: widget.fullPagetitleStyle ??
                              const TextStyle(
                                color: Colors.white,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black)
                                ],
                                fontSize: 15,
                              ),
                        ),
                        Text(storiesMapList![getStoryIndex(
                            listLengths as List<int>, selectedIndex!)]
                            .timepass,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 14.0)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                      },
                    child:const Padding(
                      padding: EdgeInsets.only(right:15),
                      child: Icon(Icons.close,color:Colors.white),
                    ),
                  ),


                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<Widget> getStoryList(List<StoryItem> storiesMapList) {
  List<Widget> imagesList = [];
  for (int i = 0; i < storiesMapList.length; i++) {
    for (int j = 0; j < storiesMapList[i].stories.length; j++) {
      imagesList.add(storiesMapList[i].stories[j]);
    }
  }
  return imagesList;
}

List<int> getStoryLengths(List<StoryItem> storiesMapList) {
  List<int> intList = [];
  int count = 0;
  for (int i = 0; i < storiesMapList.length; i++) {
    count = count + storiesMapList[i].stories.length;
    intList.add(count);
  }
  return intList;
}

int getCurrentLength(List<int> listLengths, int index) {
  index = index + 1;
  int val = listLengths[0];
  for (int i = 0; i < listLengths.length; i++) {
    val = i == 0 ? listLengths[0] : listLengths[i] - listLengths[i - 1];
    if (listLengths[i] >= index) break;
  }
  return val;
}

numOfCompleted(List<int> listLengths, int index) {
  index = index + 1;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    val = listLengths[i];
  }
  return (index - val);
}

getInitialIndex(int storyNumber, List<StoryItem>? storiesMapList) {
  int total = 0;
  for (int i = 0; i < storyNumber; i++) {
    total += storiesMapList![i].stories.length;
  }
  return total;
}

int getStoryIndex(List<int> listLengths, int index) {
  index = index + 1;
  int temp = 0;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    if (temp != listLengths[i]) val += 1;
    temp = listLengths[i];
  }
  return val;
}
