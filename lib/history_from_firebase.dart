
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test2/models/API.dart';

import 'API/CRUDModel.dart';
import 'models/API.dart';

class HistoryFromFirebasePage extends StatefulWidget {
  @override
  _HistoryFromFirebasePageState createState() => _HistoryFromFirebasePageState();
}


class _HistoryFromFirebasePageState extends State<HistoryFromFirebasePage> {
  Future<List<RandomNumber>> randomNumbersList = CRUDModel().fetchRandomNumbers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random numbers History"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: randomNumbersList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: RichText(
                                        text: TextSpan(
                                            style: new TextStyle(
                                              fontSize: 35.0,
                                              color: Colors.black,
                                            ),
                                            text: '${snapshot.data[index].random}'
                                        )
                                    )
                                ),
                              );
                            }
                        )
                    );
                  } else if (snapshot.hasError) {
                    RichText(
                        text: TextSpan(
                            style: new TextStyle(
                              fontSize: 45.0,
                              color: Colors.black,
                            ),
                            text: snapshot.error
                        )
                    );
                  }
                  return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}

