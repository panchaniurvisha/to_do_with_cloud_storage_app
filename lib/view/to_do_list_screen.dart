import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_cloud_storage_app/res/common/media_query.dart';
import 'package:to_do_with_cloud_storage_app/res/constant/app_string.dart';
import 'package:to_do_with_cloud_storage_app/view/add_edit_task_screen.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("tasks");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            AppString.title,
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_month_outlined))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Document does not exist"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: height(context) / 40,
              ),
              padding: EdgeInsets.symmetric(horizontal: width(context) / 20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                DocumentSnapshot taskSnapshot = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(data["task"]),
                  trailing: PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 10),
                            Text("Edit")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                          value: 65,
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 10),
                              Text("Delete")
                            ],
                          ),
                          onTap: () => setState(() {
                                deleteUser(taskSnapshot.id);
                              })),
                    ],
                    offset: const Offset(100, 40),
                    color: Colors.grey,
                    elevation: 10,
                    onSelected: (value) {
                      if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditTaskScreen(
                                    index: index,
                                    taskData: data))).then((value) {
                          setState(() {});
                        });
                      }
                      debugPrint(value.toString());
                    },
                  ),
                  subtitle: Text(data["addTaskTag"] + "" + data["description"]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width(context) / 20),
                      side: const BorderSide(color: Colors.black)),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width(context) / 10),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEditTaskScreen())),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_list), label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.tag,
              ),
              label: "")
        ]));
  }

  editData() {}
  Future<void> deleteUser(String taskId) {
    return users
        .doc(taskId)
        .delete()
        .then((value) => debugPrint("User Deleted"))
        .catchError((error) => debugPrint("Failed to delete user: $error"));
  }
}
