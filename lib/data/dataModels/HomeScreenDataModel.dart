

import 'HomeScreenWidgetDataModel.dart';

class HomeScreenDataModel {


  final String _json;
  String? _article;
  HomeScreenWidgetDataModel? _widgetDataModel;

  HomeScreenDataModel(this._json) {
    _widgetDataModel = HomeScreenWidgetDataModel.fromJson(_json);
  }


  get getWidgetDataModel => _widgetDataModel;



  set setArticle(String article) => _article = article;
  get getArticle => _article;


}