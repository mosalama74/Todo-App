import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoappv2/shared/components/cubit/todocubit.dart';
import 'package:todoappv2/shared/components/cubit/todostates.dart';
import '../shared/components/components.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TodoCubit todocubitob= TodoCubit.get(context);
        var tasks=todocubitob.newtasks;

        return buildconditionalitem(tasks: tasks);
      },
    );
  }
}
