import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/utils/settings_data.dart';

class AppTheme extends StatefulWidget {
  final ThemeSettings settings;
  const AppTheme({super.key, required this.settings});

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    _selectedColor =
        primaryColors.values.toList().indexOf(widget.settings.accentColor);
  }

  Widget _selection(int index) {
    if (index == _selectedColor) {
      return Icon(FluentSystemIcons.ic_fluent_checkmark_regular,
          color: Colors.primaries[index].computeLuminance() > 0.5
              ? Colors.black
              : Colors.white);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Theme",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.settings.setAccentColor(
                  primaryColors.values.elementAt(_selectedColor));
              Navigator.pop(context);
            },
            icon: const Icon(
              FluentSystemIcons.ic_fluent_save_regular,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Text("Choose an accent color"),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: ((context, index) {
                    return Material(
                      color: Color(primaryColors.values.elementAt(index)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedColor = index;
                          });
                        },
                        splashColor: Colors.grey.shade200,
                        child: _selection(index),
                      ),
                    );
                  }),
                  itemCount: Colors.primaries.length,
                )),
          ),
        ],
      ),
    );
  }
}

const Map<String, int> primaryColors = {
  "Red": 0xFFFF0000,
  "Pink": 0xFFFFC0CB,
  "Purple": 0xFF800080,
  "Deep Purple": 0xFF4B0082,
  "Indigo": 0xFF4B0082,
  "Blue": 0xFF0000FF,
  "Light Blue": 0xFFADD8E6,
  "Cyan": 0xFF00FFFF,
  "Teal": 0xFF008080,
  "Green": 0xFF008000,
  "Light Green": 0xFF90EE90,
  "Lime": 0xFF00FF00,
  "Yellow": 0xFFFFFF00,
  "Amber": 0xFFFFD700,
  "Orange": 0xFFFFA500,
  "Deep Orange": 0xFFFF8C00,
  "Brown": 0xFFA52A2A,
  "Grey": 0xFF808080,
  "Blue Grey": 0xFF708090,
};
