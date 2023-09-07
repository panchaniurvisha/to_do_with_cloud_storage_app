import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_cloud_storage_app/res/common/app_text_field.dart';
import 'package:to_do_with_cloud_storage_app/res/common/media_query.dart';
import 'package:to_do_with_cloud_storage_app/res/constant/app_string.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController taskTagController = TextEditingController();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppString.appBarTitle),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) / 20),
          child: Column(
            children: [
              AppTextField(
                  icon: const Icon(CupertinoIcons.square_list),
                  controller: taskNameController,
                  hintText: AppString.task),
              AppTextField(
                icon: const Icon(CupertinoIcons.bubble_left_bubble_right),
                controller: descriptionController,
                hintText: AppString.description,
              ),
              AppTextField(
                icon: const Icon(CupertinoIcons.tag),
                controller: taskTagController,
                hintText: AppString.taskTag,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.amberAccent,
                        ),
                      ),
                      child: const Text(AppString.cancel)),
                  ElevatedButton(
                      onPressed: () {
                        createUserData();
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      child: const Text(AppString.save))
                ],
              ),
            ],
          ),
        ));
  }

  createUserData() {
    CollectionReference users = firebaseFireStore.collection("tasks");
    users
        .add({
          "task": taskNameController.text,
          "description": descriptionController.text,
          "addTaskTag": taskTagController.text,
        })
        .then((value) => debugPrint("User Added---->${value.get()}"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
    Navigator.pop(context);
  }
}
