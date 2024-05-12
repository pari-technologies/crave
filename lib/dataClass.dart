import 'dart:convert';

import 'package:flutter/material.dart';

class Media {
  late final String media_id;
  late final String media_name;
  late final String media_user_id;
  late final String media_type;
  late final String media_desc;
  late final String media_filter;
  late final String media_audio;
  late final String media_latlng;
  late final String media_location;
  late final String post_likes;
  late final String post_likes_user;
  late final String post_craving;
  late final String post_craving_user;
  late final String post_comments;
  late final String user_display_name;
  late final String user_profile_img;
  late String is_follow;
  late final String tags1;
  late final String tags2;
  late final String tags3;
  late final String c_textfilter;
  late final String c_textstyle;
  late final String c_textColor;
  late final String c_textBgColor;
  late final String c_textFamily;
  late final String c_textSize;
  late final String c_textalign;

  Media({
    required this.media_id,
    required this.media_name,
    required this.media_user_id,
    required this.media_type,
    required this.media_desc,
    required this.media_filter,
    required this.media_audio,
    required this.media_latlng,
    required this.media_location,
    required this.post_likes,
    required this.post_likes_user,
    required this.post_craving,
    required this.post_craving_user,
    required this.post_comments,
    required this.user_display_name,
    required this.user_profile_img,
    required this.is_follow,
    required this.tags1,
    required this.tags2,
    required this.tags3,
    required this.c_textfilter,
    required this.c_textstyle,
    required this.c_textColor,
    required this.c_textBgColor,
    required this.c_textFamily,
    required this.c_textSize,
    required this.c_textalign
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      media_id: json['c_media_id'] as String,
      media_name: json['c_media_name'] as String,
      media_user_id: json['c_media_user_id'] as String,
      media_type: json['c_media_type'] as String,
      media_desc: json['c_media_desc'] as String,
      media_filter: json['c_media_filter'] as String,
      media_audio: json['c_media_audio'] as String,
      media_latlng: json['c_media_latlng'] as String,
      media_location: json['c_media_location'] as String,
      post_likes: json['post_likes'] as String,
      post_likes_user: json['post_likes_user'] as String,
      post_craving: json['post_craving'] as String,
      post_craving_user: json['post_craving_user'] as String,
      post_comments: json['post_comments'] as String,
      user_display_name: json['c_display_name'] as String,
      user_profile_img: json['c_profile_img'] as String,
      is_follow: json['c_is_follow'] as String,
      tags1: json['c_tags1'] as String,
      tags2: json['c_tags2'] as String,
      tags3: json['c_tags3'] as String,
      c_textfilter: json['c_textfilter'] as String,
      c_textstyle: json['c_textstyle'] as String,
      c_textColor: json['c_textColor'] as String,
      c_textBgColor: json['c_textBgColor'] as String,
      c_textFamily: json['c_textFamily'] as String,
      c_textSize: json['c_textSize'] as String,
      c_textalign: json['c_textalign'] as String,
    );
  }
}

// class Comment {
//   late final String comment_id;
//   late final String media_id;
//   late final String comment_reply_to_id;
//   late final String comment_text;
//   late final String user_id;
//   late final String user_display_name;
//   late final String comment_likes;
//   late final String comment_likes_user;
//
//   Comment({
//     required this.comment_id,
//     required this.media_id,
//     required this.comment_reply_to_id,
//     required this.comment_text,
//     required this.user_id,
//     required this.user_display_name,
//     required this.comment_likes,
//     required this.comment_likes_user
//   });
//
//   factory Comment.fromJson(Map<String, dynamic> json) {
//     return Comment(
//       comment_id: json['c_mcomment_id'] as String,
//       media_id: json['c_media_id'] as String,
//       comment_reply_to_id: json['c_reply_to_id'] as String,
//       comment_text: json['c_comment'] as String,
//       user_id: json['c_email'] as String,
//       user_display_name: json['c_display_name'] as String,
//       comment_likes: json['comment_likes'] as String,
//       comment_likes_user: json['comment_likes_user'] as String,
//     );
//   }
// }

class UserProfile {
  late final String username;
  late final String display_name;
  late final String email;
  late final String profile_img;
  late final String user_followers;
  late final String user_following;

  UserProfile({
    required this.username,
    required this.display_name,
    required this.email,
    required this.profile_img,
    required this.user_followers,
    required this.user_following
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['c_username'] as String,
      display_name: json['c_display_name'] as String,
      email: json['c_email'] as String,
      profile_img: json['c_profile_img'] as String,
      user_followers: json['user_followers'] as String,
      user_following: json['user_following'] as String,
    );
  }
}

class CraveList {
  late final String list_id;
  late final String list_name;
  late final String list_img;
  late final String crave_amount;

  CraveList({
    required this.list_id,
    required this.list_name,
    required this.list_img,
    required this.crave_amount
  });

  factory CraveList.fromJson(Map<String, dynamic> json) {
    return CraveList(
      list_id: json['c_list_id'] as String,
      list_name: json['c_list_name'] as String,
      list_img: json['content_img'] as String,
      crave_amount: json['crave_amount'] as String,
    );
  }
}

class CraveContent {
  late final String content_id;
  late final String content_name;
  late final String content_desc;
  late final String content_location;
  late final String user_display_name;
  late final String post_craving;
  late final String content_latlng;

  CraveContent({
    required this.content_id,
    required this.content_name,
    required this.content_desc,
    required this.content_location,
    required this.user_display_name,
    required this.post_craving,
    required this.content_latlng
  });

  factory CraveContent.fromJson(Map<String, dynamic> json) {
    return CraveContent(
      content_id: json['c_content_id'] as String,
      content_name: json['c_media_name'] as String,
      content_desc: json['c_media_desc'] as String,
      content_location: json['c_media_location'] as String,
      user_display_name: json['c_display_name'] as String,
      post_craving: json['post_craving'] as String,
      content_latlng: json['c_media_latlng'] as String,
    );
  }
}

class Chatroom {
  late final String chatroom_id;
  late final String p1_name;
  late final String p1_profile_img;
  late final String p1_email;
  late final String p2_name;
  late final String p2_profile_img;
  late final String p2_email;
  late final String recent_chat;
  late final String chat_type;

  Chatroom({
    required this.chatroom_id,
    required this.p1_name,
    required this.p1_profile_img,
    required this.p1_email,
    required this.p2_name,
    required this.p2_profile_img,
    required this.p2_email,
    required this.recent_chat,
    required this.chat_type
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      chatroom_id: json['c_chatroom_id'] as String,
      p1_name: json['p1_name'] as String,
      p1_profile_img: json['p1_profile_img'] as String,
      p1_email: json['p1_email'] as String,
      p2_name: json['p2_name'] as String,
      p2_profile_img: json['p2_profile_img'] as String,
      p2_email: json['p2_email'] as String,
      recent_chat: json['c_chat_content'] as String,
      chat_type: json['c_chat_type'] as String,
    );
  }
}

class ChatContent {
  late final String chatroom_id;
  late final String p1_name;
  late final String p1_profile_img;
  late final String p1_email;
  late final String p2_name;
  late final String p2_profile_img;
  late final String p2_email;
  late final String sender_id;
  late final String chat_type;
  late final String chat_content;

  ChatContent({
    required this.chatroom_id,
    required this.p1_name,
    required this.p1_profile_img,
    required this.p1_email,
    required this.p2_name,
    required this.p2_profile_img,
    required this.p2_email,
    required this.sender_id,
    required this.chat_type,
    required this.chat_content,
  });

  factory ChatContent.fromJson(Map<String, dynamic> json) {
    return ChatContent(
      chatroom_id: json['c_chatroom_id'] as String,
      p1_name: json['p1_name'] as String,
      p1_profile_img: json['p1_profile_img'] as String,
      p1_email: json['p1_email'] as String,
      p2_name: json['p2_name'] as String,
      p2_profile_img: json['p2_profile_img'] as String,
      p2_email: json['p2_email'] as String,
      sender_id: json['c_sender_id'] as String,
      chat_type: json['c_chat_type'] as String,
      chat_content: json['c_chat_content'] as String,
    );
  }
}

class Followers {
  late final String f_email;
  late final String f_display_name;
  late final String f_username;
  late final String f_profile_img;
  late final String f_is_follow;

  Followers({
    required this.f_email,
    required this.f_display_name,
    required this.f_username,
    required this.f_profile_img,
    required this.f_is_follow
  });

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      f_email: json['c_email'] as String,
      f_display_name: json['c_display_name'] as String,
      f_username: json['c_username'] as String,
      f_profile_img: json['c_profile_img'] as String,
      f_is_follow: json['c_is_follow'] as String,
    );
  }
}

// To parse this JSON data, do
//
//     final story = storyFromJson(jsonString);

Story storyFromJson(String str) => Story.fromJson(json.decode(str));

String storyToJson(Story data) => json.encode(data.toJson());

class Story {
  Story({
    required this.result,
    required this.stories,
  });

  int result;
  List<StoryElement> stories;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    result: json["result"],
    stories: List<StoryElement>.from(json["stories"].map((x) => StoryElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
  };
}

class StoryElement {
  StoryElement({
    required this.cMediaUserId,
    required this.cDisplayName,
    required this.cProfileImg,
    required this.storyItems,
  });

  String cMediaUserId;
  String cDisplayName;
  String cProfileImg;
  List<StoryItems> storyItems;

  factory StoryElement.fromJson(Map<String, dynamic> json) => StoryElement(
    cMediaUserId: json["c_media_user_id"],
    cDisplayName: json["c_display_name"],
    cProfileImg: json["c_profile_img"],
    storyItems: List<StoryItems>.from(json["story_items"].map((x) => StoryItems.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "c_media_user_id": cMediaUserId,
    "c_display_name": cDisplayName,
    "c_profile_img": cProfileImg,
    "story_items": List<dynamic>.from(storyItems.map((x) => x.toJson())),
  };
}

class StoryItems {
  StoryItems({
    required this.cMediaId,
    required this.cMediaName,
    required this.cMediaUserId,
    required this.cMediaType,
    required this.cMediaDesc,
    required this.cMediaFilter,
    required this.cMediaAudio,
    required this.cMediaLatlng,
    required this.cMediaLocation,
    required this.cTextFilter,
    required this.cTextStyle,
    required this.cTextAlign,
    required this.cTextColor,
    required this.cTextBgColor,
    required this.cTextFamily,
    required this.cTextSize,
    required this.cMediaCreateDate,
  });

  String cMediaId;
  String cMediaName;
  String cMediaUserId;
  String cMediaType;
  String cMediaDesc;
  String cMediaFilter;
  String cMediaAudio;
  String cMediaLatlng;
  String cMediaLocation;
  String cTextFilter;
  String cTextStyle;
  String cTextAlign;
  String cTextColor;
  String cTextBgColor;
  String cTextFamily;
  String cTextSize;
  DateTime cMediaCreateDate;

  factory StoryItems.fromJson(Map<String, dynamic> json) => StoryItems(
    cMediaId: json["c_media_id"],
    cMediaName: json["c_media_name"],
    cMediaUserId: json["c_media_user_id"],
    cMediaType: json["c_media_type"],
    cMediaDesc: json["c_media_desc"],
    cMediaFilter: json["c_media_filter"],
    cMediaAudio: json["c_media_audio"],
    cMediaLatlng: json["c_media_latlng"],
    cMediaLocation: json["c_media_location"],
    cTextFilter: json["c_textfilter"],
    cTextStyle: json["c_textstyle"],
    cTextAlign: json["c_textalign"],
    cTextColor: json["c_textColor"],
    cTextBgColor: json["c_textBgColor"],
    cTextFamily: json["c_textFamily"],
    cTextSize: json["c_textSize"],
    cMediaCreateDate: DateTime.parse(json["c_media_create_date"]),
  );

  Map<String, dynamic> toJson() => {
    "c_media_id": cMediaId,
    "c_media_name": cMediaName,
    "c_media_user_id": cMediaUserId,
    "c_media_type": cMediaType,
    "c_media_desc": cMediaDesc,
    "c_media_filter": cMediaFilter,
    "c_media_audio": cMediaAudio,
    "c_media_latlng": cMediaLatlng,
    "c_media_location": cMediaLocation,
    "c_textfilter":cTextFilter,
    "c_textstyle":cTextStyle,
    "c_textalign":cTextAlign,
    "c_media_create_date": cMediaCreateDate.toIso8601String(),
  };
}


// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    required this.result,
    required this.comments,
  });

  int result;
  List<Comment> comments;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    result: json["result"],
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    required this.cMcommentId,
    required this.cMediaId,
    required this.cUserId,
    required this.cReplyToId,
    required this.cComment,
    required this.cCreateDate,
    required this.cUsername,
    required this.cDisplayName,
    required this.cEmail,
    required this.cProfileImg,
    required this.cPassword,
    required this.cPhoneCode,
    required this.cPhoneNumber,
    required this.cVerificationCode,
    required this.cVerCodeTime,
    required this.cVerifiedStatus,
    required this.replied,
    required this.commentLikes,
    required this.commentLikesUser,
  });

  String cMcommentId;
  String cMediaId;
  String cUserId;
  String cReplyToId;
  String cComment;
  DateTime cCreateDate;
  String cUsername;
  String cDisplayName;
  String cEmail;
  String cProfileImg;
  String cPassword;
  String cPhoneCode;
  String cPhoneNumber;
  String cVerificationCode;
  DateTime cVerCodeTime;
  String cVerifiedStatus;
  List<Comment> replied;
  String commentLikes;
  String commentLikesUser;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    cMcommentId: json["c_mcomment_id"],
    cMediaId: json["c_media_id"],
    cUserId: json["c_user_id"],
    cReplyToId: json["c_reply_to_id"],
    cComment: json["c_comment"],
    cCreateDate: DateTime.parse(json["c_create_date"]),
    cUsername: json["c_username"],
    cDisplayName: json["c_display_name"],
    cEmail: json["c_email"],
    cProfileImg: json["c_profile_img"],
    cPassword: json["c_password"],
    cPhoneCode: json["c_phone_code"],
    cPhoneNumber: json["c_phone_number"],
    cVerificationCode: json["c_verification_code"],
    cVerCodeTime: DateTime.parse(json["c_ver_code_time"]),
    cVerifiedStatus: json["c_verified_status"],
    replied: json["replied"] == null ? [] : List<Comment>.from(json["replied"].map((x) => Comment.fromJson(x))),
    commentLikes: json["comment_likes"],
    commentLikesUser: json["comment_likes_user"],
  );

  Map<String, dynamic> toJson() => {
    "c_mcomment_id": cMcommentId,
    "c_media_id": cMediaId,
    "c_user_id": cUserId,
    "c_reply_to_id": cReplyToId,
    "c_comment": cComment,
    "c_create_date": cCreateDate.toIso8601String(),
    "c_username": cUsername,
    "c_display_name": cDisplayName,
    "c_email": cEmail,
    "c_profile_img": cProfileImg,
    "c_password": cPassword,
    "c_phone_code": cPhoneCode,
    "c_phone_number": cPhoneNumber,
    "c_verification_code": cVerificationCode,
    "c_ver_code_time": cVerCodeTime.toIso8601String(),
    "c_verified_status": cVerifiedStatus,
    "replied": replied == null ? null : List<dynamic>.from(replied.map((x) => x.toJson())),
    "comment_likes": commentLikes,
    "comment_likes_user": commentLikesUser,
  };
}

class CommentReplied {
  late bool isReplied;
  late bool isOpenReplied;

  CommentReplied({
    required this.isReplied,
    required this.isOpenReplied,
  });

}


FollowingCrave followingCraveFromJson(String str) => FollowingCrave.fromJson(json.decode(str));

String followingCraveToJson(FollowingCrave data) => json.encode(data.toJson());

class FollowingCrave {
  FollowingCrave({
    required this.result,
    required this.followingCrave,
  });

  int result;
  List<FollowingCraveElement> followingCrave;

  factory FollowingCrave.fromJson(Map<String, dynamic> json) => FollowingCrave(
    result: json["result"],
    followingCrave: List<FollowingCraveElement>.from(json["following_crave"].map((x) => FollowingCraveElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "following_crave": List<dynamic>.from(followingCrave.map((x) => x.toJson())),
  };
}

class FollowingCraveElement {
  FollowingCraveElement({
    required this.cFollowId,
    required this.cUserId,
    required this.cUserFollowId,
    required this.cCreateDate,
    required this.cDisplayName,
    required this.cProfileImg,
    required this.followMedia,
  });

  String cFollowId;
  String cUserId;
  String cUserFollowId;
  String cDisplayName;
  String cProfileImg;
  DateTime cCreateDate;
  List<FollowMedia> followMedia;

  factory FollowingCraveElement.fromJson(Map<String, dynamic> json) => FollowingCraveElement(
    cFollowId: json["c_follow_id"],
    cUserId: json["c_user_id"],
    cUserFollowId: json["c_user_follow_id"],
    cDisplayName: json["c_display_name"],
    cProfileImg: json["c_profile_img"],
    cCreateDate: DateTime.parse(json["c_create_date"]),
    followMedia: List<FollowMedia>.from(json["follow_media"].map((x) => FollowMedia.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "c_follow_id": cFollowId,
    "c_user_id": cUserId,
    "c_user_follow_id": cUserFollowId,
    "c_display_name": cDisplayName,
    "c_profile_img": cProfileImg,
    "c_create_date": cCreateDate.toIso8601String(),
    "follow_media": List<dynamic>.from(followMedia.map((x) => x.toJson())),
  };
}

class FollowMedia {
  FollowMedia({
    required this.cMediaId,
    required this.cMediaName,
    required this.cMediaUserId,
    required this.cMediaType,
    required this.cMediaDesc,
    required this.cMediaFilter,
    required this.cMediaAudio,
    required this.cMediaLatlng,
    required this.cMediaLocation,
    required this.cTags1,
    required this.cTags2,
    required this.cTags3,
    required this.cMediaCreateDate,
    required this.cUserId,
    required this.cUsername,
    required this.cDisplayName,
    required this.cEmail,
    required this.cProfileImg,
    required this.cPassword,
    required this.cPhoneCode,
    required this.cPhoneNumber,
    required this.cVerificationCode,
    required this.cVerCodeTime,
    required this.cVerifiedStatus,
    required this.cTextfilter,
    required this.cTextstyle,
    required this.cTextalign,
    required this.cTextColor,
    required this.cTextBgColor,
    required this.cTextFamily,
    required this.cTextSize,
    required this.postLikes,
    required this.postLikesUser,
    required this.postCraving,
    required this.postCravingUser,
    required this.postComments,
    required this.cIsFollow,
  });

  String cMediaId;
  String cMediaName;
  String cMediaUserId;
  String cMediaType;
  String cMediaDesc;
  String cMediaFilter;
  String cMediaAudio;
  String cMediaLatlng;
  String cMediaLocation;
  String cTags1;
  String cTags2;
  String cTags3;
  DateTime cMediaCreateDate;
  String cUserId;
  String cUsername;
  String cDisplayName;
  String cEmail;
  String cProfileImg;
  String cPassword;
  String cPhoneCode;
  String cPhoneNumber;
  String cVerificationCode;
  DateTime cVerCodeTime;
  String cVerifiedStatus;
  String cTextfilter;
  String cTextstyle;
  String cTextalign;
  String cTextColor;
  String cTextBgColor;
  String cTextFamily;
  String cTextSize;
  String postLikes;
  String postLikesUser;
  String postCraving;
  String postCravingUser;
  String postComments;
  String cIsFollow;

  factory FollowMedia.fromJson(Map<String, dynamic> json) => FollowMedia(
    cMediaId: json["c_media_id"],
    cMediaName: json["c_media_name"],
    cMediaUserId: json["c_media_user_id"],
    cMediaType: json["c_media_type"],
    cMediaDesc: json["c_media_desc"],
    cMediaFilter: json["c_media_filter"],
    cMediaAudio: json["c_media_audio"],
    cMediaLatlng: json["c_media_latlng"],
    cMediaLocation: json["c_media_location"],
    cTags1: json["c_tags1"],
    cTags2: json["c_tags2"],
    cTags3: json["c_tags3"],
    cMediaCreateDate: DateTime.parse(json["c_media_create_date"]),
    cUserId: json["c_user_id"],
    cUsername: json["c_username"],
    cDisplayName: json["c_display_name"],
    cEmail: json["c_email"],
    cProfileImg: json["c_profile_img"],
    cPassword: json["c_password"],
    cPhoneCode: json["c_phone_code"],
    cPhoneNumber: json["c_phone_number"],
    cVerificationCode: json["c_verification_code"],
    cVerCodeTime: DateTime.parse(json["c_ver_code_time"]),
    cVerifiedStatus: json["c_verified_status"],
    cTextfilter: json["c_textfilter"],
    cTextstyle: json["c_textstyle"],
    cTextalign: json["c_textalign"],
    cTextColor: json["c_textColor"],
    cTextBgColor: json["c_textBgColor"],
    cTextFamily: json["c_textFamily"],
    cTextSize: json["c_textSize"],
    postLikes: json["post_likes"],
    postLikesUser: json["post_likes_user"],
    postCraving: json["post_craving"],
    postCravingUser: json["post_craving_user"],
    postComments: json["post_comments"],
    cIsFollow: json["c_is_follow"],
  );

  Map<String, dynamic> toJson() => {
    "c_media_id": cMediaId,
    "c_media_name": cMediaName,
    "c_media_user_id": cMediaUserId,
    "c_media_type": cMediaType,
    "c_media_desc": cMediaDesc,
    "c_media_filter": cMediaFilter,
    "c_media_audio": cMediaAudio,
    "c_media_latlng": cMediaLatlng,
    "c_media_location": cMediaLocation,
    "c_tags1": cTags1,
    "c_tags2": cTags2,
    "c_tags3": cTags3,
    "c_media_create_date": cMediaCreateDate.toIso8601String(),
    "c_user_id": cUserId,
    "c_username": cUsername,
    "c_display_name": cDisplayName,
    "c_email": cEmail,
    "c_profile_img": cProfileImg,
    "c_password": cPassword,
    "c_phone_code": cPhoneCode,
    "c_phone_number": cPhoneNumber,
    "c_verification_code": cVerificationCode,
    "c_ver_code_time": cVerCodeTime.toIso8601String(),
    "c_verified_status": cVerifiedStatus,
    "c_textfilter": cTextfilter,
    "c_textstyle": cTextstyle,
    "c_textalign": cTextalign,
    "c_textColor": cTextColor,
    "c_textBgColor": cTextBgColor,
    "c_textFamily": cTextFamily,
    "c_textSize": cTextSize,
    "post_likes": postLikes,
    "post_likes_user": postLikesUser,
    "post_craving": postCraving,
    "post_craving_user": postCravingUser,
    "post_comments": postComments,
    "c_is_follow": cIsFollow,
  };
}



class Notifications {
  late final String n_email;
  late final String n_display_name;
  late final String n_username;
  late final String n_profile_img;
  late final String n_noti_type;

  Notifications({
    required this.n_email,
    required this.n_display_name,
    required this.n_username,
    required this.n_profile_img,
    required this.n_noti_type
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      n_email: json['c_email'] as String,
      n_display_name: json['c_display_name'] as String,
      n_username: json['c_username'] as String,
      n_profile_img: json['c_profile_img'] as String,
      n_noti_type: json['c_noti_type'] as String,
    );
  }
}


class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}


