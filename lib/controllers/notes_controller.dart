import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:get/state_manager.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;
  var chosenColor = 0.obs;

  RxList<Map<String, dynamic>> noteItems = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> noteFavourites = <Map<String, dynamic>>[].obs;
  var isFavourite = [].obs;

  final notesBox = Hive.box("notes");

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
      };
    }).toList();
    noteItems.value = data.toList();
    noteFavourites.value = noteItems
        .where((element) => (element["isFavourite"] ?? false == true))
        .toList();
    print(noteFavourites);
  }

  Future<void> updateItems(int key, Map<String, dynamic> item) async {
    await notesBox.put(key, item);
  }
}
