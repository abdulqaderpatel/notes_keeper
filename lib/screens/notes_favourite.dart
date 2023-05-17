// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_keeper/controllers/notes_controller.dart';

class NotesFavourite extends StatefulWidget {
  @override
  State<NotesFavourite> createState() => _NotesFavouriteState();
}

class _NotesFavouriteState extends State<NotesFavourite> {
  MainController controller = Get.put(MainController());

  @override
  void initState() {
    controller.refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Favourites")),
        body: Container(
          height: 1000,
          child: Center(
              child: Obx(() => ListView.builder(
                  itemCount: controller.noteFavourites.length,
                  itemBuilder: (context, index) {
                    var items = controller.noteFavourites[index];
                    var color = Color(int.parse(items["color"]));
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Text(items["title"],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                items["description"],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )),
                            ],
                          )
                        ],
                      ),
                    );
                  }))),
        ));
  }
}
