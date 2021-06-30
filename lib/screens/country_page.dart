import 'dart:io';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  final String countrySymbol;
  final Map countryData;
  final Map languages;

  CountryPage({this.countrySymbol, this.countryData, this.languages});

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<String> countryLanguges = [];
  @override
  void initState() {
    widget.languages.forEach((key, value) {
      if (widget.countryData['languages'].contains(key)) {
        countryLanguges.add(value['name']);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.countryData['name']}'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 40,
              child: Text(
                Platform.isIOS
                    ? widget.countryData['emojiU']
                    : widget.countryData['emoji'],
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          InfoItem(
            itemName: 'Country Name',
            itemvalue: widget.countryData['name'],
            itemIcon: Icons.translate,
          ),
          InfoItem(
            itemName: 'Native Name',
            itemvalue: widget.countryData['native'],
            itemIcon: Icons.translate,
          ),
          InfoItem(
            itemName: 'phone',
            itemvalue: widget.countryData['phone'],
            itemIcon: Icons.phone,
          ),
          InfoItem(
            itemName: 'capital',
            itemvalue: widget.countryData['capital'],
            itemIcon: Icons.location_city,
          ),
          InfoItem(
            itemName: 'currency',
            itemvalue: widget.countryData['currency'],
            itemIcon: Icons.attach_money,
          ),
          InfoItem(
            itemName: 'Languages',
            // itemvalue: widget.countryData['languages'],
            itemvalue: countryLanguges.join(' - '),
            itemIcon: Icons.language,
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String itemName;
  final String itemvalue;
  final IconData itemIcon;

  const InfoItem({
    Key key,
    @required this.itemName,
    @required this.itemvalue,
    @required this.itemIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(
        itemIcon,
      ),
      title: RichText(
        text: TextSpan(
            text: '$itemName : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff2287d5),
            ),
            children: [
              TextSpan(
                text: itemvalue,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              )
            ]),
      ),
    ));
  }
}
