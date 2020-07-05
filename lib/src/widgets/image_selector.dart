import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  Map<String, String> images = Map();

  @override
  createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File _image;

  @override
  initState() {
    super.initState();
    if (widget.images == null) {
      widget.images = Map();
    }
  }

  @override
  build(context) => ConstrainedBox(
    constraints: BoxConstraints.expand(height: 150),
    child: Stack(
      overflow: Overflow.visible,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: Colors.grey.shade200,
              child: widget.images.length == 0
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                      Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                      Icon(Icons.image),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                      ),
                      Text("No Images Selected!",style: TextStyle(fontWeight: FontWeight.w400)),
                ],
              ),
                  Text("(Images must be less than 2mb!)",style: TextStyle(color: Colors.grey)),
                ],
                  )
                  : ListView.builder(
                itemCount: widget.images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) => GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete image?"),
                          actions: [
                            FlatButton(
                              onPressed: () => setState(() {
                                widget.images.remove(widget
                                    .images.keys
                                    .elementAt(i));
                                Navigator.of(context).pop();
                              }),
                              child: Text("Yes"),
                            ),
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(),
                              child: Text("No"),
                            )
                          ],
                        ));
                  },
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.file(
                      File(widget.images.values.elementAt(i)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
        ),
        Positioned(
          left: 0,
          bottom: -15,
          child: FlatButton(
            color: Colors.blue,
            child: Icon(Icons.camera_alt),
            onPressed: () async {
            File capturedImage = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 35);
            print(capturedImage.lengthSync());
            if(capturedImage.lengthSync() > 2000000){
              print("Image size must be less than 2 mb");
              return;
            }

            Map<String, String> tempImages = {'${DateTime.now().toIso8601String()}' : capturedImage.path};

            if(mounted){
              setState(() {
                widget.images.addAll(tempImages);
              });
            }
            },
            padding: EdgeInsets.all(8),
            shape: CircleBorder(),
          ),
        ),
        Positioned(
          left: 55,
          bottom: -15,
          child: FlatButton(
            padding: EdgeInsets.all(8),
            shape: CircleBorder(),
            color: Colors.primaries[0],
            onPressed: () async {
              Map<String, String> tempImages;
              try {
                tempImages = await FilePicker.getMultiFilePath(
                    type: FileType.IMAGE, fileExtension: '',);
              } on PlatformException catch (e) {
                // Message Display.
              }
              if(mounted){
                print(tempImages);
                for(var i = 0; i < tempImages.values.length; i++){
                File img =  File(tempImages.values.elementAt(i));

                if(img.lengthSync() > 2000000){
                  tempImages.remove(tempImages.keys.elementAt(i));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Image size must be less than 2 mb. Please try compressing the image or capture image from top camera.'),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
                }

              setState(() {
                  widget.images.addAll(tempImages);
                });
              }
            },
            child: Icon(
              Icons.photo_library,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
