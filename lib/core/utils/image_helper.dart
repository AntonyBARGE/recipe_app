// import 'dart:io';

// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as path_provider;

// class ImageHelper {
//   static String? appDocPath;

//   static Future<String> downloadImageFromurl(String url) async {
//     final response = await http.get(Uri.parse(url));
//     // Get the image name
//     final imageName = path.basename(url);
//     // Get the document directory path
//     final appDir = await path_provider.getApplicationDocumentsDirectory();
//     // This is the saved image path
//     // You can use it to display the saved image later
//     final localPath = path.join(appDir.path, imageName);
//     // Downloading
//     final imageFile = File(localPath);
//     await imageFile.writeAsBytes(response.bodyBytes);
//     return imageName;
//   }

//   static Future<String?> storeImageLocally(File imageFile) async {
//     final appDir = await path_provider.getApplicationDocumentsDirectory();
//     final fileName = path.basename(imageFile.path);
//     await FlutterImageCompress.compressAndGetFile(
//       imageFile.absolute.path,
//       '${appDir.path}/$fileName',
//       quality: 60,
//       minWidth: 1000,
//     );
//     return fileName;
//   }

//   static void initAppDocPath() async {
//     appDocPath = (await path_provider.getApplicationDocumentsDirectory()).path;
//   }

//   static String getFullImagePath(String imageName) {
//     if (appDocPath != null) {
//       return path.join(appDocPath!, imageName);
//     }
//     return '';
//   }
// }
