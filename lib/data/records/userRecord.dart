import 'package:gardengru/data/dataModels/SavedModelDto.dart';
import 'package:gardengru/data/records/savedItemsRecord.dart';

class userRecord{
  String? uid;
  String? mail;
  String? pass;
  String? Name;
  String? Surname;
  List<SavedModel>? savedItems;

  userRecord({this.mail, this.pass, this.Name, this.Surname, this.savedItems,this.uid});


}

