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
        title: Text('Empty Classy Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the next page when the button is pressed
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NextPage(),
            ));
          },
          child: Text(
            'Go to Next Page',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text(
          'This is the next page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
