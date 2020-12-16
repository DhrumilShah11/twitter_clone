import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsREST extends StatefulWidget {
  @override
  _ContactsRESTState createState() => _ContactsRESTState();
}

class _ContactsRESTState extends State<ContactsREST> {
  ScrollController _sc = ScrollController();
  int page = 0;
  bool isLoading = false;
  List users = List();
  final dio = Dio();

  @override
  void initState() {
    getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        getMoreData(page);
      }
    });
  }

  getMoreData(int index) async {
    setState(() {
      isLoading = true;
    });
    var url = "https://randomuser.me/api/?page=" +
        index.toString() +
        "&results=20&seed=abc";
    print(url);
    final response = await dio.get(url);
    print(response);
    List tList = new List();
    for (int i = 0; i < response.data['results'].length; i++) {
      tList.add(response.data['results'][i]);
    }
    setState(() {
      isLoading = false;
      page++;
      users.addAll(tList);
    });
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                users[index]['picture']['large'],
              ),
            ),
            title: Text((users[index]['name']['first'])),
            subtitle: Text((users[index]['email'])),
          );
        }
      },
      controller: _sc,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: Container(child: _buildList()),
    );
  }
}
