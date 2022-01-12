import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:crypt/crypt.dart';

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
    String hashedPassword = Crypt.sha256(providerData["password"], salt: '1234')
        .toString(); //TODO: change the salt and save it in secureStorage

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
          .addStage(Match(
              where.eq('account.password', hashedPassword).map['\$query']))
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
      ];
      final result = await postCollection.aggregateToStream(pipeline).toList();

      return result;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static Future getImages(post, db) async {
    GridFS bucket = GridFS(db, "finderApp_pictures");
    var images = [];
    if (post.containsKey("pictures")) {
      var picturesId = post["pictures"];
      for (var id in picturesId) {
        var img = await bucket.chunks.findOne({"_id": id});
        images.add(img);
      }
      post["pictures"] = images;
    }
    return post;
  }

  static Future getAllPosts(db, [limit = 0]) async {
    dynamic posts;
    var postCollection = db.collection("finderApp_post");
    dynamic pipeline;

    if (limit != 0) {
      pipeline = [
        {'\$limit': 4}
      ];
    } else {
      pipeline = [
        {
          "\$sort": {"date": -1}
        }
      ];
    }
    posts = await postCollection.aggregateToStream(pipeline).toList();

    return posts;
  }

  static Future reserve(db, message) async {
    var postCollection = db.collection("finderApp_message");
    print(message);
    await postCollection.insert(new Map<String, dynamic>.from(message));
    return "done";
  }

  //get latest posts
  static Future getLatestPosts(provider, db) async {
    var providerId = ObjectId.fromHexString(provider);

    var postCollection = db.collection("finderApp_post");

    try {
      dynamic pipeline2 = [
        {
          '\$match': {'provider_id': providerId}
        },
        {
          '\$sort': {'date': -1}
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

      final result = await postCollection.aggregateToStream(pipeline).toList();
      return result;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static Future createPost(postQuery, images, db, idProvider) async {
    try {
      var postCollection = db.collection("finderApp_post");
      GridFS bucket = GridFS(db, "finderApp_pictures");
      var providerId = ObjectId.fromHexString(idProvider);
      var idPictures = [];
      //compress images

      dynamic imagesQuery = {};
      for (int i = 0; i < images.length; i++) {
        imagesQuery["image"] = images[i];
        imagesQuery["_id"] = new ObjectId();
        idPictures.add(imagesQuery["_id"]);
        await bucket.chunks.insert(new Map<String, dynamic>.from(imagesQuery));
      }
      postQuery["_id"] = new ObjectId();
      postQuery["pictures"] = idPictures;
      postQuery["provider_id"] = providerId;
      postQuery["date"] = DateTime.now();

      await postCollection.insert(new Map<String, dynamic>.from(postQuery));

      return "done";
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }
}
