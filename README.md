![pf2ub-khwyr.gif](https://upload-images.jianshu.io/upload_images/3258209-b266d3a3d58d56ad.gif?imageMogr2/auto-orient/strip/2/w/100)
# 实现功能我们需要先了解两个flutter控件Draggable 和 DragTarget
从字面意思大概能看出,Draggable是可以拖动的,DragTarget是拖动的目标,就是接收Draggable的控件
![image.png](https://upload-images.jianshu.io/upload_images/3258209-421bf538cf520699.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
只能接收不能拖动的控件我们就可以使用DragTarget,根据上面代码onAccept方法时接收到数据,然后刷新到界面
```
DragTarget(
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
      )

bool onWillAccept(data) 当Draggable被滑动到DragTarget上方时会调用,data为Draggable携带的数据源，根据条件判断是否需要接受此数据，如果要接收，则返回true；

onAccept(data) 当Draggable被滑动到DragTarget上方后松手，且onWillAccept函数返回true时会被调用，可以在此处处理Widget的状态变化；

onLeave(data) 当Draggable从DragTarget上方离开时会调用该方法。
作者：平静的阿卿达
链接：https://www.jianshu.com/p/267e030b265a
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```
又能拖动又能接收,我们可以对Draggable 和 DragTarget进行嵌套
```
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

```
childWhenDragging是在拖动时留在原地的控件,因为我们拖动时只显示动物,在原地方留下一个空白位子,所以拖动时传递了一个空数据的对象HomeItem
feedback是拖动时运动中的控件
child就是在不动的时间显示的内容


下面就是拖动控件创建的方式
```
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
```

下面是拖动控件内部显示动物的控件
```
class ItemView extends StatelessWidget {
  ItemView({Key key, this.data, this.isDrag = false}) : super(key: key);

  // static double sizeW = (ScreenService.width - 15 * 2 - 3 * 10) / 4;

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
              // color: Colors.red,
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
```
数据我们可以创建一个3x4的二维数组来存储,x y大家可以忽略,本来是给服务端返回使用的
```
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
```
移动的时候,会出现3中情况
第一种:移到一个空的位置上 revicer.level == 0
第二种:移到一个等级相同的位置上,两个动物就会合并成一个更高级的revicer.level == sender.level 将接受+1revicer.level += 1 发送设置为0 sender.level = 0;
第三中:移到一个等级不同的位置上,两个动物就是交换位置revicer.level != sender.level
      int level = sender.level;
      sender.level = revicer.level;
      revicer.level = level;
```
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
```

删除直接设置等级为0
```
  ///删除一个
  static void removeItem(HomeItem revicer) {
    revicer.level = 0;
    HomeCoreModel.instance.streamController.sink.add(1);
  }
```
添加循环查找还是空的位置
```
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
```


