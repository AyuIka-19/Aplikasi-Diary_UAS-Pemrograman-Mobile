import 'package:flutter/material.dart';
import 'package:aplikasi_diary/model/diary.dart';


class FormInputUpdate extends StatefulWidget {
  final Diary diary;

  FormInputUpdate(this.diary);

  @override
  FormInputUpdateState createState() => FormInputUpdateState(this.diary);
}

class FormInputUpdateState extends State<FormInputUpdate> {
  Diary diary;

  FormInputUpdateState(this.diary);

  TextEditingController nameController = TextEditingController();
  TextEditingController catatanisiController = TextEditingController();  

  @override
  Widget build(BuildContext context) {
    if (diary != null) {
      nameController.text = diary.name;
      catatanisiController.text = diary.catatanisi;
    }

    return Scaffold(
      appBar: AppBar(
        title: diary == null ? Text('Tambah Diary') : Text('Ubah Diary'),
        leading: Icon(Icons.arrow_back),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15.0, left:10.0, right:10.0),
        decoration: new BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1594103291218-4c227e912831?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: <Widget> [
            Padding (
              padding: EdgeInsets.only(top:20.0, bottom:20.0),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(color: Colors.black),            
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {                  
                  //                                                    
                },
              ),
            ),

            Padding (
              padding: EdgeInsets.only(top:20.0, bottom:20.0),
              child: TextField(
                controller: catatanisiController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Dear Diary',
                  labelStyle: TextStyle(color: Colors.black),                
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {                  
                  //
                },
              ),
            ),

            Padding (
              padding: EdgeInsets.only(top:20.0, bottom:20.0),
              child: Row(
                children: <Widget> [
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Simpan',
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (diary == null) {
                          diary = Diary(nameController.text, catatanisiController.text);
                        } else {
                          diary.name = nameController.text;
                          diary.catatanisi = catatanisiController.text;
                        }
                        Navigator.pop(context, diary);
                      },
                    ),
                  ),
                  Container(width: 5.0,),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Batal',
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}