import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../db/db_helper.dart';
import '../model/task.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task})async {
    return await DBHelper.insert(task);

  }

  //get all the data from table
  void getTasks()async{
    List<Map<String,dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());

  }

  void getAllTaskCount()async{
    await DBHelper().getCount();
  }

  void allTaskCount(){
    var k = getAllTaskCount();

  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id)async{
    await DBHelper.update(id);
    getTasks();
  }



  int getTotalTask() {
    var res = 2;


    for(int i =0; i < taskList.length; i++){
      if(taskList[i].id != null){
        res = taskList[i].id!.toString().length;
      }
    }
    return res;
  }

  int getTotalDone(){
    var res =1;
    for(int i = 0;i<taskList.length;i++){
      if(taskList[i].isCompleted == 1){
        res += taskList[1].isCompleted!.bitLength;
      }
    }
    return res;
  }
}