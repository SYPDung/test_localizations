import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  final String tenant;
  final String locale;

  Map<String, String>? _localizedStrings;
  Map<String, String>? _sharedStrings;

  LocalizationService({required this.tenant, required this.locale});

  Future<void> load() async {
    String jsonStringTenant = "";
    String jsonStringShared = "";
    try {
      jsonStringTenant =
          await rootBundle.loadString('assets/locales/$locale/$tenant.json');
      Map<String, dynamic> tenantMap = json.decode(jsonStringTenant);
      _localizedStrings = {
        ...tenantMap,
      };
    } catch (e) {
      print(e);
    }

    try {
      jsonStringShared =
          await rootBundle.loadString('assets/locales/$locale/shared.json');
      Map<String, dynamic> sharedMap = json.decode(jsonStringShared);
      _sharedStrings = {...sharedMap};
    } catch (e) {
      print(e);
    }
  }

  String? translate(String key) {
    if (_localizedStrings != null && _localizedStrings!.containsKey(key)) {
      return _localizedStrings![key];
    }
    return _sharedStrings?[key];
  }
}
