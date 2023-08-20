import 'package:mysql_client/mysql_client.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  // I am not going to delete this. It made my day :D
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

  Future<void> _closeConnection() async {
    var connection = await _connection();
    await connection.close();
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

  /// Create a table with it [tableName] with the data from [content].
  /// 
  /// Example:
  /// ```dart
  /// createTable('users', {'id': 'INT AUTO_INCREMENT', 'nombre': 'VARCHAR(25)'})
  /// ```
  Future<void> createTable(String tableName, Map<String, String> content) async {
    String elementsTable = '';

    content.forEach((key, value) {
      elementsTable += '\'$key\' $value,';
    });
    elementsTable = elementsTable.substring(0, elementsTable.length - 1);
    
    String query = 'CREATE TABLE $tableName ($elementsTable)';
    await _query(query);
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
    await _closeConnection();
    return arrayElements;
  }

  /// You get all the elements of the [tableName],
  /// with the specific elements of [elementsSpecific].
  /// 
  /// Example:
  /// ```dart
  /// getAllSpecificElemets('users', ['id', 'nombre']);
  /// ```
  Future getAllSpecificElemets(String tableName, List<String> elementsSpecific) async {
    List arrayElements = [];
    String elementQuery = '';

    for (var element in elementsSpecific) {
      elementQuery += '$element,';
    }
    elementQuery = elementQuery.substring(0, elementQuery.length - 1);

    String query = 'SELECT $elementQuery FROM $tableName';

    var result = await _query(query);

    for (final row in result.rows) {
      arrayElements.add(row.assoc());
    }

    await _closeConnection();

    return arrayElements;
  }

  /// # Search
  /// ## Simple
  /// 
  /// Searches for any item(s) in the database. Requires it [tableName] where to search;
  /// Requires it [columnName] to know which column to search;
  /// Requires it [searchTerm] to finish the search. 
  /// Returns a list of the searched items.
  /// 
  /// Example:
  /// ``` dart
  /// searchElements('users', 'name', 'joe');
  /// ```
  /// 
  /// ## Condition
  /// 
  /// Searches for any item(s) in the database. Requires [tableName] to search,
  /// but it changes something here if you help [condition] = true, it will search with a condition;
  /// Requires it [columnName] to know which column to search;
  /// It requires [searchTerm] which will be for the condition that [columnName] did.
  /// 
  /// Example:
  /// ```dart
  /// searchElements('paleta', 'id', '< 4', true);
  /// ```
  Future searchElements(String tableName, String columnName, String searchTerm, [bool condition = false]) async {
    List arrayElements = [];
    String query = '';

    if (!condition) {
      query = 'SELECT * FROM $tableName  WHERE $columnName  = \'$searchTerm\'';
    } else {
      query = 'SELECT * FROM $tableName  WHERE $columnName $searchTerm';
    }

    var result = await _query(query);

    for (final row in result.rows) {
      arrayElements.add(row.assoc());
    }

    await _closeConnection();
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

    await _closeConnection();
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

    await _closeConnection();
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

    await _closeConnection();
    return result;
  }
}
