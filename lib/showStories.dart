import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = [
      // StoryItem.text(
      //   title:
      //   "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
      //   backgroundColor: Colors.orange,
      //   roundedTop: true,
      // ),

      StoryItem.inlineImage(
        url:
        "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
        controller: controller,
        // caption: Text(
        //   "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
        //   style: TextStyle(
        //     color: Colors.white,
        //     backgroundColor: Colors.black54,
        //     fontSize: 17,
        //   ),
        // ),
      ),
      StoryItem.inlineImage(
        url:
        "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
        controller: controller,
        // caption: Text(
        //   "Hektas, sektas and skatad",
        //   style: TextStyle(
        //     color: Colors.white,
        //     backgroundColor: Colors.black54,
        //     fontSize: 17,
        //   ),
        // ),
      )
    ];
    return Material(
      child: StoryView(
        storyItems: storyItems,
        controller: controller,
        repeat: false,
        inline: true,
      ),
    );
  }
}