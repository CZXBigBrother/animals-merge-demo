import 'dart:async';
import 'package:animalmerge/classes/home/view/item_drag_view.dart';
import 'package:flutter/material.dart';

class HomeItem {
  HomeItem({this.level = 0, this.id, this.x, this.y});

  int level;
  String id;
  int x;
  int y;
}

class HomeCoreModel {
  factory HomeCoreModel() => _getInstance();

  static HomeCoreModel get instance => _getInstance();
  static HomeCoreModel _instance;

  HomeCoreModel._internal() {
    // 初始化
  }

  static HomeCoreModel _getInstance() {
    if (_instance == null) {
      _instance = new HomeCoreModel._internal();
    }
    return _instance;
  }

  StreamController streamController = new StreamController.broadcast();
  StreamController buyStreamController = new StreamController.broadcast();

  double totalCoin = 0;
  double productCoin = 0;

  Stream get stream => streamController.stream;

  Stream get streambuy => streamController.stream;

  List<List<HomeItem>> cores = [
    [
      HomeItem(x: 0, y: 0, level: 1),
      HomeItem(x: 1, y: 0, level: 1),
      HomeItem(x: 2, y: 0, level: 1),
      HomeItem(x: 3, y: 0, level: 1)
    ],
    [
      HomeItem(x: 0, y: 1),
      HomeItem(x: 1, y: 1),
      HomeItem(x: 2, y: 1),
      HomeItem(x: 3, y: 1)
    ],
    [
      HomeItem(x: 0, y: 2),
      HomeItem(x: 1, y: 2),
      HomeItem(x: 2, y: 2),
      HomeItem(x: 3, y: 2)
    ]
  ];

  ///移动数据
  static void moveItem(HomeItem revicer, HomeItem sender) {
    if (revicer.level == 0) {
      revicer.level += sender.level;
      sender.level = 0;
    } else if (revicer.level == sender.level) {
      revicer.level += 1;
      sender.level = 0;
    } else if (revicer.level != sender.level) {
      int level = sender.level;
      sender.level = revicer.level;
      revicer.level = level;
    }
    HomeCoreModel.instance.streamController.sink.add(1);
  }

  ///添加一个
  static void addItem(int core) {
    bool isFinish = false;
    for (List ones in HomeCoreModel.instance.cores) {
      for (HomeItem one in ones) {
        if (one.level == 0) {
          one.level = core;
          isFinish = true;
          break;
        }
      }
      if (isFinish == true) {
        break;
      }
    }
    HomeCoreModel.instance.streamController.sink.add(1);
  }

  ///删除一个
  static void removeItem(HomeItem sender) {
    sender.level = 0;
    HomeCoreModel.instance.streamController.sink.add(1);
  }

  static List<Widget> getChild() {
    List<Widget> childs = [];
    HomeCoreModel.instance.cores.forEach((element) {
      List<Widget> temp = [];
      element.forEach((element) {
        temp.add(ItemDraggableTarget(
          data: element,
        ));
      });
      childs.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: temp,
      ));
    });
    return childs;
  }
}
