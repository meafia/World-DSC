import 'dart:io';
import 'package:flutter/material.dart';
import 'package:world/screens/country_page.dart';
import 'main-page.dart';

class ContinentPage extends StatefulWidget {
  final Map languages;
  final String continentName;
  final String continentSymbol;
  final Map countries;
  // final Set favoriteCountries;

  ContinentPage({
    this.countries,
    this.languages,
    this.continentName,
    this.continentSymbol,
    // this.favoriteCountries,
  });

  @override
  _ContinentPageState createState() => _ContinentPageState();
}

class _ContinentPageState extends State<ContinentPage> {
  IconButton actionIcon;
  Widget appBarTitle;
  String filter = '';
  Map matchedCountries = {};

  startSearchmode() {
    setState(() {
      appBarTitle = TextField(
        autofocus: true,
        onChanged: search,
      );
      actionIcon = IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            actionIcon = null;
            appBarTitle = null;
            filter = '';
          });
        },
      );
    });
  }

  search(value) {
    setState(() {
      matchedCountries = {};
      filter = value;
      widget.countries.forEach((key, value) {
        String name = value['name'];
        if (name.toLowerCase().contains(filter)) matchedCountries[key] = value;
      });
    });
    print(widget.countries);
    print(value);
    print(matchedCountries);
  }

  updateBody(Map countries) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) {
        String countrySymbol = countries.entries.elementAt(index).key;
        Map countryData = countries.entries.elementAt(index).value;
        String name = countryData['name'];

        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Platform.isIOS
                    ? Text(countryData['emojiU'])
                    : Text(countryData['emoji']),
              ),
              title: Text(name),
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    if (favoriteCountries.contains(name)) {
                      favoriteCountries.remove(name);
                    } else {
                      favoriteCountries.add(name);
                    }
                    print(favoriteCountries);
                    print(favoriteCountries.contains(name));
                  });
                },
                child: Icon(
                  favoriteCountries.contains(name)
                      ? Icons.favorite_outlined
                      : Icons.favorite_border_outlined,
                  color: favoriteCountries.contains(name)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CountryPage(
                              languages: widget.languages,
                              countrySymbol: countrySymbol,
                              countryData: countryData,
                            )));
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle ?? Text(widget.continentName),
        actions: [
          actionIcon ??
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  startSearchmode();
                },
              )
        ],
      ),
      body: matchedCountries.isEmpty & filter.isEmpty
          ? updateBody(widget.countries)
          : matchedCountries.isEmpty & filter.isNotEmpty
              ? Center(
                  child: Text('no country match "$filter"'),
                )
              : updateBody(matchedCountries),
    );
  }
}
