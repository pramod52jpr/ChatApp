import 'package:chatapp/my_services.dart';
import 'package:chatapp/ui/auth/login_screen.dart';
import 'package:chatapp/ui/components/message_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("chats");
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final msgController = TextEditingController();
  bool loading = false;

  void myaccount() {
    nameController.text = _auth.currentUser!.displayName ?? "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("My Account"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Your Name"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _auth.currentUser!
                      .updateDisplayName(nameController.text.toString())
                      .then((value) {
                    Navigator.of(context).pop();
                    MyServices().toastmsg("Profile Updated", true);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    MyServices().toastmsg(error.toString(), false);
                  });
                },
                child: Text("Save")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chat App"),
        actions: [
          InkWell(
            onTap: () {
              Future.delayed(
                Duration(seconds: 0),
                () {
                  myaccount();
                },
              );
            },
            child: Icon(
              Icons.account_circle_rounded,
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              _auth.signOut().then((value) {
                MyServices().toastmsg("Logout Successful", true);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
              }).onError((error, stackTrace) {
                MyServices().toastmsg(error.toString(), false);
              });
            },
            child: Icon(
              Icons.logout,
              size: 28,
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Icon(Icons.send_rounded),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              loading = true;
            });
            final id = DateTime.now().microsecondsSinceEpoch.toString();
            ref.child(id).set({
              "id": id,
              "name": _auth.currentUser!.displayName ?? "",
              "email": _auth.currentUser!.email,
              "message": msgController.text.toString()
            }).then((value) {
              setState(() {
                loading = false;
              });
              msgController.text = "";
              MyServices().toastmsg("Message sent", true);
            }).onError((error, stackTrace) {
              setState(() {
                loading = false;
              });
              MyServices().toastmsg(error.toString(), false);
            });
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
            query: ref,
            itemBuilder: (context, snapshot, animation, index) {
              final name = snapshot.child("name").value.toString();
              final email = snapshot.child("email").value.toString();
              final message = snapshot.child("message").value.toString();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MessegeBox(
                    name: _auth.currentUser!.email == email
                        ? "You"
                        : name == ""
                            ? email
                            : name,
                    msg: message,
                    align: _auth.currentUser!.email == email
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    color: _auth.currentUser!.email == email
                        ? Colors.green
                        : Colors.blue,
                    sent: _auth.currentUser!.email == email ? true : false,
                  ),
                ],
              );
            },
          )),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 80, 20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: msgController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please fill any Text";
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Type any Text",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
