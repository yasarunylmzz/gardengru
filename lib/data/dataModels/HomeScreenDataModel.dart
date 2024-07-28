

import 'HomeScreenWidgetDataModel.dart';

class HomeScreenDataModel {

  final String _titleForTop = "Welcome! Good to see you!";
  final String _titleForArticle = "What's on today?";
  final String _json;
  String? _article;
  HomeScreenWidgetDataModel? _widgetDataModel;

  HomeScreenDataModel(this._json) {
    _widgetDataModel = HomeScreenWidgetDataModel.fromJson(_json);
  }


  get getTitle => _titleForArticle;
  get getWidgetDataModel => _widgetDataModel;
  get getTitleForTop => _titleForTop;


  set setArticle(String article) => _article = article;
  get getArticle => _article;


}