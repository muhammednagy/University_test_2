class RandomNumber {
  final String id;
  final int random;
  final String timestamp;

  RandomNumber({this.random, this.timestamp, this.id});

  RandomNumber.fromMap(Map snapshot,String id) :
        id = id ?? '',
        random = snapshot['number'] ?? '',
        timestamp = snapshot['timestamp'] ?? '';

  toJson() {
    return {
      // "id": id,
      "number": random,
      "timestamp": timestamp,
    };
  }

  factory RandomNumber.fromJson(Map<String, dynamic> json) {
    return RandomNumber(
      random: json['random'] as int,
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
//      'id': id,  since id is auto incremented in the database we don't need to send it to the insert query.
      'number': random,
      'timestamp': timestamp,
    };
    if(forUpdate){  data["id"] = this.id;  }
    return data;
  }
}

