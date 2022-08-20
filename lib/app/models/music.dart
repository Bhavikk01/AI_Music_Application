import 'dart:convert';

import 'package:flutter/foundation.dart';

class MyMusicList {
  final List<MyMusic> musics;
  MyMusicList({
    required this.musics,
  });

  MyMusicList copyWith({
    required List<MyMusic> musics,
  }) {
    return MyMusicList(
      musics: musics,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'musics': musics.map((x) => x.toMap()).toList(),
    };
  }

  factory MyMusicList.fromMap(Map<String, dynamic> map) {

    return MyMusicList(
      musics: List<MyMusic>.from(map['musics']?.map((x) => MyMusic.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMusicList.fromJson(String source) =>
      MyMusicList.fromMap(json.decode(source));

  @override
  String toString() => 'MyMusicList(radios: $musics)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MyMusicList && listEquals(o.musics, musics);
  }

  @override
  int get hashCode => musics.hashCode;
}

class MyMusic {
  final int id;
  final int order;
  final String name;
  final String tagline;
  final String color;
  final String desc;
  final String url;
  final String category;
  final String icon;
  final String image;
  final String lang;
  MyMusic({
    required this.id,
    required this.order,
    required this.name,
    required this.tagline,
    required this.color,
    required this.desc,
    required this.url,
    required this.category,
    required this.icon,
    required this.image,
    required this.lang,
  });

  MyMusic copyWith({
    required int id,
    required int order,
    required String name,
    required String tagline,
    required String color,
    required String desc,
    required String url,
    required String category,
    required String icon,
    required String image,
    required String lang,
  }) {
    return MyMusic(
      id: id,
      order: order ,
      name: name,
      tagline: tagline,
      color: color,
      desc: desc,
      url: url ,
      category: category,
      icon: icon,
      image: image,
      lang: lang,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'name': name,
      'tagline': tagline,
      'color': color,
      'desc': desc,
      'url': url,
      'category': category,
      'icon': icon,
      'image': image,
      'lang': lang,
    };
  }

  factory MyMusic.fromMap(Map<String, dynamic> map) {

    return MyMusic(
      id: map['id'],
      order: map['order'],
      name: map['name'],
      tagline: map['tagline'],
      color: map['color'],
      desc: map['desc'],
      url: map['url'],
      category: map['category'],
      icon: map['icon'],
      image: map['image'],
      lang: map['lang'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMusic.fromJson(String source) =>
      MyMusic.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyMusic(id: $id, order: $order, name: $name, tagline: $tagline, color: $color, desc: $desc, url: $url, category: $category, icon: $icon, image: $image, lang: $lang)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MyMusic &&
        o.id == id &&
        o.order == order &&
        o.name == name &&
        o.tagline == tagline &&
        o.color == color &&
        o.desc == desc &&
        o.url == url &&
        o.category == category &&
        o.icon == icon &&
        o.image == image &&
        o.lang == lang;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    order.hashCode ^
    name.hashCode ^
    tagline.hashCode ^
    color.hashCode ^
    desc.hashCode ^
    url.hashCode ^
    category.hashCode ^
    icon.hashCode ^
    image.hashCode ^
    lang.hashCode;
  }
}