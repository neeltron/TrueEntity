import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrueEntity',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
        title: const Text('Empty Classy Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NextPage(),
            ));
          },
          child: const Text(
            'Login with World ID',
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

class _NextPageState extends State<NextPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
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
                final name = nameController.text;
                final ssn = ssnController.text;
                final passport = passportController.text;
                final dob = dobController.text;

                Map<String, dynamic> dataToSend = {
                  'name': name,
                  'ssn': ssn,
                  'passport': passport,
                  'dob': dob,
                };

                String jsonData = jsonEncode(dataToSend);

                const String serverUrl = 'https://trueentityapi.neeltron.repl.co';

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
    );
  }
}
