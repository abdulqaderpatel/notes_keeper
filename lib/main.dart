// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_keeper/controllers/notes_controller.dart';
import 'package:notes_keeper/screens/notes_add.dart';
import 'package:notes_keeper/screens/notes_display.dart';
import 'package:notes_keeper/screens/notes_favourite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("notes");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  final List<Widget> pages = [NotesDisplay(), NotesFavourite(), NotesAdd()];

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Obx(
              () => BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: (index) {
                    controller.selectedIndex.value = index;
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notes),
                      label: "Notes",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: "Favourites",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: "Add",
                    )
                  ]),
            ),
            body: Obx(() => pages[controller.selectedIndex.value])));
  }
}
