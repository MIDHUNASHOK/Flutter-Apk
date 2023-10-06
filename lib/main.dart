import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart'; // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyWebViewPage(),
    );
  }
}

class MyWebViewPage extends StatefulWidget {
  const MyWebViewPage({Key? key}) : super(key: key);

  @override
  _MyWebViewPageState createState() => _MyWebViewPageState();
}

class _MyWebViewPageState extends State<MyWebViewPage> {
  late WebViewController _webViewController;
  bool isExternalUrl = false;

  // Function to handle file selection
  Future<void> _pickAndUploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // You can change the file type if needed
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      // Upload the selected file to your server or use it as needed.
      // You can access the file using file.path.
      // For example, you can send it to a web page using JavaScript.
      if (_webViewController != null) {
        _webViewController.evaluateJavascript(
          'uploadImage("${file.path}");', // JavaScript function to handle the file
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_webViewController != null && isExternalUrl) {
          if (await _webViewController.canGoBack()) {
            _webViewController.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 20,
          backgroundColor: Colors.white,
        ),
        body: WebView(
          initialUrl: 'https://www.ktdcbooking.com/crc',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _webViewController = controller;
          },
          onPageStarted: (String url) {
            setState(() {
              // Check if the current URL is the external URL
              isExternalUrl = url == 'https://www.datadevices.com/thecentres/';
            });
          },
        ),
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FloatingActionButton(
        //       onPressed: () {
        //         // Reload the WebView page
        //         if (_webViewController != null) {
        //           _webViewController.reload();
        //         }
        //       },
        //       child: const Icon(Icons.refresh),
        //     ),
        //     SizedBox(height: 16),
        //     FloatingActionButton(
        //       onPressed: _pickAndUploadImage,
        //       child: const Icon(Icons.file_upload),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
