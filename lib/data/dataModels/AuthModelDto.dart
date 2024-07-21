
class AuthModel{
  String? uid;
  String? mail;
  String? pass;

  AuthModel({this.uid, this.mail, this.pass});

  factory AuthModel.fromFirebase(Map<String, dynamic> data) {
    return AuthModel(
      uid: data['uid'],
      mail: data['mail'],
      pass: data['pass'],
    );
  }

  static Map<String, dynamic> toFirebase(AuthModel authModel) {
    return {
      'uid': authModel.uid,
      'mail': authModel.mail,
      'pass': authModel.pass,
    };
  }

}