import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

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
  static Future handleConnection(providerData, db) async {
    var providerCollection = db.collection("finderApp_provider");

    try {
      dynamic pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'finderApp_account',
              localField: 'account_id',
              foreignField: 'id',
              as: 'account'))
          .addStage(Unwind(Field('account')))
          .addStage(Match(Or([
            {"account.username": providerData["identifier"]},
            {"email": providerData["identifier"]}
          ])))
          .addStage(Match(where
              .eq('account.password', providerData["password"])
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

  //search
  static Future search(data, db) async {
    var postCollection = db.collection("finderApp_post");
    print(data["minSize"].toString());
    int minSize = int.parse(data["minSize"].toString());
    int maxSize = int.parse(data["maxSize"].toString());
    int minPrice = int.parse(data["minPrice"].toString());
    int maxPrice = int.parse(data["maxPrice"].toString());

    try {
      dynamic pipeline = [
        //1- search
        {
          '\$search': {
            'index': 'postSearchIndex',
            'text': {
              'query': data["searchedValue"],
              'path': {'wildcard': '*'}
            }
          }
        },
        // 2- Match
        data["category"] == ""
            ? {
                '\$match': {
                  "size": {'\$gte': minSize, '\$lte': maxSize},
                  "price": {'\$gte': minPrice, '\$lte': maxPrice}
                }
              }
            : {
                "\$match": {
                  "category": data["category"],
                  "size": {"\$gte": minSize, "\$lte": maxSize},
                  "price": {"\$gte": minPrice, "\$lte": maxPrice}
                }
              },
        //lookup

        {
          '\$lookup': {
            'from': 'finderApp_picture',
            'let': {'pictures': '\$pictures'},
            'pipeline': [
              {
                '\$match': {
                  "pictures": {
                    "exists": true
                  }, //check if pictures before doing lookup
                  '\$expr': {
                    '\$in': ['\$id', "\$\$pictures"]
                  }
                }
              },
              {
                '\$project': {'_id': 0}
              }
            ],
            'as': 'pictures'
          }
        }
      ];
      print(pipeline);
      final result = await postCollection.aggregateToStream(pipeline).toList();
      return result;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  //get latest posts
  static Future getLatestPosts(provider, db) async {
    var postCollection = db.collection("finderApp_post");
    var providerCollection = db.collection("finderApp_provider");

    try {
      dynamic pipeline1 = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'finderApp_account',
              localField: 'account_id',
              foreignField: 'id',
              as: 'account'))
          .addStage(Unwind(Field('account')))
          .addStage(Match(Or([
            {"account.username": provider},
            {"email": provider}
          ])))
          .build();

      final providerInfos =
          await providerCollection.aggregateToStream(pipeline1).toList();
      int idProvider = providerInfos[0]["id"];
      dynamic pipeline2 = [
        {
          '\$match': {'provider_id': idProvider}
        },
        {
          '\$sort': {'date': -1}
        },
        {
          '\$lookup': {
            'from': 'finderApp_picture',
            'let': {'pictures': '\$pictures'},
            'pipeline': [
              {
                '\$match': {
                  "pictures": {"exists": true},
                  '\$expr': {
                    '\$in': ['\$id', "\$\$pictures"]
                  }
                }
              },
              {
                '\$project': {'_id': 0}
              }
            ],
            'as': 'pictures'
          }
        }
      ];
      final posts = await postCollection.aggregateToStream(pipeline2).toList();
      return posts;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static Future providerSearch(data, db) async {
    var postCollection = db.collection("finderApp_post");

    try {
      dynamic pipeline = [
        {
          '\$search': {
            'index': 'postSearchIndex',
            'text': {
              'query': data["searchedValue"],
              'path': {'wildcard': '*'}
            }
          }
        }
      ];
      if (data["startDate"] != null && data["endDate"] != null) {
        dynamic startDate = DateFormat("yyyy-MM-dd").parse(data["startDate"]);
        dynamic endDate = DateFormat("yyyy-MM-dd").parse(data["endDate"]);
        print(startDate);
        print(startDate.runtimeType);

        pipeline.add({
          '\$match': {
            "date": {'\$gte': startDate, '\$lte': endDate},
          }
        });
      }

      pipeline.add({
        '\$lookup': {
          'from': 'finderApp_picture',
          'let': {'pictures': '\$pictures'},
          'pipeline': [
            {
              '\$match': {
                "pictures": {"exists": true},
                '\$expr': {
                  '\$in': ['\$id', "\$\$pictures"]
                }
              }
            },
            {
              '\$project': {'_id': 0}
            }
          ],
          'as': 'pictures'
        }
      });

      final result = await postCollection.aggregateToStream(pipeline).toList();
      return result;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }
}
