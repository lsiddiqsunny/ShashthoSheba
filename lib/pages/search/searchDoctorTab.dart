import 'package:flutter/material.dart';

class SearchDoctorTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MySearchPage(title: 'Doctor Search');
  }
}

class MySearchPage extends StatefulWidget {
  MySearchPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MySearchPageState createState() => new _MySearchPageState();
}

enum Filter { name, hospital, speciality }

class _MySearchPageState extends State<MySearchPage> {
  TextEditingController editingController = TextEditingController();
  Filter filter = Filter.name;

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState() {
    super.initState();
    items.addAll(duplicateItems);
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search By',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedCrossFade(
                  firstChild: OutlineButton.icon(
                    onPressed: () {
                      setState(() {
                        filter = Filter.name;
                      });
                    },
                    icon: Icon(Icons.person_outline),
                    label: Text('Doctor'),
                  ),
                  secondChild: RaisedButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.person_outline),
                    label: Text('Doctor'),
                  ),
                  crossFadeState: filter == Filter.name
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
                AnimatedCrossFade(
                  firstChild: OutlineButton.icon(
                    onPressed: () {
                      setState(() {
                        filter = Filter.hospital;
                      });
                    },
                    icon: Icon(Icons.local_hospital),
                    label: Text('Hospital'),
                  ),
                  secondChild: RaisedButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.local_hospital),
                    label: Text('Hospital'),
                  ),
                  crossFadeState: filter == Filter.hospital
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
                AnimatedCrossFade(
                  firstChild: OutlineButton.icon(
                    onPressed: () {
                      setState(() {
                        filter = Filter.speciality;
                      });
                    },
                    icon: Icon(Icons.healing),
                    label: Text('Speciality'),
                  ),
                  secondChild: RaisedButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.healing),
                    label: Text('Speciality'),
                  ),
                  crossFadeState: filter == Filter.speciality
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${items[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
