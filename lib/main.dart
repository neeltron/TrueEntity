import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrueEntity',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrueEntity'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NextPage(),
            ));
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
class NextPage extends StatefulWidget {
  const NextPage();

  @override
  _NextPageState createState() => _NextPageState();
}

var name = "x";

class _NextPageState extends State<NextPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  // Function to shuffle a string
  String shuffleString(String input) {
    List<String> characters = input.split('');
    characters.shuffle();
    return characters.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ssnController,
              decoration: const InputDecoration(labelText: 'Social Security Number'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passportController,
              decoration: const InputDecoration(labelText: 'Passport Number'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                name = nameController.text;
                final ssn = shuffleString(ssnController.text); // Shuffle SSN
                final passport = passportController.text;
                final dob = dobController.text;

                Map<String, dynamic> dataToSend = {
                  'name': name,
                  'ssn': ssn,
                  'passport': passport,
                  'dob': dob,
                };

                String jsonData = jsonEncode(dataToSend);

                const String serverUrl = 'https://trueentity-api.neeltron.repl.co';

                try {
                  final response = await http.post(
                    Uri.parse('$serverUrl/input'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonData,
                  );

                  if (response.statusCode == 200) {
                    print('Response from server: ${response.body}');
                  } else {
                    print('Request failed with status: ${response.statusCode}');
                  }
                } catch (error) {
                  print('Error sending request: $error');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'Fetch Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR Code',
          ),
        ],
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DataFetchingPage(),
            ));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRCodeScannerPage(),
            ));
          }
        },
      ),
    );
  }
}

class DataFetchingPage extends StatefulWidget {
  const DataFetchingPage();

  @override
  _DataFetchingPageState createState() => _DataFetchingPageState();
}

class _DataFetchingPageState extends State<DataFetchingPage> {
  String fetchedData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masked Identity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://trueentity-api.neeltron.repl.co/static/qrcode.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final String serverUrl = 'https://trueentity-api.neeltron.repl.co';

                  final response = await http.get(
                    Uri.parse('$serverUrl/data?name=$name'),
                  );

                  if (response.statusCode == 200) {
                    final Map<String, dynamic> responseData = jsonDecode(response.body);
                    final String data = responseData['data'];
                    setState(() {
                      fetchedData = data;
                    });
                  } else {
                    print('Request failed with status: ${response.statusCode}');
                  }
                } catch (error) {
                  print('Error fetching data: $error');
                }
              },
              child: const Text('You can use the following masked identity:'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fetched Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (fetchedData.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: fetchedData.split('\n').map((item) {
                  String label = '';
                  if (item.startsWith('name')) {
                    label = 'Name: ';
                  } else if (item.startsWith('ssn')) {
                    label = 'SSN: ';
                  } else if (item.startsWith('passport')) {
                    label = 'Passport: ';
                  } else if (item.startsWith('dob')) {
                    label = 'DOB: ';
                  }
                  return Text(
                    '$label${item.trim()}',
                    style: const TextStyle(fontSize: 18),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'Fetch Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR Code',
          ),
        ],
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).pop();
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRCodeScannerPage(),
            ));
          }
        },
      ),
    );
  }
}





class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage();

  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    result = scanData;
                  });
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Text(
                'Scanned QR Code: ${result!.code}',
                style: TextStyle(fontSize: 18),
              )
                  : const Text(
                'Scan a QR code',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'Fetch Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR Code',
          ),
        ],
        currentIndex: 2,
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).pop();
          } else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DataFetchingPage(),
            ));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
