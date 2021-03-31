
import 'package:animalmerge/classes/home/model/home_model.dart';
import 'package:animalmerge/service/screen_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'item_drag_view.dart';


class HomeColumnView extends StatefulWidget {
  HomeColumnView({Key key}) : super(key: key);

  @override
  _HomeColumnViewState createState() => _HomeColumnViewState();
}

class _HomeColumnViewState extends State<HomeColumnView> {
  static double sizeW = (ScreenService.width - 15 * 2 - 3 * 10) / 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Container(
      height: sizeW * 3 + 10 * 2,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 0),
      child: StreamBuilder(
        initialData: 1,
        stream: HomeCoreModel.instance.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: HomeCoreModel.getChild(),
          );
        },
      ),
    );
  }
}
