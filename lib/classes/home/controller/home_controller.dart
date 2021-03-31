import 'package:animalmerge/classes/home/model/home_model.dart';
import 'package:animalmerge/classes/home/view/home_column_view.dart';
import 'package:flutter/material.dart';

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: HomeColumnView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    HomeCoreModel.addItem(1);
                  },
                  color: Colors.blue,
                  child: Text("Add"),
                ),
                SizedBox(
                  width: 30,
                ),
                DragTarget(
                  onWillAccept: (data) {
                    // print("data = $data onWillAccept --- 0");
                    return data != null;
                  },
                  onAccept: (data) {
                    HomeCoreModel.removeItem(data);
                  },
                  onLeave: (data) {
                    // print("data = $data onLeave --- 0");
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 100,
                      color: Colors.blue,
                      child: Text("remove"),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
