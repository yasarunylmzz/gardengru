import 'package:cloud_firestore/cloud_firestore.dart';
import 'SavedModel.dart';

class UserModel {
  String? Name;
  String? Surname;
  List<SavedModel>? savedModels;



  UserModel({this.Name, this.Surname, this.savedModels});



  factory UserModel.fromFirestore(Map<String, dynamic> firestore) {
    return UserModel(
      Name: firestore['Name'],
      Surname: firestore['Surname'],
      savedModels: null, // savedModels'ı daha sonra dolduracağız
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Name': Name,
      'Surname': Surname,
      'createdAt': savedModels?.map((e) => e.toFirestore()).toList(),
    };
  }

  static Future<UserModel> fromFirestoreStatic(DocumentSnapshot<Map<String, dynamic>> doc) async {
    UserModel user = UserModel.fromFirestore(doc.data()!);
    // saved koleksiyonunu alıyoruz
    CollectionReference savedCollection = doc.reference.collection('saved');
    QuerySnapshot savedSnapshot = await savedCollection.get();
    user.savedModels = savedSnapshot.docs.map((savedDoc) => SavedModel.fromFirestore(savedDoc.data() as Map<String, dynamic>)).toList();
    return user;
  }

  static Map<String, dynamic> toFirestoreStatic(UserModel userModel) {
    return userModel.toFirestore();
  }
}
