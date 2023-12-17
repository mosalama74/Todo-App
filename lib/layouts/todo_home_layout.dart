import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoappv2/shared/components/components.dart';
import 'package:todoappv2/shared/components/cubit/todocubit.dart';
import 'package:todoappv2/shared/components/cubit/todostates.dart';
import 'package:todoappv2/shared/styles/colors.dart';

class TodoHomelayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>TodoCubit()..createdatabase(),
      child: BlocConsumer<TodoCubit,TodoStates>(
        listener: (context, state) {
          if(state is TodoInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {

          TodoCubit todocubitob=TodoCubit.get(context);

          return Scaffold(
            key: todocubitob.scaffoldkey,
            appBar: AppBar(
              backgroundColor:defaultcolor(),
              elevation: 0.0,
              leading: Icon(
                Icons.task_sharp,
                color: Colors.black,
                size: 30.0,
              ),
              title: builddefaulttext(text: '${todocubitob.appbartitle[todocubitob.bottomNavbarindex]}',
                  fontsize: 25.0,
                textcolor: Colors.black,

              ),
              titleSpacing: 15.0,


            ),
            floatingActionButton:FloatingActionButton(
              onPressed: (){

                if(todocubitob.isBottomsheetshown){
                  if(todocubitob.formkey.currentState!.validate()){

                    todocubitob.insertdataintodatabase(
                        tasktitle: todocubitob.tasktitlecontroler.text,
                        tasktime: todocubitob.tasktimecontroler.text,
                        taskdate: todocubitob.taskdatecontroler.text,
                    );
                    todocubitob.changefabicon(
                        icon: Icons.edit,
                        isshown: false);

                  }

                }
                else{

                  todocubitob.scaffoldkey.currentState!
                      .showBottomSheet(
                        (context) => Form(
                      key:todocubitob.formkey,
                      child: Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsetsDirectional.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            builddefaulttextformfield(
                              controller: todocubitob.tasktitlecontroler,
                              labeltext: 'Task Title',
                              keyboardtexttype: TextInputType.text,
                              prefixicon: Icons.title_rounded,
                              validate: (value){
                                if(value!.isEmpty)
                                  return 'Task title must not be empty';
                                else
                                  return null;
                              },
                            ),
                            SizedBox(height: 15.0,),

                            builddefaulttextformfield(
                                controller:todocubitob.tasktimecontroler,
                                labeltext: 'Task Time',
                                keyboardtexttype: TextInputType.none,
                                prefixicon: Icons.watch_later,
                                validate: (value){
                                  if(value!.isEmpty)
                                    return 'Task time must not be empty';
                                  else
                                    return null;
                                },
                                ontap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value){
                                   todocubitob.tasktimecontroler.text=value!.format(context).toString();
                                  }).catchError((error){
                                    print('error in task time field${error.toString()}');
                                  });
                                }
                            ),

                            SizedBox(height: 15.0,),

                            builddefaulttextformfield(
                                controller: todocubitob.taskdatecontroler,
                                labeltext: 'Task Date',
                                keyboardtexttype: TextInputType.none,
                                prefixicon: Icons.calendar_today_sharp,
                                validate: (value){
                                  if(value!.isEmpty)
                                    return 'Task date must not be empty';
                                  else
                                    return null;
                                },
                                ontap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2025-01-01'),
                                  ).then((value) {
                                    todocubitob.taskdatecontroler.text=DateFormat.yMMMd().format(value!).toString();
                                  }).catchError((error){
                                    print('error in task date item ${error.toString()}');
                                  });
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed
                      .then((value) {
                    todocubitob.changefabicon(
                        icon: Icons.edit,
                        isshown: false);
                  })
                      .catchError((error){
                        print('error when closed bottom sheet${error.toString()}');
                  });
                  todocubitob.changefabicon(
                      icon: Icons.add,
                      isshown: true);
                }

              },
              backgroundColor: defaultcolor(),
              child: Icon(todocubitob.fabicon,),
              heroTag: 'fabiconbutton',
            ) ,
            bottomNavigationBar: BottomNavigationBar(
              items:todocubitob.bottomNavbarItems ,
              backgroundColor: defaultcolor(),
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              currentIndex:todocubitob.bottomNavbarindex ,
              onTap:(index){
                todocubitob.bottomNavbarItemOntap(index);
              },
            ),
            body: todocubitob.screens[todocubitob.bottomNavbarindex],
          );
        },


      ),
    );
  }
}
