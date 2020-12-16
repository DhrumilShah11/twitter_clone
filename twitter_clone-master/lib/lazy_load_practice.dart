import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyContactsPage extends StatefulWidget {
  @override
  _MyContactsPageState createState() => _MyContactsPageState();
}

class _MyContactsPageState extends State<MyContactsPage> {
  ScrollController _sc = ScrollController();
  int _currentPage = 10;
  List myList;
  @override
  void initState() {
    myList = List.generate(10, (i) => "Item : ${i + 1}");
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    print("Scroll Limit Reached");
    for (int i = _currentPage; i < _currentPage + 10; i++) {
      myList.add("Item : ${i + 1}");
    }
    _currentPage = _currentPage + 10;
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text("Contacts"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ListView.builder(
          itemBuilder: (_, i) {
            if (i == myList.length) return CupertinoActivityIndicator();
            return Container(
              child: Text(myList[i]),
            );
          },
          itemCount: myList.length + 1,
          itemExtent: 80,
          shrinkWrap: true,
          controller: _sc,
        ),
      ),
    );
  }
}
