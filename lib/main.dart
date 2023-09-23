import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
            // Navigate to the next page when the button is pressed
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NextPage(),
            ));
          },
          child: const Text(
            'Go to Next Page',
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
              onPressed: () {
                final name = nameController.text;
                final ssn = ssnController.text;
                final passport = passportController.text;
                final dob = dobController.text;

              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
