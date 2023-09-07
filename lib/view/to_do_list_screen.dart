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
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: height(context) / 40,
              ),
              padding: EdgeInsets.symmetric(horizontal: width(context) / 20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(data["task"]),
                  trailing: Text(data["description"]),
                  subtitle: Text(data["addTaskTag"]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width(context) / 20),
                      side: BorderSide(color: Colors.black)),
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
}
