import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final picker = ImagePicker();
  File? firstImageFile;
  File? secondImageFile;
  bool isMatching = false;
  File? _imageFile;
  File? _imageFile2;
  List<Rect> rect = <Rect>[];
  bool isFaceDetected = false;

// Compute cosine similarity between the first face in the first image and the first face in the second image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Comparison Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                left: 50,
                right: 50,
              ),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      15), // Add a border radius to the container.
                  color: Colors
                      .grey[300], // Add a background color to the container.
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            15), // Add a border radius to the image.
                        child: Image(
                          image: FileImage(_imageFile!),
                          fit: BoxFit
                              .cover, // Add a fit property to the image to make it cover the container.
                        ),
                      )
                    : Center(
                        child: Text(
                          'No image selected', // Add a message to display if no image is selected.
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
            // Show nothing if no image is selected.
            const SizedBox(
              height: 16,
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 100,
                right: 100,
              ),
              child: InkWell(
                splashColor: const Color.fromARGB(255, 134, 146, 224),
                onTap: (() async {
                  final results = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: false,
                    allowCompression: true,
                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                  );

                  if (results == null) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No File has been picked"),
                    ));
                    return;
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image Uploaded"),
                    ));
                  }
                  // final newName = Timestamp.now();
                  final path = results.files.single.path!;
                  // final fileName = newName.toString();
                  firstImageFile = File(path);
                  // _imageUrl = fileName;
                  // storage.uploadFile(path, fileName);

                  setState(() {
                    _imageFile = File(path);
                    print(_imageFile);
                    // Set the image file to the selected file.
                  });
                }),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xff000028),
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                left: 50,
                right: 50,
              ),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      15), // Add a border radius to the container.
                  color: Colors
                      .grey[300], // Add a background color to the container.
                ),
                child: _imageFile2 != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            15), // Add a border radius to the image.
                        child: Image(
                          image: FileImage(_imageFile2!),
                          fit: BoxFit
                              .cover, // Add a fit property to the image to make it cover the container.
                        ),
                      )
                    : Center(
                        child: Text(
                          'No image selected', // Add a message to display if no image is selected.
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
            // Show nothing if no image is selected.
            const SizedBox(
              height: 16,
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 100,
                right: 100,
              ),
              child: InkWell(
                splashColor: const Color.fromARGB(255, 134, 146, 224),
                onTap: (() async {
                  final results = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: false,
                    allowCompression: true,
                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                  );

                  if (results == null) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No File has been picked"),
                    ));
                    return;
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image Uploaded"),
                    ));
                  }
                  // final newName = Timestamp.now();
                  final path2 = results.files.single.path!;
                  // final fileName = newName.toString();
                  secondImageFile = File(path2);
                  // _imageUrl = fileName;
                  // storage.uploadFile(path, fileName);

                  setState(() {
                    _imageFile2 = File(path2);
                    print(_imageFile2);
                    // Set the image file to the selected file.
                  });
                }),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xff000028),
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: const Text('Compare'),
              onPressed: () async {
                if (firstImageFile != null && secondImageFile != null) {
                  final firstImage =
                      FirebaseVisionImage.fromFile(firstImageFile!);
                  final secondImage =
                      FirebaseVisionImage.fromFile(secondImageFile!);

                  final faceDetector = FirebaseVision.instance.faceDetector();
                  final firstFaces =
                      await faceDetector.processImage(firstImage);
                  final secondFaces =
                      await faceDetector.processImage(secondImage);
                  print(firstFaces);
                  print(secondFaces);
                  final faceEmbedder = FirebaseVision.instance.faceDetector();
                  final firstEmbeddings = await Future.wait(
                    firstFaces
                        .map((face) => faceEmbedder.processImage(firstImage))
                        .toList(),
                  );
                  final secondEmbeddings = await Future.wait(
                    secondFaces
                        .map((face) => faceEmbedder.processImage(secondImage))
                        .toList(),
                  );
                  
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
