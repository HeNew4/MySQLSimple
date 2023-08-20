# MySQL Simple

This Dart library aims to simplify and streamline the process of interacting with MySQL databases.

## Features

- Establish a connection to a MySQL database.
- Execute SQL queries and retrieve results.
- Create tables with specified column definitions.
- Retrieve all elements or specific columns from a table.
- Search for items in the database with various search options.
- Insert, update, and delete elements in the database.

## Getting started

Add the following line to your pubspec.yaml file:

```yaml
dependencies:
  mysql_client: 0.0.27
  mysqlsimple:
    git: git//github.com/henew/mysqlsimple
```

## Usage


Import MySQL Simple

```dart
import 'package:mysqlsimple/mysqlsimple.dart'; 
```
Demo of MySQL Simple
```dart
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
```

## Additional information

Contributions are welcome! If you want to improve this library, open an issue or send a pull request.