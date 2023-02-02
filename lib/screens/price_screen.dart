import 'package:bitcoin_ticker/screens/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String seletedCurrency = 'USD';
  String btcToUsdVal = 'NA';

  void updateUI() async {
    var val = await CoinData().getLatestRate(seletedCurrency);

    setState(() {
      btcToUsdVal = val;
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  DropdownButton<String> getAndroidPicker() {
    List<DropdownMenuItem<String>> pickerItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      var newItem = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );

      pickerItems.add(newItem);
    }

    return DropdownButton<String>(
      value: seletedCurrency,
      items: pickerItems,
      onChanged: (value) => setState(() {
        seletedCurrency = value;
        updateUI();
      }),
    );
  }

  CupertinoPicker getIosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) => setState(() {
        seletedCurrency = currenciesList[selectedIndex];
        updateUI();
      }),
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return getAndroidPicker();
    } else {
      return getIosPicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $btcToUsdVal $seletedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker()),
        ],
      ),
    );
  }
}
