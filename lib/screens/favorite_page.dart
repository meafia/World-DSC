import 'package:flutter/material.dart';
import 'package:world/screens/country_page.dart';
import 'main-page.dart';

class FavoritePage extends StatefulWidget {
  final Map countries;
  final Map continents;
  final Map languages;
  FavoritePage(this.countries, this.continents, this.languages);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Map selectedCountries = {};
  @override
  void initState() {
    print(favoriteCountries);
    super.initState();
    widget.countries.removeWhere(
        (key, value) => !favoriteCountries.contains(value['name']));
    print('From favorite ${widget.countries}');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.countries.length,
      itemBuilder: (BuildContext context, int index) {
        String countrySymbol = widget.countries.entries.elementAt(index).key;
        Map countryData = widget.countries.entries.elementAt(index).value;
        String name = countryData['name'];
        String continentName = widget.continents[countryData['continent']];

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Text(countryData['emoji']),
          ),
          title: Text(name),
          subtitle: Text(continentName),
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
              color:
                  favoriteCountries.contains(name) ? Colors.red : Colors.grey,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CountryPage(
                  countrySymbol: countrySymbol,
                  countryData: countryData,
                  languages: widget.languages,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
