import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'package:intl/intl.dart';

class FormProvider extends ChangeNotifier {
  final String _storageKey = 'fs033:data';
  Fs033Form data = Fs033Form();

  List<String> get opciones => const ['','Sí','No','N.A.'];

  void setFecha(DateTime? d){ data.fecha = d; notifyListeners(); }

  void reset(){
    data = Fs033Form();
    notifyListeners();
  }

  Future<void> saveLocal() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_storageKey, data.toRawJson());
  }

  Future<bool> loadLocal() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_storageKey);
    if(raw == null) return false;
    data = Fs033Form.fromRawJson(raw);
    notifyListeners();
    return true;
  }

  String get fechaStr => data.fecha != null ? DateFormat('yyyy-MM-dd').format(data.fecha!) : '';
}
