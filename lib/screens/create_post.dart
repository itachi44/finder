import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:charcode/charcode.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:finder/components/dialog.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

class NewPostPage extends StatefulWidget {
  final dynamic db;
  final dynamic providerId;
  NewPostPage({Key key, this.db, this.providerId}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  List<Asset> images = <Asset>[];
  List<Asset> _selectedImages = <Asset>[];
  dynamic _selectedFiles = [];
  bool houseValue = false;
  bool apartmentValue = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
      //compress images

      for (var asset in _selectedImages) {
        var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
        //var file = await getFileFromAsset(path);
        var _cmpressedFile =
            await FlutterImageCompress.compressWithFile(path, quality: 15);
        var base64image = base64Encode(_cmpressedFile);
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

  _buildCategoryRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width / 37.5),
        child: Row(
          children: [
            Text("House"),
            Checkbox(
              value: houseValue,
              onChanged: (bool value) {
                setState(() {
                  apartmentValue = false;
                  houseValue = value;
                });
              },
            ),
          ],
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height / 54),
      Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.height / 6.25),
        child: Row(
          children: [
            Text("Apartment"),
            Checkbox(
              value: apartmentValue,
              onChanged: (bool value) {
                setState(() {
                  houseValue = false;
                  apartmentValue = value;
                });
              },
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height / 89.6,
            right: MediaQuery.of(context).size.height / 89.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                autofocus: false,
                controller: titleController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height / 40.5,
                ),
                keyboardType: TextInputType.multiline,
                maxLength: 80,
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 90,
                        right: MediaQuery.of(context).size.height / 90,
                        bottom: MediaQuery.of(context).size.height / 25),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: 'Title of your post...'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill this field.";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
      {dynamic controller, String label, dynamic width, String type}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 140),
      child: Container(
        width: width,
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 90,
              right: MediaQuery.of(context).size.height / 90,
              top: 0,
              bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              Container(
                child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 90,
                            right: MediaQuery.of(context).size.height / 90,
                            top: MediaQuery.of(context).size.height / 90,
                            bottom: MediaQuery.of(context).size.height / 90),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: label),
                    validator: type == "price"
                        ? (value) {
                            if (value.isEmpty ||
                                !RegExp(r'^[0-9]+\s?\$$').hasMatch(value)) {
                              return "invalid input!";
                            } else {
                              return null;
                            }
                          }
                        : type == "size"
                            ? (value) {
                                if (value.isEmpty ||
                                    !RegExp(r'[0-9]+\s?m[2²]$')
                                        .hasMatch(value)) {
                                  return "invalid input!";
                                } else {
                                  return null;
                                }
                              }
                            : (value) {
                                if (value.isEmpty) {
                                  return "Please fill this field.";
                                } else {
                                  return null;
                                }
                              }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height / 89.6,
            right: MediaQuery.of(context).size.height / 89.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                controller: descriptionController,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 90,
                        right: MediaQuery.of(context).size.height / 90,
                        bottom: MediaQuery.of(context).size.height / 25),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: 'Write description...'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill this field.";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BouncingWidget(
              duration: Duration(milliseconds: 100),
              scaleFactor: 1.5,
              onPressed: () async {
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    if (_key.currentState.validate()) {
                      if (_selectedFiles.length == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "No images",
                                description:
                                    "You must provide one to four images for your post.",
                                btnText: "Close",
                              );
                            });
                      } else {
                        showSpinner(context, "Creating your post...");
                        //create the post
                        var postQuery = {};
                        //category
                        if (houseValue == true) {
                          postQuery["category"] = "house";
                        } else {
                          postQuery["category"] = "apartment";
                        }
                        //title
                        postQuery["title"] = titleController.text;
                        //country
                        postQuery["country"] = countryController.text;
                        //city
                        postQuery["city"] = cityController.text;
                        //district
                        postQuery["district"] = districtController.text;
                        //price
                        postQuery["price"] =
                            int.parse(priceController.text.split("\$")[0]);
                        //size
                        postQuery["size"] =
                            int.parse(sizeController.text.split("\m")[0]);
                        //description
                        //get the provider Username infos
                        postQuery["description"] = descriptionController.text;
                        var result = await MongoDatabase.createPost(postQuery,
                            _selectedFiles, widget.db, widget.providerId);
                        if (result == "done") {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  color: Colors.green,
                                  title:
                                      "Your post has been succesfully created.",
                                  description:
                                      "We'll be happy to show this to our customer",
                                  btnText: "Close",
                                  pageToGo: "provider_home",
                                  db: widget.db,
                                );
                              });
                        } else {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: "Something wrong",
                                  description: "Try again later.",
                                  btnText: "Close",
                                );
                              });
                        }
                      }
                    } else {
                      //handle input errors
                    }
                  }
                } on SocketException catch (_) {}
              },
              child: MaterialButton(
                onPressed: null,
                color: Colors.blue,
                disabledColor: Colors.blue,
                minWidth: 150,
                height: MediaQuery.of(context).size.height / 16,
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81,
          ),
        ],
      ),
    );
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _selectedFiles = this._selectedFiles;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a new post",
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 50.75,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF162A49),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 54,
                    ),
                    Text(
                      'Upload your post images',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 32.5,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 81,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImages(context);
                      },
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 12.5,
                              vertical:
                                  MediaQuery.of(context).size.height / 81),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10),
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                            color: Colors.blue.shade400,
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 5.5,
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade50.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.image4,
                                    color: Colors.blue,
                                    size: MediaQuery.of(context).size.height /
                                        20.3,
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 54,
                                  ),
                                  Text(
                                    'Select your images',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                54,
                                        color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    _selectedFiles.length == 0
                        ? const Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text("no image selected"),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height / 8,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height /
                                          101.5),
                                  child: GridView.builder(
                                      itemCount: _selectedFiles.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  406),
                                          child: Image.memory(
                                            (base64Decode(
                                                _selectedFiles[index])),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                )),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 81,
                    ),
                    Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text("Category ",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                  fontWeight: FontWeight.w600,
                                )),
                            _buildCategoryRow(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 81,
                            ),
                            Text("Title  ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )),
                            _buildTitleRow(),
                            Text("Location ",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                  fontWeight: FontWeight.w600,
                                )),
                            Column(
                              children: [
                                Row(children: <Widget>[
                                  _buildRow(
                                      controller: countryController,
                                      label: "Country",
                                      width: MediaQuery.of(context).size.width *
                                          0.4),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                  _buildRow(
                                      controller: cityController,
                                      label: "City",
                                      width: MediaQuery.of(context).size.width *
                                          0.4)
                                ]),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildRow(
                                    controller: districtController,
                                    label: "District",
                                    width:
                                        MediaQuery.of(context).size.width * 0.8)
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 81,
                            ),
                            Text("Price and size",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                  fontWeight: FontWeight.w600,
                                )),
                            Column(
                              children: [
                                Row(children: <Widget>[
                                  _buildRow(
                                      controller: priceController,
                                      label: "1000 \$",
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      type: "price"),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                  _buildRow(
                                      controller: sizeController,
                                      label:
                                          "500 m" + String.fromCharCode($sup2),
                                      width: MediaQuery.of(context).size.width *
                                          0.4)
                                ]),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 81,
                            ),
                            Text("Description",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                  fontWeight: FontWeight.w600,
                                )),
                            _buildDescriptionRow(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 81,
                            ),
                            _buildPostButton()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
