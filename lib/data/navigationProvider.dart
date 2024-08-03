import 'package:flutter/foundation.dart';

class NavigationProvider with ChangeNotifier {
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  void setPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
