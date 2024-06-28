import 'package:bottom_navigation_bar/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget defaultFormField({
  required TextEditingController control1,
  TextInputType? type,
  required String? Function(String?) validate,
  required String label1,
  TextStyle? labelStyle2,
  required IconData prefix1,
  IconData? suffix2,
  Function? onTap,
  String? Function(String?)? functionOnSub2,
  String? Function(String?)? functionOnCh3,
  bool scureText = false,
  Function? suffixPressed,
  TextInputFormatter?  format,
}) =>
    TextFormField(
    //  inputFormatters:,
        obscureText: scureText,
        controller: control1,
        keyboardType: type,
        onFieldSubmitted: (s) {
          functionOnSub2!(s);
        },
        onChanged: (f) {
          functionOnCh3!(f);
        },
        validator: validate,
        decoration: InputDecoration(
          labelText: label1,
          labelStyle: labelStyle2,
          prefixIcon: Icon(
            prefix1,
          ),
          suffixIcon: suffix2 != null
              ? IconButton(
                  onPressed: () {
                    suffixPressed!();
                  },
                  icon: Icon(
                    suffix2,
                  ),
                )
              : null,
          border: const OutlineInputBorder(),
        ),
        onTap: () {
          onTap!();
        });

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  direction: DismissDirection.startToEnd,

  child:   Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                "${model["time"]}",
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model["title"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${model["date"]}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archived',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
);


Widget tasksBuilder({
  required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  fallback:(context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 90,
        ),
        Text(
          "No Tasks Yet, Please Ads Some Tasks",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ) ,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context,index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    ),
    itemCount:tasks.length,
  ),

);