import 'dart:convert';

class HomeScreenWidgetDataModel {

  Map<String, String> _widgets = {};
  Map<String, String> _risks = {};

  Map<String, String> get getWidgets => _widgets;
  Map<String, String> get getRisks => _risks;
  set setWidgets(Map<String, String> widgets) => _widgets = widgets;
  set setRisks(Map<String, String> risks) => _risks = risks;

  //HomeScreenWidgetDataModel();

  HomeScreenWidgetDataModel.fromJson(String json) {
    try {
      Map<String, dynamic> response;
      // gemini cevabı başında bu var
      if (json.contains("```json")) {
        response = jsonDecode(json.substring(json.indexOf('{'), json.lastIndexOf('}') + 1));
      } else {
        response = jsonDecode(json);
      }

      if (response.containsKey('widgets') && response['widgets'] != null && response['widgets'].isNotEmpty) {
        _widgets = Map<String, String>.from(response['widgets']);
      }
      if (response.containsKey('risks') && response['risks'] != null && response['risks'].isNotEmpty) {
        _risks = Map<String, String>.from(response['risks']);
      }
    } catch (e) {
      print('Error during parsing HomeScreenWidgetDataModel: $e');
    }
  }
}