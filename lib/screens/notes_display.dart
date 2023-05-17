// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_keeper/controllers/notes_controller.dart';

class NotesDisplay extends StatefulWidget {
  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  MainController controller = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    controller.refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your Notes")),
        body: Container(
            height: 1000,
            child: Center(
                child: Obx(
              () => ListView.builder(
                  itemCount: controller.noteItems.length,
                  itemBuilder: (context, index) {
                    var items = controller.noteItems[index];
                    var color = Color(int.parse(items["color"]));
                    return Card(
                      elevation: 10,
                      child: Container(
                        height: 210,
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            ),
                            SizedBox(height: 90),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        controller.updateItems(index, {
                                          "title": items["title"],
                                          "description": items["description"],
                                          "color": items["color"],
                                          "isFavourite": !items["isFavourite"]
                                        });
                                        controller.refreshItems();
                                      },
                                      child: Obx(
                                        () => Icon(controller.noteItems[index]
                                                    ["isFavourite"] ==
                                                true
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ))));
  }
}
