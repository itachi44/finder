import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

class NewPostPage extends StatefulWidget {
  final dynamic db;
  NewPostPage({Key key, this.db}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

//icon : file_upload
//TODO resize images : 1080*720
//TODO compress images
class _NewPostPageState extends State<NewPostPage> {
  List<Asset> images = <Asset>[];
  List<Asset> _selectedImages = <Asset>[];
  dynamic _selectedFiles = [];

  @override
  void initState() {
    super.initState();
  }

  showSpinner(BuildContext context, dynamic content) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF162A49)),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 179.2),
              child: Text(content)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getFileFromAsset(String path) {
    final file = File(path);
    return file;
  }

  Future<void> selectImages() async {
    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    try {
      _selectedImages = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Finder App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      for (var asset in _selectedImages) {
        var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
        var file = await getFileFromAsset(path);
        var base64image = base64Encode(file.readAsBytesSync());
        _selectedFiles.add(base64image);
      }
      return _selectedFiles;
    } catch (e) {
      print("Something wrong" + e.toString());
    }
  }

  getImages(context) {
    showSpinner(context, "loading...");
    selectImages().then((_selectedFiles) {
      setState(() {
        _selectedFiles = _selectedFiles;
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedFiles = this._selectedFiles;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a new post",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF162A49),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Upload your post images',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    getImages(context);
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        dashPattern: [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Colors.blue.shade400,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50.withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.image4,
                                color: Colors.blue,
                                size: 40,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Select your images',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                _selectedFiles.length == 0
                    ? const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text("no image selected"),
                      )
                    : Container(
                        height: 100,
                        child: Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GridView.builder(
                              itemCount: 4,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.memory(
                                    (base64Decode(_selectedFiles[index])),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                        )),
                      ),
                Container(
                  height: 100,
                  child: Text("content here"),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
