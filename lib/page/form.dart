import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'uploadimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:komikin/database/database_services.dart';

import 'homepage.dart';

class Addkomik extends StatefulWidget {
  @override
  _AddkomikState createState() => _AddkomikState();
}

class _AddkomikState extends State<Addkomik> {
  String imagePath;
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  File _imageFile;

  List<File> _image = [];
  final picker = ImagePicker();
  TextEditingController judul = TextEditingController();
  TextEditingController genre = TextEditingController();

  var komikcollections = FirebaseFirestore.instance.collection('komik');
  List allkomik = [];
  Future<void> getkomik() async {
    await komikcollections.get().then((result) => {
          result.docs.forEach((element) {
            print(element.data());
            allkomik.add(element);
          })
        });
    setState(() {});
    return;
  }

  @override
  initState() {
    getkomik();
    setState(() {});
    super.initState();
    return;
  }

  Future<void> _addkomik({String judul, String genre, File image}) async {
    // String ImageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = image.path;
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('Images').child(fileName);
    final UploadTask uploadtask = storageReference.putFile(image);
    String imageUrl = await (await uploadtask).ref.getDownloadURL();

    await komikcollections.add({
      'judul': judul,
      'genre': genre,
      'image': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference komik = firestore.collection('komik');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: judul,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                TextField(
                  controller: genre,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                if (_imageFile != null) Image.file(_imageFile, height: 200),
                IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () async {
                      PickedFile pickedfile =
                          await picker.getImage(source: ImageSource.gallery);

                      setState(() {
                        _imageFile = File(pickedfile.path);
                      });
                    }),
                RaisedButton(
                  child: Text('Add Data'),
                  onPressed: () async {
                    await _addkomik(
                      judul: judul.text,
                      genre: genre.text,
                      image: _imageFile,
                    ).whenComplete(() => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        )));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // chooseImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image.add(File(pickedFile?.path));
  //   });
  //   if (pickedFile.path == null) retrieveLostData();
  // }

  // Future<void> retrieveLostData() async {
  //   final LostData response = await picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       _image.add(File(response.file.path));
  //     });
  //   } else {
  //     print(response.file);
  //   }
  // }

  // Future uploadFile() async {
  //   int i = 1;

  //   for (var img in _image) {
  //     setState(() {
  //       val = i / _image.length;
  //     });
  //     ref = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('images/${Path.basename(img.path)}');
  //     await ref.putFile(img).whenComplete(() async {
  //       await ref.getDownloadURL().then((value) {
  //         imgRef.add({'url': value});
  //         i++;
  //       });
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   imgRef = FirebaseFirestore.instance.collection('imageURLs');
  // }
}
