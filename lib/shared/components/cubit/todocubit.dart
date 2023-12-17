
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoappv2/moduls/archivedscreen.dart';
import 'package:todoappv2/moduls/donescreen.dart';
import 'package:todoappv2/moduls/tasksscreen.dart';
import 'package:todoappv2/shared/components/cubit/todostates.dart';

class TodoCubit extends Cubit<TodoStates>{


  TodoCubit():super(TodoInitialState());

 static TodoCubit get(context)=>BlocProvider.of(context);

  int bottomNavbarindex=0;
  bool isBottomsheetshown=false;
  IconData fabicon=Icons.edit;

  List<Widget> screens=[
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> appbartitle =[
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var tasktitlecontroler = TextEditingController();
  var tasktimecontroler = TextEditingController();
  var taskdatecontroler = TextEditingController();



  List<BottomNavigationBarItem> bottomNavbarItems=[
  const BottomNavigationBarItem(
  icon:Icon(
  Icons.add_task_rounded,
  ) ,
  label:'Tasks' ,

  ),
   const BottomNavigationBarItem(
     icon:Icon(
       Icons.task_alt_rounded,
     ) ,
     label:'Done' ,

   ),
   const BottomNavigationBarItem(
     icon:Icon(
       Icons.archive_outlined,
     ) ,
     label:'Archived' ,

   ),
 ];

  void bottomNavbarItemOntap(int currentitemindex){
   bottomNavbarindex=currentitemindex;
   emit(ChangeBottomNavBarItemsState());
 }

 void changefabicon({
    required IconData icon,
    required bool isshown,
}){

    if(isshown){
      fabicon=icon;
      isBottomsheetshown=isshown;
    }
    else{
      fabicon=icon;
      isBottomsheetshown=isshown;
    }
    emit(ChangeFloatingActionButtoniconsState());

 }

  Database? database;

  List<Map> newtasks=[];
  List<Map> donetasks=[];
  List<Map> archivedtasks=[];

  void createdatabase(){
     openDatabase(
      'todo.db',
      version: 1,
       onCreate: (database, version) {
                 database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,time Text,date TEXT,status TEXT)');
       },
       onOpen: (database) {

         getdatafromdatabase(database);
       },

    ).then((value) {
      database=value;
      emit(TodoCreateDatabaseState());
     });

  }

   insertdataintodatabase({
    required String tasktitle,
    required String tasktime,
    required String taskdate,

  })async{

 await database!.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks (title,time,date,status) VALUES ("$tasktitle","$tasktime","$taskdate","new")');

      return Future(() => null);
    }).then((value) {
      getdatafromdatabase(database);
      emit(TodoInsertDatabaseState());
    });
  }

  void getdatafromdatabase(database){

    newtasks=[];
    donetasks=[];
    archivedtasks=[];

    TodoGetDatabaseLoadingState();
      database.rawQuery('SELECT * FROM tasks')
          .then((value) {

        value.forEach((element) {
          if(element['status']=='new')
            newtasks.add(element);
          else if(element['status']=='done')
            donetasks.add(element);
          else archivedtasks.add(element);

        });

        emit(TodoGetDatabaseState());
      });

  }

  void updatedatabase({
    required String status,
    required int id,
}){

    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          emit(TodoUpdateDatabaseState());
          getdatafromdatabase(database);
    }).catchError((error){
      print('${error.toString()}');
    });
  }

  void daletedatabase({
    required int id,
}){

    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getdatafromdatabase(database);
          emit(TodoDeleteDatabaseState());
    }).catchError((error){
      print('${error.toString()}');
    });
  }














}

