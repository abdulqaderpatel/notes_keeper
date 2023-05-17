// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_keeper/controllers/notes_controller.dart';

class NotesAdd extends StatelessWidget {
  NotesAdd({super.key});

  MainController controller = Get.put(MainController());

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.brown,
    Colors.grey,
    Colors.yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Add Notes")),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      hintText: "Enter Title"),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 300,
                child: TextField(
                  expands: true,
                  maxLines: null,
                  controller: descriptionController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(20),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      hintText: "Enter Description"),
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 30,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            controller.chosenColor.value = index;
                          },
                          child: Obx(
                            () => Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 30,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: colors[index],
                                  border: Border.all(
                                      width:
                                          controller.chosenColor.value == index
                                              ? 3
                                              : 0,
                                      color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          ));
                    }),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    controller.createItems({
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "color":
                          colors[controller.chosenColor.value].value.toString(),
                      "isFavourite": false,
                    });
                    controller.refreshItems();
                    titleController.clear();
                    descriptionController.clear();
                    controller.chosenColor.value = 0;
                  },
                  child: Text("Add"))
            ],
          ),
        ));
  }
}
