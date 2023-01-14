import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/screens/country.dart';
import 'package:flutter_news/screens/theme.dart';
import 'package:flutter_news/utils/settings_data.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int pageInt = 1;
  int tempPageInt = 1;
  bool darkMode = false;

  Widget _countrySelection(ThemeSettings settings) {
    if (settings.country == "all") {
      return Container(
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(FluentSystemIcons.ic_fluent_globe_regular),
      );
    } else {
      return Container(
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.shade400)],
        ),
        child: Image.asset(
          "icons/flags/png/${settings.country}.png",
          package: 'country_icons',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ThemeSettings>(context);
    pageInt = settings.page;
    darkMode = settings.isDark;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(children: const [
                Icon(
                  FluentSystemIcons.ic_fluent_settings_dev_regular,
                  size: 30,
                ),
                SizedBox(width: 15),
                Text("Settings",
                    style:
                        TextStyle(fontSize: 35, fontWeight: FontWeight.w500)),
              ])),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            hoverColor: const Color.fromARGB(153, 0, 38, 255),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text("Page Int"),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(pageInt.toString()),
                  const Icon(FluentSystemIcons.ic_fluent_chevron_right_regular)
                ],
              ),
            ),
            onTap: () async {
              tempPageInt = pageInt;
              await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Select a Value",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "Sets no of news to show on page.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: 170,
                        width: 50,
                        child: CupertinoPicker.builder(
                          itemExtent: 30,
                          diameterRatio: 1,
                          onSelectedItemChanged: ((value) {
                            setState(() {
                              tempPageInt = value + 1;
                            });
                          }),
                          itemBuilder: (context, index) {
                            return Text((index + 1).toString());
                          },
                          childCount: 100,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              pageInt = tempPageInt;
                              settings.setPage(pageInt);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Ok"),
                        ),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            hoverColor: const Color.fromARGB(153, 0, 38, 255),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text("Dark Mode"),
            trailing: Switch.adaptive(
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = !darkMode;
                    settings.setDark(darkMode);
                  });
                }),
            onTap: () {
              setState(() {
                darkMode = !darkMode;
                settings.setDark(darkMode);
              });
            },
          ),
          ListTile(
            hoverColor: const Color.fromARGB(153, 0, 38, 255),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text("Theme"),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: Color(settings.accentColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const Icon(FluentSystemIcons.ic_fluent_chevron_right_regular)
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AppTheme(settings: settings),
                ),
              );
            },
          ),
          ListTile(
            hoverColor: const Color.fromARGB(153, 0, 38, 255),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text("Country"),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _countrySelection(settings),
                  const Icon(FluentSystemIcons.ic_fluent_chevron_right_regular)
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CountryScreen(
                    settings: settings,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
