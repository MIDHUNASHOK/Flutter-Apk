import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Confirmation'),
        content: Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // No, do not exit
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Yes, exit
            child: Text('Yes'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  // Function to handle file selection
  Future<void> _pickAndUploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // You can change the file type if needed
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (_webViewController != null) {
        _webViewController.evaluateJavascript(
          'uploadImage("${file.path}");',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 20,
          backgroundColor: Colors.white,
        ),
        body: WebView(
          initialUrl: 'https://www.resworld.in/ec',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _webViewController = controller;
          },
          onPageStarted: (String url) {
            setState(() {
              isExternalUrl = url == 'https://www.datadevices.com/thecentres/';
            });
          },
        ),
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FloatingActionButton(
        //       onPressed: () {
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
