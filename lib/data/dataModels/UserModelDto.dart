// ignore_for_file: file_names, non_constant_identifier_names

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
