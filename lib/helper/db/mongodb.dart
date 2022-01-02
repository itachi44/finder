import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    await dotenv.load(fileName: '.env');
    var username = dotenv.env["USERNAME"];
    var pwd = dotenv.env["PASSWORD"];
    var url =
        "mongodb+srv://$username:$pwd@findercluster.cqmxn.mongodb.net/finderDB?authSource=admin&replicaSet=atlas-4xybvw-shard-0&w=majority&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=true";
    //var collection = "finder";
    var db = await Db.create(url);
    await db.open();
    inspect(db);
    return db;
    //userCollection = db.collection(collection);
  }

  //connexion
  static Future handleConnection(userData, db) async {
    var providerCollection = db.collection("finderApp_provider");

    try {
      dynamic pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'finderApp_account',
              localField: 'account_id',
              foreignField: 'id',
              as: 'account'))
          .addStage(Unwind(Field('account')))
          .addStage(Match(where
              .eq('account.username', userData["username"])
              .map['\$query']))
          .addStage(Match(where
              .eq('account.password', userData["password"])
              .map['\$query']))
          .build();

      final provider =
          await providerCollection.aggregateToStream(pipeline).toList();
      return provider;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }
}
