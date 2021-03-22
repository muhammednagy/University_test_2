import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test2/models/API.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<RandomNumber> fetchRandomNumber() async {
  final response = await http.get('https://csrng.net/csrng/csrng.php?min=1&max=1000');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonresponse = json.decode(response.body);
    final random = RandomNumber.fromJson(jsonresponse[0]);
    return random;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load random number');
  }

}

class Api{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  Api( this.path ) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get() ;
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.doc(id).update(data) ;
  }
}