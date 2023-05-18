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

  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];

  @override
  void initState() {
    super.initState();
    controller.refreshItems();
    controller.refreshCategories();
    controller
        .displayItemsCategorically(controller.selectedCategoryIndex.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your Notes")),
        body: SizedBox(
          height: 3000,
          child: ListView(
            children: [
              SizedBox(
                  height: 100,
                  child: Obx(() => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.noteCreatedCategories.length,
                      itemBuilder: (context, index) {
                        var item = controller.noteCreatedCategories[index];
                        return InkWell(
                            onTap: () {
                              controller.selectedCategoryIndex.value = index;
                              controller.displayItemsCategorically(
                                  controller.selectedCategoryIndex.value);
                            },
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width:
                                            controller.selectedCategoryIndex ==
                                                    index
                                                ? 3
                                                : 0,
                                        color: Colors.black),
                                    color: colors[index % 4],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    )),
                                margin: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 15),
                                width: 100,
                                child: Center(
                                    child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                )),
                              ),
                            ));
                      }))),
              Container(
                  height: 492,
                  child: Center(
                      child: Obx(
                    () => ListView.builder(
                        itemCount: controller.categorizedList.length,
                        itemBuilder: (context, index) {
                          var items = controller.categorizedList[index];
                          var color = Color(int.parse(items["color"]));
                          return Card(
                            elevation: 10,
                            child: Container(
                              height: 210,
                              decoration: BoxDecoration(
                                color: color,
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(items["title"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
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
                                              var categorize = controller
                                                  .noteItems
                                                  .where((element) =>
                                                      element["category"] ==
                                                      controller.noteCategories[
                                                          controller
                                                              .selectedCategoryIndex
                                                              .value])
                                                  .toList();
                                              controller.updateItems(
                                                  categorize[index]["key"], {
                                                "title": items["title"],
                                                "description":
                                                    items["description"],
                                                "color": items["color"],
                                                "isFavourite":
                                                    !items["isFavourite"],
                                                "category": items["category"]
                                              });
                                              controller.refreshItems();

                                              controller
                                                  .displayItemsCategorically(
                                                      controller
                                                          .selectedCategoryIndex
                                                          .value);
                                            },
                                            child: Obx(
                                              () => Icon(controller
                                                                  .categorizedList[
                                                              index]
                                                          ["isFavourite"] ==
                                                      true
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ))),
            ],
          ),
        ));
  }
}
