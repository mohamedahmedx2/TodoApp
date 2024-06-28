import 'dart:js';

import 'package:bloc/bloc.dart';
import 'package:bottom_navigation_bar/shared/bloc_observer.dart';
import 'package:bottom_navigation_bar/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

import 'layout/home_layout.dart';

main() {

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
  AppCubit.get(context).nn();
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLay(),
    );
  }
}
