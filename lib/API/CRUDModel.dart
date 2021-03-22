import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:test2/models/API.dart';
import '../locator.dart';
import 'api.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<RandomNumber> randomNumbers;


  Future<List<RandomNumber>> fetchRandomNumbers() async {
    var result = await _api.getDataCollection();
    randomNumbers = result.docs
        .map((doc) => RandomNumber.fromMap(doc.data(), doc.id))
        .toList();
    return randomNumbers;
  }

  Stream<QuerySnapshot> fetchCalculationAsStream() {
    return _api.streamDataCollection();
  }

  Future addRandomNumber(RandomNumber data) async{
    await _api.addDocument(data.toJson()) ;
    return ;
  }
}