import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    await dotenv.load(fileName: '.env');
    var username = dotenv.env["USERNAME"];
    var pwd = username = dotenv.env["PASSWORD"];
    var url =
        "mongodb+srv://$username:$pwd@findercluster.cqmxn.mongodb.net/finderDB?retryWrites=true&w=majority";
    var collection = "finder";
    var db = await Db.create(url);
    await db.open();
    inspect(db);
    userCollection = db.collection(collection);
  }
}
