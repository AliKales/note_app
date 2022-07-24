import 'package:flutter/material.dart';

class ProviderPages with ChangeNotifier {
  int currentPage = 0;

  void changePage(int index) {
    currentPage = index;
    notifyListeners();
  }
}
