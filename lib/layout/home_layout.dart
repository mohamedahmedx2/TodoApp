import 'package:bottom_navigation_bar/modules/modules.archived_tasks/archive_tasks.dart';
import 'package:bottom_navigation_bar/modules/modules.done_tasks/done_tasks_screen.dart';
import 'package:bottom_navigation_bar/shared/cubit/cubit.dart';
import 'package:bottom_navigation_bar/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/modules.new_tasks/new_tasks_screen.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';

class HomeLay extends StatelessWidget {
  HomeLay({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          //   var cubit2 = defaultFormField();
          AppCubit cubit1 = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit1.title[AppCubit.get(context).current],
              ),
            ),
            body: ConditionalBuilder(
              builder: (context) => cubit1.screen[cubit1.current],
              condition: state is! AppGetDatabaseLoadingState,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit1.theBottom) {
                  if (formKey.currentState!.validate()) {
                    cubit1.insertToDataBase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);

                    // insertToDataBase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   Navigator.pop(context);
                    //   theBottom = false;
                    //   // setState(() {
                    //   //   fabIcon = Icons.edit;
                    //   // });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  control1: titleController,
                                  prefix1: Icons.title,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "time must not be empty";
                                    }
                                    return null;
                                  },
                                  label1: "Task Title",
                                  type: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  control1: timeController,
                                  prefix1: Icons.watch_later_rounded,
                                  type: TextInputType.datetime,
                                  label1: "Task Time",
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "time must not be empty";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  control1: dateController,
                                  prefix1: Icons.calendar_today,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2024-08-01"),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "time must not be empty";
                                    }
                                    return null;
                                  },
                                  label1: "Task Date",
                                  type: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) => {
                            cubit1.changeBottomSheetState(
                                isShow: false, icon: Icons.edit)
                          });

                  cubit1.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit1.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit1.current,
              onTap: (index) {
                cubit1.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived")
              ],
            ),
          );
        },
      ),
    );
  }
}
