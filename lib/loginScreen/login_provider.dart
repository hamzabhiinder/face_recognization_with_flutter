import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  var responseBodies;
  updateIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  updateLoginFucntion(var responseBody) {
    this.responseBodies = responseBody;
    notifyListeners();
  }

  File? _image;

  Future getGalleryImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (pickedImage != null) {
      _image = File(pickedImage.path);
      log("image ${_image?.path}");
      notifyListeners();
      uploadPicture();
    } else {
      log("no picked Image");
    }
  }

  login(
    var body,
  ) async {
    updateIsLoading(true);
    var url = Uri.parse('https://5f5d-182-176-178-62.ngrok-free.app/login');
    var response = await http.post(url, body: body);
    var responseBody = jsonDecode(response.body);
    log("response.statusCode ${response.statusCode}");

    if (response.statusCode == 200) {
      updateIsLoading(false);
      if (responseBody['success']) {
        getGalleryImage();
        updateLoginFucntion(responseBody);
      }
    } else {
      updateIsLoading(false);

      log("ERRROR");
    }
  }

  uploadPicture() async {
    try {
      updateIsLoading(true);

      // Replace the URL with your server endpoint
      var url = Uri.parse('https://5f5d-182-176-178-62.ngrok-free.app/face_match_login');

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
        log('File uploaded successfully!');
        log('message');
        updateIsLoading(false);
      } else {
        log('File upload failed. Status code: ${response.statusCode}');
        updateIsLoading(false);
      }
    } catch (error) {
      log('Error sending file: $error');
      updateIsLoading(false);
    }
  }
}

void nextScreenCupertino(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCupertinowithKey(context, page, navigatorKey) {
  navigatorKey.currentState!.push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void nextScreenReplaceCupertino(context, page) {
  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => page));
}
