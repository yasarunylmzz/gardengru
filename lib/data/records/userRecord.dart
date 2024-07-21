import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/savedItemsRecord.dart';

class userRecord{
  String? uid;
  String? mail;
  String? pass;
  String? Name;
  String? Surname;
  List<SavedModel>? savedItems;

  String? get getuid => uid;
  String? get getmail => mail;
  String? get getpass => pass;
  String? get getname => Name;
  String? get getsurname => Surname;
  List<SavedModel>? get getsaved => savedItems;

  void setsaved(List<SavedModel>? savedItems) => this.savedItems = savedItems;






  userRecord({this.mail, this.pass, this.Name, this.Surname, this.savedItems,this.uid});


}

