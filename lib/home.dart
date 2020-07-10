import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:aplikasi_diary/form_input_update.dart';
import 'package:aplikasi_diary/model/diary.dart';
import 'package:aplikasi_diary/db_helper/database_helper.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  static var today = new DateTime.now();
  var formatedTanggal = new DateFormat.yMMMd().format(today);

  DatabaseHelper dbHelper = DatabaseHelper();
  int count = 0;
  List<Diary> diaryList;   

  @override
  Widget build(BuildContext context) {
    if (diaryList == null) {
      diaryList = List<Diary>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15.0, left:10.0, right:10.0),
        decoration: new BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1534040385115-33dcb3acba5b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80'),
            fit: BoxFit.cover,
          ),
        ),
        child : createListView(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () async {
          var diary = await navigateToFormInputUpdate(context, null);
          if (diary != null) addDiary(diary);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40,
          color: Colors.blue[700],
          alignment: Alignment.center,
          child: Text(
            'UAS Pemrograman Mobile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<Diary> navigateToFormInputUpdate(BuildContext context, Diary diary) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FormInputUpdate(diary);
        }
      ) 
    );
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset('images/calista-tee-gizUZzz4HPI-unsplash.jpg',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(formatedTanggal.toString()),
            subtitle: Text(this.diaryList[index].name, style: textStyle,),
            trailing: GestureDetector(
              child: FlatButton(
                color: Colors.white,
                padding: EdgeInsets.only(left: 30, top:5, bottom:10),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Theme(
                        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                        child: AlertDialog(
                          title: Text("Peringatan!"),
                          content: Text("Anda yakin ingin menghapus data ini?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Iya",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                deleteDiary(diaryList[index]);
                              },
                            ),
                            FlatButton(
                              child: Text("Tidak",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    });
                },
                child: Icon(
                Icons.delete,
                color: Colors.red
              ),
              ), 
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Theme(
                    data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                    child: AlertDialog(
                      title: Text(this.diaryList[index].name, style: textStyle,),
                      content: Text(this.diaryList[index].catatanisi),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Edit",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                          ),
                          onPressed: () async {
                            var diary = await navigateToFormInputUpdate(context, this.diaryList[index]);
                            if (diary != null) editDiary(diary);
                          },
                        ),
                        FlatButton(
                          child: Text("Kembali",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                });
            }
          ),
        );
      },
    );
  }

  //Input/Tambah diary
  void addDiary(Diary object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }
    //Edit diary
  void editDiary(Diary object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      updateListView();
    }
  }
    //Hapus diary
  void deleteDiary(Diary object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }
    //Update diary
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Diary>> diaryListFuture = dbHelper.getDiaryList();
      diaryListFuture.then((diaryList) {
        setState(() {
          this.diaryList = diaryList;
          this.count = diaryList.length;
        });
      });
    });
  }
}