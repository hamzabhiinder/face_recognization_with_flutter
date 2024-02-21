import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  login(var body) async {
    var url = Uri.parse('https://938b-39-39-9-136.ngrok-free.app/upload');
    var response = await http.post(url, body: body);
    var responseBody = jsonDecode(response.body);
    log("response.statusCode ${response.statusCode}");

    if (response.statusCode == 200) {
      log("DATA ${responseBody}");
    } else {
      login("ERRROR");
    }
  }

  uploadMethod() async {
    try {
      // Replace the URL with your server endpoint
      var url = Uri.parse('https://938b-39-39-9-136.ngrok-free.app/upload');

      var request = http.MultipartRequest('POST', url);

      // Replace 'file' with the field name that your server expects
      var file = await http.MultipartFile.fromPath('file', _image!.path);

      // Add other fields or headers if needed
      request.fields['cnic'] = '4220165821659';

      request.files.add(file);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseContent = await http.Response.fromStream(response);
        log('Response: ${responseContent.body}');
        print('File uploaded successfully!');
        log('message');
      } else {
        print('File upload failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending file: $error');
    }
  }

  File? _image;

  Future getGalleryImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        log("image ${_image?.path}");
      } else {
        log("no picked Image");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  getGalleryImage();
                },
                child: Text("Pick image")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  // login({
                  //   'cnic': '4220142267605',
                  //   'file': _image?.path.toString()
                  // });
                  uploadMethod();
                },
                child: Text("Add Request")),
          ),
        ],
      ),
    );
  }
}
