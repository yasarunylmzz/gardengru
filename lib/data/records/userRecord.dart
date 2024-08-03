// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters, file_names
import 'package:gardengru/data/dataModels/SavedModelDto.dart';

// ignore: camel_case_types
class userRecord {
  String? _uid;

<<<<<<< Updated upstream
  String? get getuid => uid;
  String? get getmail => mail;
  String? get getpass => pass;
  String? get getname => Name;
  String? get getsurname => Surname;
  List<SavedModel>? get getsaved => savedItems;

  void setsaved(List<SavedModel>? savedItems) => this.savedItems = savedItems;






  userRecord({this.mail, this.pass, this.Name, this.Surname, this.savedItems,this.uid});
=======
  String? get uid => _uid;
>>>>>>> Stashed changes

  set uid(String? value) {
    _uid = value;
  }

  String? _mail;

  String? get mail => _mail;

  set mail(String? value) {
    _mail = value;
  }

  String? _pass;

  String? get pass => _pass;

  set pass(String? value) {
    _pass = value;
  }

  String? _Name;

  String? get Name => _Name;

  set Name(String? value) {
    _Name = value;
  }

  String? _Surname;

  String? get Surname => _Surname;

  set Surname(String? value) {
    _Surname = value;
  }

  List<SavedModel>? _savedItems;

  List<SavedModel>? get savedItems => _savedItems;

  set savedItems(List<SavedModel>? value) {
    _savedItems = value;
  }

  userRecord(
      {String? mail,
      String? pass,
      String? Name,
      String? Surname,
      List<SavedModel>? savedItems,
      String? uid})
      : _savedItems = savedItems,
        _Name = Name,
        _Surname = Surname,
        _pass = pass,
        _mail = mail,
        _uid = uid;
}
