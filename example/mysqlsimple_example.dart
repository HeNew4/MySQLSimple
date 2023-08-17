import 'package:mysqlsimple/mysqlsimple.dart';

void main() async {
  // Create Conection
  var db = DataBase('localhost', 'root', 'password', 'colors', 3306);
  // Get All Elements of 'Palette'
  var getAllElements = await db.getAllElements('palette');
  print(getAllElements);

  // Get Element of 'Palette'
  var searchElement = await db.searchElements('palette', 'id', '1');
  print(searchElement);

  // Insert Element of 'Palette'
  await db.insertElement('palette', ['id', 'name', 'hex_code'], ['6', 'white', '#FFFFFF']);

  // Update Element of 'Palette'
  await db.updateElement('palette', '6', [['name', 'White']]);

  // Delete Element of 'Palette'
  await db.deleteElement('palette', '6');
}
