import 'package:cloud_firestore/cloud_firestore.dart';
import 'SavedModelDto.dart';

class UserModel {
  String? Name;
  String? Surname;
  List<SavedModel>? savedModels;

  UserModel({this.Name, this.Surname, this.savedModels});

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      Name: data['Name'],
      Surname: data['Surname']
    );
  }
  static Map<String, dynamic> toFirestore(UserModel userModel) {
    return {
      'Name': userModel.Name,
      'Surname': userModel.Surname
    };
  }

}
