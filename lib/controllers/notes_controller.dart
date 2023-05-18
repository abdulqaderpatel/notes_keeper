import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:get/state_manager.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;
  var chosenColor = 0.obs;

  RxList<Map<String, dynamic>> noteItems = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> noteFavourites = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> noteCreatedCategories =
      <Map<String, dynamic>>[].obs;

  late RxList<String> noteCategories = <String>[].obs;
  late RxString selectedValue = noteCategories.first.obs;

  var isFavourite = [].obs;
  RxInt selectedCategoryIndex = 0.obs;

  RxList<Map<String, dynamic>> categorizedList = <Map<String, dynamic>>[].obs;

  final notesBox = Hive.box("notes-tracker");
  final categoriesBox = Hive.box("categories-tracker");

  Future<void> createItems(Map<String, dynamic> item) async {
    await notesBox.add(item);

    print(notesBox);
  }

  refreshItems() {
    var data = notesBox.keys.map((key) {
      final item = notesBox.get(key);
      return {
        "key": key,
        "title": item["title"],
        "description": item["description"],
        "color": item["color"],
        "isFavourite": item["isFavourite"],
        "category": item["category"],
      };
    }).toList();
    noteItems.clear();
    noteFavourites.clear();
    noteItems.value = data.toList();
    noteFavourites.value = noteItems
        .where((element) => (element["isFavourite"] ?? false == true))
        .toList();
  }

  refreshCategories() {
    var data = categoriesBox.keys.map((key) {
      final item = categoriesBox.get(key);
      return {
        "key": key,
        "name": item["name"],
      };
    }).toList();

    noteCategories.clear();
    if (data.length > 0) {
      noteCreatedCategories.value = data.toList();
      for (int i = 0; i < noteCreatedCategories.length; i++) {
        noteCategories.add(noteCreatedCategories[i]["name"]);
      }
    }
  }

  displayItemsCategorically(int category) {
    categorizedList.clear();
    categorizedList.value = noteItems
        .where((element) => (element["category"] == noteCategories[category]))
        .toList();
    print(noteItems);
    print("\n${categorizedList} \n\n\n");
  }

  Future<void> updateItems(int key, Map<String, dynamic> item) async {
    await notesBox.put(key, item);
  }
}
