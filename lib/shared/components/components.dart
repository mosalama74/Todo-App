import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoappv2/shared/components/cubit/todocubit.dart';

Widget builddefaulttext({
  required String text,
  Color? textcolor,
  double fontsize = 20.0,
  FontWeight? fontweight,
  TextOverflow? textoverflow,
  int? maxlines,
  bool isuppercase = false,

}) =>
    Text(
      isuppercase ? text.toUpperCase() : text,
      style: TextStyle(
        color: textcolor,
        fontSize: fontsize,
        fontWeight: fontweight,
        overflow: textoverflow,
      ),
      maxLines: maxlines,
    );

Widget builddefaulttextformfield({
  required TextEditingController? controller,
  required String labeltext,
  required TextInputType? keyboardtexttype,
  void Function(String)? onchanged,
  void Function(String)? onfieldsubmitted,
  void Function()? onpressedsuffixicon,
  required IconData prefixicon,
  required String? Function(String?)? validate,
  void Function()? ontap,
  bool ispassword = false,
  String? hinttext,
  IconData? suffixicon,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labeltext,
        hintText: hinttext,
        prefixIcon: Icon(
          prefixicon,
        ),
        suffixIcon: IconButton(
          onPressed: onpressedsuffixicon,
          icon: Icon(
            suffixicon,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onTap: ontap,
      keyboardType: keyboardtexttype,
      onChanged: onchanged,
      validator: validate,
      onFieldSubmitted: onfieldsubmitted,
      obscureText: ispassword ? true : false,
    );

Widget builddefaultmaterialbutton({
  double width = double.infinity,
  Color? backgroundcolor = Colors.red,
  double radius = 30.0,
  double height = 40.0,
  required Widget child,
  required void Function()? onPressedbuttonfunction,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: onPressedbuttonfunction,
        child: child,
        height: height,

      ),
    );

Widget builddefaultseparator() =>
    Padding(
      padding: EdgeInsetsDirectional.only(start: 15.0),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        height: 1.0,
      ),
    );

Widget buildTaskScreenItem(Map model, context) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(

        padding: const EdgeInsetsDirectional.all(15.0),

        child: Row(

          children: [

            CircleAvatar(

              backgroundColor: Colors.red[300],

              radius: 40.0,

              child: builddefaulttext(text: '${model['time']}',

                fontsize: 18.0,

                textcolor: Colors.white,

                fontweight: FontWeight.w400,


              ),

            ),

            SizedBox(width: 5.0,),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [

                  builddefaulttext(
                    text: '${model['title']}',

                    fontsize: 20.0,

                    textcolor: Colors.black,

                    fontweight: FontWeight.w400,

                    maxlines: 1,

                    textoverflow: TextOverflow.ellipsis,),

                  SizedBox(height: 5.0,),

                  builddefaulttext(text: '${model['date']}',

                    fontsize: 18.0,

                    textcolor: Colors.grey,

                    fontweight: FontWeight.w400,

                  ),

                ],

              ),

            ),

            IconButton(

              onPressed: () {
                TodoCubit.get(context).updatedatabase(

                    status: 'done', id: model['id']);
              },

              icon: Icon(

                Icons.check_box,

              ),

              color: Colors.green,

            ),

            IconButton(

              onPressed: () {
                TodoCubit.get(context).updatedatabase(

                    status: 'archived', id: model['id']);
              },

              icon: Icon(

                Icons.archive_outlined,

              ),

              color: Colors.grey,

            ),


          ],

        ),

      ),
      onDismissed: (direction) {
        TodoCubit.get(context).daletedatabase(id: model['id']);
      },

    );

Widget buildconditionalitem({
  required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length>0,
  builder:(context) => ListView.separated(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => buildTaskScreenItem(tasks[index],context),
      separatorBuilder: (context, index) => builddefaultseparator(),
      itemCount: tasks.length),
  fallback:(context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 80.0,
          color: Colors.grey[400],
        ),
        builddefaulttext(text: 'No Tasks Founded , Please Insert Tasks',
          textcolor: Colors.grey,
        ),
      ],
    ),
  ) ,

);

