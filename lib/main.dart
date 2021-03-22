import 'dart:core';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:test2/API/api.dart';
import 'package:test2/models/API.dart';
import 'API/CRUDModel.dart';
import 'history_from_firebase.dart';
import 'locator.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Test 2 | Random number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<RandomNumber> futureNumber = fetchRandomNumber();
  bool isLoading = false;

  void _setLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  void _getNewRandomNumber() async {
    _setLoading(true);
    _setLoading(false);
    futureNumber =  fetchRandomNumber();
    setState(() {
      if (futureNumber != null) {
        futureNumber.then((value) => {
          if (value != null && value.random != null) {
            _addNumberToPreviousNumbers(value.random)
          }
        });
      }
      this.futureNumber = futureNumber;
    });
    _setLoading(false);
  }

  _addNumberToPreviousNumbers(int randomNumber) async {
    final randomNumbersProvider = CRUDModel();
    randomNumbersProvider.addRandomNumber(RandomNumber(random: randomNumber, timestamp: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  void handleClick(String value) {
    switch (value) {
      case 'History':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryFromFirebasePage()),
        );
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'History'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
          children: <Widget>[
            Center(
              child: RichText(
                  text: TextSpan(
                      style: new TextStyle(
                        fontSize: 35.0,
                        color: Colors.black,
                      ),
                      text: "Random Number:"
                  )
              ) ,
            ),
            Center(
              child: FutureBuilder<RandomNumber>(
                future: futureNumber,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RichText(
                        text: TextSpan(
                            style: new TextStyle(
                              fontSize: 45.0,
                              color: Colors.black,
                            ),
                            text: snapshot.data.random.toString()
                        )
                    );
                  } else if (snapshot.hasError) {
                    return RichText(
                        text: TextSpan(
                            style: new TextStyle(
                              fontSize: 45.0,
                              color: Colors.black,
                            ),
                            text: snapshot.error
                        )
                    );
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              )),
          ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: this.isLoading ? null : _getNewRandomNumber,
        label: Text('New random number'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
