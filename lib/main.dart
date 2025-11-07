import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo - Febrian Arka Samudra - 2341720066',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';
  bool _loading = false;

  // Fetch the specified Google Books volume. The user requested id: 1bm0DwAAQBAJ
  Future<http.Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/1bm0DwAAQBAJ';
    final url = Uri.https(authority, path);
    return http.get(url);
  }

  void _fetch() {
    setState(() {
      _loading = true;
      result = '';
    });

    getData()
        .then((value) {
          // show a short slice of the returned body for display
          final body = value.body;
          setState(() {
            result = body.length > 450 ? body.substring(0, 450) : body;
            _loading = false;
          });
        })
        .catchError((_) {
          setState(() {
            result = 'An error occurred';
            _loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Back from the Future - Febrian Arka Samudra - 2341720066',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ElevatedButton(child: const Text('GO!'), onPressed: _fetch),
              const SizedBox(height: 16),
              if (_loading) const CircularProgressIndicator(),
              const SizedBox(height: 16),
              SelectableText(result),
              const SizedBox(height: 16),
              Text(
                'App identity: Febrian Arka Samudra - 2341720066',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
