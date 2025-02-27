
import 'package:sqflite/sqflite.dart';

import '../model/task.dart';

class DBHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb()async{
    if(_db != null){
      return;
    }
    try{
      String _path = await getDatabasesPath() + "tasks.db";
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER , repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)",
          );
        },
      );
    } catch(e){
      print(e);
    }
  }

  static Future<int> insert(Task? task) async{
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson())?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task)async{
    return await _db!.delete(_tableName,where: "id=?",whereArgs: [task.id]);
  }

  static update(int id)async{ //Kindly note that the return await is not compulsory, but we can do it
    return await _db!.rawUpdate('''
        UPDATE tasks SET  isCompleted = ? WHERE id =?
    ''',[1,id]);
  }

  //int? count = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM table_name'));

  Future<int?> getCount() async {
    //database connection
    //Database db = await this.database;
    var x = await _db!.rawQuery('SELECT COUNT (*) from $_tableName');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

//var count = _db!.rawQuery('SELECT COUNT(*) FROM TABLEOFTASKS');

//final result = await _db!.rawQuery('SELECT COUNT(*) FROM $_tableName');
//final count = Sqflite.firstIntValue(result);
//int? count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM table_name'));

}
