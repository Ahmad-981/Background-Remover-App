import 'dart:io';
import 'dart:typed_data';
import 'package:before_after/before_after.dart';
import 'package:background_remover/bg_remover_API.dart';
import 'package:flutter/material.dart';
import 'package:background_remover/dashed_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var loaded = false;
  var removedBg = false;
  var isLoading = false;

  Uint8List? image;
  String imagePath = '';
  ScreenshotController screenshotController = ScreenshotController();

  pickImage() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (img != null) {
      setState(() {});
      imagePath = img.path;
      loaded = true;
    } else {
      //Do Nothing
    }
  }

  // takeScreenshot() async {
  //   var perm = await Permission.storage.request();
  //   var filename = "${DateTime.now().millisecondsSinceEpoch}.png";

  //   if (perm.isGranted) {
  //     final directory = Directory("Internal storage/Download/");
  //     if (!await directory.exists()) {
  //       await directory.create(recursive: true);
  //     }
  //     await screenshotController.captureAndSave(directory.path,
  //         delay: Duration(milliseconds: 100),
  //         fileName: filename,
  //         pixelRatio: 1.0);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Downloaded Successfully")));
  //     print('Success\n'); // Uncommented for debugging
  //   } else {
  //     print("Failed\n"); // Uncommented for debugging
  //   }

  //   // if (perm.isGranted) {
  //   //   final directory = Directory("Internal storage/Download/");
  //   //   if (!await directory.exists()) {
  //   //     await directory.create(recursive: true);
  //   //   }
  //   //   await screenshotController.captureAndSave(directory.path,
  //   //       delay: Duration(milliseconds: 100),
  //   //       fileName: filename,
  //   //       pixelRatio: 1.0);
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //       const SnackBar(content: Text("Downloaded Successfully")));
  //   //   // print('Success\n');
  //   // } else {
  //   //   // print("Failed\n");
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //takeScreenshot();
              },
              icon: const Icon(Icons.download))
        ],
        elevation: 10,
        centerTitle: true,
        leading: const Icon(Icons.short_text_rounded),
        title: const Text(
          'Background Remover',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: removedBg
            ? BeforeAfter(
                before: Image.file(File(imagePath)),
                after: Screenshot(
                    controller: screenshotController,
                    child: Image.memory(image!)))
            : loaded
                ? GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Image.file(File(imagePath)),
                  )
                : DashedBorder(
                    color: Colors.grey,
                    radius: 10,
                    padding: EdgeInsets.all(60),
                    child: ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text("Remove Background"))),
      ),
      bottomNavigationBar: SizedBox(
          height: 60,
          child: ElevatedButton(
              onPressed: loaded
                  ? () async {
                      setState(() {
                        isLoading = true;
                      });
                      image = await Api.removeBG(imagePath);
                      if (image != null) {
                        removedBg = true;
                        isLoading = false;
                        setState(() {});
                      }
                    }
                  : null,
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Text("Remove Background"))),
    ));
  }
}
