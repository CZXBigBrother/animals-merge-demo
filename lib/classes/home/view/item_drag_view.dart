
import 'package:animalmerge/classes/home/model/home_model.dart';
import 'package:animalmerge/service/screen_service.dart';
import 'package:flutter/material.dart';
final double sizeW = (ScreenService.width - 15 * 2 - 3 * 10) / 4;
class ItemView extends StatelessWidget {
  ItemView({Key key, this.data, this.isDrag = false}) : super(key: key);
  bool isDrag;
  HomeItem data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeW,
      height: sizeW,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: data.level == 0
                ? Text("")
                : Image.asset(
              'assets/dogs/ic_dog_level${data.level}.png',
              width: sizeW,
              height: sizeW,
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Offstage(
                offstage: isDrag || data.level == 0,
                child: Container(
                    alignment: Alignment.center,
                    width: 16,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                        BorderRadius.all(const Radius.circular(15))),
                    child: Text(
                      '${data.level}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )),
              ))
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(238, 239, 240, isDrag == false ? 1 : 0),
          borderRadius: BorderRadius.all(const Radius.circular(15))),
    );
  }
}

class ItemDraggableTarget<HomeItem> extends StatefulWidget {
  HomeItem data;

  ItemDraggableTarget({@required this.data, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemDraggableTargetState(text: data);
}

class _ItemDraggableTargetState extends State<ItemDraggableTarget> {
  var text;

  _ItemDraggableTargetState({@required this.text});
  @override
  Widget build(BuildContext context) {
    if (0 == widget.data.level) {
      return DragTarget(
        onWillAccept: (data) {
          // print("data = $data onWillAccept --- 0");
          return data != null;
        },
        onAccept: (data) {
          HomeCoreModel.moveItem(widget.data, data);
        },
        onLeave: (data) {
          // print("data = $data onLeave --- 0");
        },
        builder: (context, candidateData, rejectedData) {
          return ItemView(data: widget.data);
        },
      );
    } else {
      return Draggable(
        data: widget.data,
        child: Container(
          width: sizeW,
          height: sizeW,
          child: DragTarget(
            onWillAccept: (data) {
              return data != null;
            },
            onAccept: (data) {
              HomeCoreModel.moveItem(widget.data, data);
            },
            onLeave: (data) {
              // print("data = $data onLeave ----- 1");
            },
            builder: (context, candidateData, rejectedData) {
              return ItemView(data: widget.data);
            },
          ),
        ),
        feedback: ItemView(
          data: widget.data,
          isDrag: true,
        ),
        childWhenDragging: ItemView(
          data: HomeItem(),
        ),
      );
    }
  }
}
