// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_keeper/controllers/notes_controller.dart';

class NotesAdd extends StatefulWidget {
  NotesAdd({super.key});

  @override
  State<NotesAdd> createState() => _NotesAddState();
}

class _NotesAddState extends State<NotesAdd> {
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

  TextEditingController categoryController = TextEditingController();

  addCategories(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15),
            child: Container(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: categoryController,
                      decoration:
                          InputDecoration(hintText: "Enter Category name"),
                    ),
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () {
                        controller.categoriesBox
                            .add({"name": categoryController.text});
                        controller.noteCategories.add(categoryController.text);
                        controller.refreshCategories();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    controller.refreshCategories();
  }

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
                height: 250,
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
              SizedBox(
                height: 20,
              ),
              Text("Choose Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 25),
                  Obx(
                    () => DecoratedBox(
                      decoration: ShapeDecoration(
                        color: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 0.0),
                        child: DropdownButton<String>(
                          value: controller.noteCategories.length == 0
                              ? null
                              : controller.selectedValue.value,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.black,
                          ),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            controller.selectedValue.value = value!;
                          },
                          items: controller.noteCategories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      addCategories(context);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
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
              SizedBox(height: 28),
              ElevatedButton(
                  onPressed: () async {
                    if (controller.noteCategories.length != 0) {
                      controller.createItems({
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "color": colors[controller.chosenColor.value]
                            .value
                            .toString(),
                        "isFavourite": false,
                        "category": controller.selectedValue.value
                      });
                      controller.refreshItems();
                      titleController.clear();
                      descriptionController.clear();
                      controller.chosenColor.value = 0;
                    } else {
                      Get.snackbar("title", "message",
                          backgroundColor: Colors.red,
                          titleText: Text(
                            "No Category Found",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          messageText: Text(
                            "Please add a category first to add notes",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ));
                    }
                  },
                  child: Text("Add"))
            ],
          ),
        ));
  }
}
