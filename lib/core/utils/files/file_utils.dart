import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FileUtil {
  static Future<File> getImage(ImageSource imageSource, {int quality = 25}) async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: imageSource,imageQuality: quality);
      if (image != null) {
        return File(image.path);
      } else {
        return Future.error('Error picking image');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
 static String? encodeToBase64(File? file) {
    if (file != null) {
      String pre='data:image/${file.path.split('.').last};base64,';

      List<int> imageBytes = file.readAsBytesSync();
      return pre+base64Encode(imageBytes);
    }
    return null;
  }
}
