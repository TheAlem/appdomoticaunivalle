import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

class DatabaseService {
  late Db db;
  late DbCollection usersCollection;

  Future<void> connectToDatabase() async {
    db = await Db.create("mongodb://sunset:1234@144.22.36.59:27017/sunset");
    await db.open();
    usersCollection = db.collection('registro');
  }

  Future<void> disconnectFromDatabase() async {
    await db.close();
  }

  Future<Map<String, dynamic>?> getUserDetails(String email) async {
    await connectToDatabase();
    var user = await usersCollection.findOne({'correo_institucional': email});
    await disconnectFromDatabase();

    return user;
  }
}
