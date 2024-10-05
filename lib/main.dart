import 'package:flutter/material.dart';
import 'localization_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalizationService? localizationService;
  String tenant = 'tenant1'; // Can be dynamic
  String locale = 'en';

  @override
  void initState() {
    super.initState();
    // Set the tenant and locale you want to use
    localizationService = LocalizationService(tenant: tenant, locale: locale);
    localizationService!.load();
  }

  void changeLocale(String newLocale, String newTenant) {
    setState(() {
      locale = newLocale;
      tenant = newTenant;
    });
    localizationService = LocalizationService(tenant: newTenant, locale: newLocale);
    localizationService!.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Tenant Localization',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Localization Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: localizationService!.load(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(localizationService!.translate('welcome') ?? ''),
                    const SizedBox(height: 20),
                    Text(localizationService!.translate('goodbye') ?? ''),
                    DropdownButton<String>(
                      value: tenant,
                      items: <String>['tenant1', 'tenant2', 'tenant3'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        changeLocale(locale, newValue!);
                      },
                    ),
                    DropdownButton<String>(
                      value: locale,
                      items: <String>['en', 'ja'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        changeLocale(newValue!, tenant);
                      },
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
