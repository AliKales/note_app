import 'package:flutter/material.dart';

class PLayers with ChangeNotifier {
  List layersNoteAddPage = [];
  List layersNoteDetailsPage = [];

  void addLayersNoteAddPage(val) {
    layersNoteAddPage.add(val);

    notifyListeners();
  }

  void removeLayersNoteAddPage(val) {
    layersNoteAddPage.remove(val);

    notifyListeners();
  }

  void clearLayersNoteAddPage() {
    layersNoteAddPage.clear();

    notifyListeners();
  }

  void addLayersNoteDetailsPage(val) {
    layersNoteDetailsPage.add(val);

    notifyListeners();
  }

  void removeLayersNoteDetailsPage(val) {
    layersNoteDetailsPage.remove(val);

    notifyListeners();
  }

  void clearLayersNoteDetailsPage([bool? notify]) {
    layersNoteDetailsPage.clear();

    if (notify ?? true) notifyListeners();
  }
}
