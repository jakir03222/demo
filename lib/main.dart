// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class ImageProvider with ChangeNotifier {
//   File? _image;

//   File? get image => _image;

//   void setImage(File? newImage) {
//     _image = newImage;
//     notifyListeners();
//   }

//   Future<void> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: source);
//     if (pickedImage != null) {
//       setImage(File(pickedImage.path));
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ImageProvider(),
//       child: MaterialApp(
//         title: 'Image Picker Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker Demo'),
//       ),
//       body: Center(
//         child: Consumer<ImageProvider>(
//           builder: (context, imageProvider, _) {
//             final image = imageProvider.image;
//             String imagePath =
//                 image != null ? _formatImageName(image.path) : '';
//             return ListView(
//               children: <Widget>[
//                 if (image != null) ...[
//                   Image.file(image),
//                   SizedBox(height: 20),
//                   Text('Image Path: $imagePath'), // Display compact image path
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       imageProvider.setImage(null);
//                     },
//                     child: Text('Clear Image'),
//                   ),
//                 ] else ...[
//                   Text('No image selected'),
//                 ],
//               ],
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) {
//               return Container(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         Provider.of<ImageProvider>(context, listen: false)
//                             .pickImage(ImageSource.gallery);
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('Pick from Gallery'),
//                     ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         Provider.of<ImageProvider>(context, listen: false)
//                             .pickImage(ImageSource.camera);
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('Take a Picture'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   String _formatImageName(String path) {
//     List<String> parts = path.split('/');
//     String fileNameWithExtension = parts.isNotEmpty ? parts.last : '';
//     // Check if the file name already has an extension
//     if (!fileNameWithExtension.contains('.')) {
//       // Append '.jpg' extension if it doesn't have one
//       fileNameWithExtension += '.jpg';
//     }
//     return fileNameWithExtension;
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageSelectionScreen extends StatefulWidget {
  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  File? _imageFile1;
  File? _imageFile2;
  final picker = ImagePicker();

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _imageFile1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _imageFile2 = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _saveDataAndUploadImages() async {
    // Validate if both images are selected
    if (_imageFile1 == null || _imageFile2 == null) {
      print('Both images are required');
      return;
    }

    // Replace 'your_api_endpoint_here' with your actual API endpoint URL
    final url = Uri.parse('https://aparajitabd.com/api/banner-logo');

    // Replace 'your_token_here' with your actual API token

    // Example data
    final name = '01722622322';
    final roll = 'Nagad personal';
    final department = 'Computer Science';

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] =
          'Bearer 548|bVYhBuHaXfWyBHmiKdMBTx1F1qgbNyibaf6LG0US99c91aef'; // Include token in header

      request.fields['bkash_number'] = name;
      request.fields['payment_type'] = roll;
      request.fields['pick_up_address'] = department;

      request.files.add(
        await http.MultipartFile.fromPath(
          'logo',
          _imageFile1!.path,
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'banner',
          _imageFile2!.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Handle redirection
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          // Make another request to the redirected URL
          final redirectedResponse = await http.post(Uri.parse(redirectUrl));
          // Process redirectedResponse as needed
          print('Redirected response: ${redirectedResponse.statusCode}');
        } else {
          print('Redirection URL not found');
        }
      } else if (response.statusCode == 200) {
        // Parse response data if needed
        final responseData = json.decode(response.body);
        // Process responseData as needed
        print('API response: $responseData');
        print('Images uploaded successfully');
      } else {
        print('Failed to upload images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile1 != null
                ? Image.file(
                    _imageFile1!,
                    width: 200,
                    height: 200,
                  )
                : Text('Select Image 1'),
            ElevatedButton(
              onPressed: () => _pickImage(1),
              child: Text('Pick Image 1'),
            ),
            SizedBox(height: 20),
            _imageFile2 != null
                ? Image.file(
                    _imageFile2!,
                    width: 200,
                    height: 200,
                  )
                : Text('Select Image 2'),
            ElevatedButton(
              onPressed: () => _pickImage(2),
              child: Text('Pick Image 2'),
            ),
            ElevatedButton(
              onPressed: _saveDataAndUploadImages,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageSelectionScreen(),
  ));
}
