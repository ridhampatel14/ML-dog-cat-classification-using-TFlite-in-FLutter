import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ML APP DOG-CAT',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? imageFile;
  List? _output;
  imagefromgal() async{
    var pickedImage =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage==null) return null;
    setState(() {
      imageFile=File(pickedImage.path);
    });
    runModelOnImage(imageFile);
  }

  loadMlModel() async{
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
    );
  }

  runModelOnImage(File? image) async{
    var output= await Tflite.runModelOnImage(
        path:image!.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5
    );
    setState(() {
      _output=output;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMlModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Application'),
        centerTitle: true,
        backgroundColor:Colors.red,
      ),
      body: SizedBox(
        width: double.infinity,
        child:Column(
          children: [
            SizedBox(height: 40,),
            _output==null? const Text(" "):
            Text(
              '${_output![0]['label']}'.substring(2),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40,),
            imageFile==null ? const Text('select the image') :Image.file(imageFile!, width: 500, height: 500,),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: () {
                imagefromgal();
              },
              child:const Text('click on me'),
            ),
          ],
        ),
      ),
    );
  }
}


