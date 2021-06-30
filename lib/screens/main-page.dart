import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:world/screens/favorite_page.dart';
import 'package:world/screens/continent_page.dart';

Set favoriteCountries = {};

ThemeData defaultTheme = ThemeData.light().copyWith(
  textTheme: ThemeData.light().textTheme.apply(fontFamily: 'sansPro'),
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    centerTitle: true,
    textTheme: TextTheme(
      headline6:
          TextStyle(fontFamily: 'Pacifico', color: Colors.black, fontSize: 25),
    ),
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'sansPro'),
  accentColor: Color(0xff2287d5),
  scaffoldBackgroundColor: Color(0xff000000),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xff000000),
    centerTitle: true,
    textTheme: TextTheme(
      headline6: TextStyle(fontFamily: 'Pacifico', fontSize: 25),
    ),
  ),
);

class AppMainPage extends StatefulWidget {
  @override
  _AppMainPageState createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  Map data;
  Map continents = {};
  Map countries = {};
  Map languages = {};
  int pageIndex = 0;
  bool dark = false;

  Future loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/data.json');
    setState(() {
      data = json.decode(jsonText);
    });
    continents = data['continents'];
    countries = data['countries'];
    languages = data['languages'];
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Image.asset('assets/images/earthbg.png')),
            SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('Dark'),
                value: dark,
                onChanged: (newValue) {
                  setState(() {
                    dark = newValue;
                  });
                  Get.changeTheme(Get.isDarkMode ? defaultTheme : darkTheme);
                })
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
            pageIndex == 1 ? 'Your Favorite countries' : 'World\'s contenints'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
          loadJsonData();
        },
      ),
      body: pageIndex == 1
          ? FavoritePage(countries, continents, languages)
          : ListView.builder(
              itemCount: continents == null ? 0 : continents.length,
              itemBuilder: (BuildContext context, int index) {
                String name = continents.entries.elementAt(index).value;
                String symbol = continents.entries.elementAt(index).key;
                return new Column(
                  children: <Widget>[
                    new ListTile(
                      leading: Image.asset(
                        'assets/images/$symbol.png',
                        height: 50,
                        width: 50,
                      ),
                      title: Text(name),
                      onTap: () async {
                        countries.removeWhere(
                            (key, value) => value['continent'] != symbol);
                        print(countries);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContinentPage(
                              countries: countries,
                              languages: languages,
                              continentName: name,
                              continentSymbol: symbol,
                              // favoriteCountries: favoriteCountries,
                            ),
                          ),
                        );
                        loadJsonData();
                        print('From home $favoriteCountries');
                      },
                    ),
                    new Divider(),
                  ],
                );
              },
            ),
    );
  }
}
