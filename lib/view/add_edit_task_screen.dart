import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_cloud_storage_app/res/common/app_text_field.dart';
import 'package:to_do_with_cloud_storage_app/res/common/media_query.dart';
import 'package:to_do_with_cloud_storage_app/res/constant/app_string.dart';

class AddEditTaskScreen extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? taskData;

  const AddEditTaskScreen({super.key, this.index, this.taskData});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController taskTagController = TextEditingController();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.taskData != null && widget.index != null) {
      taskNameController.text = widget.taskData!["task"] ?? "";
      descriptionController.text = widget.taskData!["description"] ?? "";
      taskTagController.text = widget.taskData!["addTaskTag"] ?? "";
    }
    super.initState();
  }

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
                        if (widget.index != null) {
                          debugPrint("------------------>${widget.index}");

                          // editData();
                        } else {
                          createUserData();
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      child: Text(widget.index == null
                          ? AppString.addToDo
                          : AppString.editToDo))
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

  /*editData() {
    final task = taskNameController.text;
    final description = descriptionController.text;
    final addTaskTag = taskTagController.text;
    if (widget.taskData!.isEmpty || widget.index == null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Task data is missing or invalid."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
    final taskData = {
      "task": task,
      "description": description,
      "addTaskTag": addTaskTag,
    };
    final documentId = widget.taskData!["documentId"];
    if (documentId != null) {
      FirebaseFirestore.instance
          .collection("tasks")
          .doc(documentId)
          .update(taskData)
          .then((value) {
        // Update successful
        debugPrint("User updated");
        Navigator.pop(context);
      }).catchError((error) {
        debugPrint("Failed to update task: $error");
      });
    } else {}
  }*/
}
