# MySQL Simple

This Dart library aims to simplify and streamline the process of interacting with MySQL databases, providing a user-friendly and efficient interface for performing queries, transactions and common database operations.

## Features

- **Simple Interface**: Forget the complexities of communicating with MySQL databases. Our library offers an intuitive interface that makes it easy to create and execute SQL queries.
- **Connection Management**: The library automatically handles database connection management, ensuring efficient and seamless resource management.

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