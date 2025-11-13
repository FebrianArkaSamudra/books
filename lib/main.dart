import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

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
  late Completer completer;

  Future getNumber() {
    completer = Completer<int>();
    calculate();
    return completer.future;
  }

  Future calculate() async {
    try {
      await Future.delayed(const Duration(seconds: 5));
      completer.complete(42);
      // throw Exception();
    } catch (_) {
      completer.completeError({});
    }
  }

  String result = '';
  bool _loading = false;

  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  Future<void> count() async {
    setState(() {
      result = '';
      _loading = true;
    });

    try {
      int total = 0;
      total = await returnOneAsync();
      total += await returnTwoAsync();
      total += await returnThreeAsync();
      setState(() {
        result = total.toString();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        result = 'An error occurred';
        _loading = false;
      });
    }
  }

  // Fetch the specified Google Books volume. The user requested id: 1bm0DwAAQBAJ
  Future<http.Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/1bm0DwAAQBAJ';
    final url = Uri.https(authority, path);
    return http.get(url);
  }

  // Original fetch method (commented out as requested)
  /*void _fetch() {
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
  }*/

  void returnFG() {
    FutureGroup<int> futureGroup = FutureGroup<int>();
    futureGroup.add(returnOneAsync());
    futureGroup.add(returnTwoAsync());
    futureGroup.add(returnThreeAsync());
    futureGroup.close();
    futureGroup.future.then((List<int> value) {
      int total = 0;
      for (var element in value) {
        total += element;
      }
      setState(() {
        result = total.toString();
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
              ElevatedButton(
                child: const Text('GO!'),
                onPressed: () {
                  returnFG();
                },
              ),
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
