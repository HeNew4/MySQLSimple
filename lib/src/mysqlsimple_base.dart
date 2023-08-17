import 'package:mysql_client/mysql_client.dart';
// TODO: Put public facing types in this file.

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

/// This is the class to control and manage MySQL in a simpler way.
/// 
/// Requires these data: host, user, password, database Name, port.
/// 
/// Example:
/// ```dart
/// DataBase('localhost', 'root', 'password', 'Colors', 3306);
/// ```
class DataBase {
  /// The host of the database.
  String host = "";
  /// The port of the database.
  String user = "";
  /// The password of the database.
  String password = "";
  /// The name of the database.
  String database = "";
  /// The port of the database.
  int port = 0;

  DataBase(
    this.host,
    this.user,
    this.password,
    this.database,
    this.port
  );

  /// Makes the connection to the database.
  /// 
  /// Take all the data from the constructor.
  Future<MySQLConnection> _connection() async {
    var connection = await MySQLConnection.createConnection(
      host: host,
      userName: user,
      password: password,
      databaseName: database,
      port: port
    );
    await connection.connect();
    return connection;
  }

  /// Run it [query].
  /// 
  /// Example:
  /// ```dart
  /// _query('SELECT * FROM users;');
  /// ```
  Future _query(String query) async {
    var connection = await _connection();
    var result = connection.execute(query);
    return result;
  }

  /// Gets all data from [tableName]. Returns a list of all data.
  /// 
  /// Example:
  /// ```dart
  /// getAllElements('users');
  /// ```
  Future getAllElements(String tableName) async {
    List arrayElements = [];
    String query = 'SELECT * FROM $tableName';
    
    var result = await _query(query);

    for (final row in result.rows) {
      arrayElements.add(row.assoc());
    }

    return arrayElements;
  }

  /// Searches for any item(s) in the database. Requires it [tableName] where to search;
  /// Requires it [columnName] to know which column to search;
  /// Requires it [searchValue] to finish the search. 
  /// Returns a list of the searched items.
  /// 
  /// Example:
  /// ``` dart
  /// searchElements('users', 'name', 'joe');
  /// ```
  Future searchElements(String tableName, String columnName, String searchValue) async {
    List arrayElements = [];
    String query = 'SELECT * FROM $tableName  WHERE $columnName  = \'$searchValue\'';
    
    var result = await _query(query);

    for (final row in result.rows) {
      arrayElements.add(row.assoc());
    }

    return arrayElements;
  }

  /// Inserts the elements in the [tableName], in the [columnsNames] with the data of [valuesElements].
  /// [valuesElements] must have the same order as [columnsNames], to insert them correctly.
  /// 
  /// Example:
  /// ```dart
  /// insertElement('users', ['id', 'name'], ['2', 'John'])
  /// ```
  Future insertElement(String tableName, List<String> columnsNames, List<String> valuesElements) async {
    String columsQuery = '';
    String valuesQuery = '';

    for (var column in columnsNames) {
      columsQuery += '$column,';
    }
    columsQuery = columsQuery.substring(0, columsQuery.length -1);

    for (var value in valuesElements) {
      valuesQuery += '\'$value\',';
    }
    valuesQuery = valuesQuery.substring(0, valuesQuery.length -1);

    String query = 'INSERT INTO $tableName ($columsQuery) VALUES ($valuesQuery)';
    
    var result = await _query(query);

    return result;
  }

  /// Updates the [tableName] elements with data from [columnsAndValuesToEdit ]. 
  /// To find the element in the database, use [id].
  /// The structure of [columnsAndValuesToEdit] is as follows:
  /// ```dart
  /// var elements = [
  ///   ['name', 'John'],
  ///   ['lastname': 'smith']]
  /// ]
  /// ```
  /// 
  /// Example:
  /// ```dart
  /// updateElement('users', '1', [['name', 'John'], ['lastname', 'smith']]);
  /// ```
  Future updateElement(String tableName, String id ,List<List> columnsAndValuesToEdit) async {

    String editQuery = "";

    for (List listOfList in columnsAndValuesToEdit ) {
      editQuery += '${listOfList[0]} = \'${listOfList[1]}\',';
    }
    editQuery = editQuery.substring(0, editQuery.length -1);

    String query = 'UPDATE $tableName SET $editQuery WHERE id = \'$id\'';
    
    var result = await _query(query);

    return result;
  }
  
  /// This function removes the element with the [id] from the [tableName].
  /// 
  /// Example:
  /// ```dart
  /// deleteElement('users', '1');
  /// ```
  Future deleteElement(String tableName, String id) async {
    String query = 'DELETE FROM $tableName WHERE id = $id';
    var result = await _query(query);

    return result;
  }
}
