import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:stream_builder/app/model/dictionary_model.dart';

class HomePageViewmodel extends BaseViewModel {
  StreamController streamController = StreamController();

  Stream? stream;
  final String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  String? searchFor = "hello";

  initStream() async {
    stream = streamController.stream;
    setBusy(true);
    await search();
    setBusy(false);
    notifyListeners();
  }

  search() async {
    if (searchFor != null) {
      streamController.add("waiting");
      var response = await http.get(
          Uri.parse(
            _url + searchFor!.trim(),
          ),
          headers: {});
      var body = json.decode(response.body);
      streamController.add(body);

      notifyListeners();
      print(body);
    } else if (searchFor == null) {
      streamController.add(null);
    }
  }
}
