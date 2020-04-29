import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './doctorModel.dart';

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

class _MySearchPageState extends State<MySearchPage> {
  TextEditingController editingController = TextEditingController();
  Filter filter = Filter.name;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      child: ChangeNotifierProvider(
        create: (context) => DoctorModel(10),
        child: Builder(
          builder: (context) {
            DoctorModel doctorModel = Provider.of<DoctorModel>(context);
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
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
                        color: theme.primaryColor,
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
                        color: theme.primaryColor,
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
                        color: theme.primaryColor,
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
                      if (value == '') {
                        doctorModel.fetchDoctors(1);
                      } else {
                        doctorModel.fetchDoctors(1,
                            filter: filter, value: value);
                      }
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
                doctorModel.status == Status.loading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: doctorModel.doctors.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(),
                              title: Text(
                                '${doctorModel.doctors[index].name}',
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                '${doctorModel.doctors[index].designation}, ' +
                                    '${doctorModel.doctors[index].institution}\n' +
                                    '${doctorModel.doctors[index].specialization.join(',')}',
                              ),
                              isThreeLine: true,
                              trailing: OutlineButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.playlist_add,
                                  color: Colors.blue,
                                ),
                                label: Text(
                                  'Appointment',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
