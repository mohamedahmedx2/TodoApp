
import 'package:bottom_navigation_bar/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/modules.archived_tasks/archive_tasks.dart';
import '../../modules/modules.done_tasks/done_tasks_screen.dart';
import '../../modules/modules.new_tasks/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates>{



  AppCubit() : super(AppInitialState());


  static AppCubit get(context) => BlocProvider.of(context);


  int current = 0;
  List<Widget> screen = [
    const TasksScreen(),
    const DoneTasks(),
    const ArchiveTasks(),
  ];

  List<String> title = [
    "New Tasks",
    "Done Tasks ",
    "Archived Tasks",
  ];


   changeIndex(int index){

     current = index;
     emit(AppChangeBottomNavBarState());
  }

  late Database db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

void nn ()
{
  print('mohamed');
}

  // 1. create DataBase and Table
  void createDataBase()  {
     openDatabase(
      "todo.db",

      version: 1,
      onCreate: (db, version) {
        print("database created");

        db.execute(
            "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
            .then((value) {
          print("table created");
        }).catchError((error) {
          print("the error in table ${error.toString()}");
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print("database opened");
      },
    ).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
     });
  }



  // 2. inserting database
   insertToDataBase({
    required title,
    required date,
    required time,
  }) async {
    await db.transaction((txn) {
      return txn.rawInsert(
          "INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'new')").then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(db).then((value) {
          newTasks = value;
          print(newTasks[0]);
          emit(AppGetDatabaseState());
        });

      }).catchError((error) {
        print("error insert ${error.toString()}");
      });
    });
  }



  // 3. Get Database
  getDataFromDatabase(db)  {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());

  db.rawQuery("SELECT * FROM tasks").then((value) {

    value.forEach((element) {
     if(element['status'] == 'new'){
       newTasks.add(element);
     } else if(element['status'] == 'done'){
       doneTasks.add(element);
     }else {
       archivedTasks.add(element);
     }
    });
    emit(AppGetDatabaseState());
  });
  }





  // 4. Update Data

  void updateData({
  required String status,
    required int id,
}) async
 {
  db.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
     ).then((value)
  {
    getDataFromDatabase(db);
       emit(AppUpdateDatabaseState());
  });
  }





  // 5. Delete Data

   deleteData ({
  required int id,
}){

  db.rawDelete('DELETE FROM tasks WHERE id = ?',
      [id]).then((value) {
          getDataFromDatabase(db);
          emit(AppDeleteDatabaseState());
   });
  }



  // bottomSheet

  bool theBottom = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    theBottom = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }



}