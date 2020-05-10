import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dialogs.dart';

import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PrevAppoinmentList extends StatelessWidget {
  final List prevAppointments;

  PrevAppoinmentList({this.prevAppointments});
  _buildListItem(var entry, BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 8, right: 8),
        //title: Text('Serial No:' + entry['serial'].toString()),
        subtitle: Text('Doctor Name: ' +
            entry['doc_name'] +
            '\nDate: ' +
            DateFormat.yMd()
                .format(DateTime.parse(entry["appointment_date_time"]))),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.image),
          onPressed: entry["prescription_img"] == null
              ? () {}
              : () => _showImageDialog(context,
                  'http://192.168.0.103:3000' + entry["prescription_img"]),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageURL) async {
    ThemeData theme = Theme.of(context);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.network(
            imageURL,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.file_download,
                color: theme.primaryColor,
              ),
              label: Text('Download', style: theme.textTheme.button),
              onPressed: () async {
                if (await saveImage(imageURL)) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return SuccessDialog(
                          contentText: 'Image Saved Successfully');
                    },
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FailureDialog(
                          contentText: 'Image Could Not Be Saved');
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> saveImage(String url) async {
    try {
      var response = await get(url);
      var storageDirectory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getLibraryDirectory();
      if (Platform.isAndroid) {
        for (var i = 0; i < 4; i++) {
          storageDirectory = storageDirectory.parent;
        }
      }
      var status = await Permission.storage.request();
      print(status);
      var imgName = url.split('/').last;
      print(imgName);
      storageDirectory = Directory(storageDirectory.path + '/prescriptions');
      storageDirectory = await storageDirectory.create(recursive: true);
      File file = File(join(storageDirectory.path, imgName));
      file.writeAsBytesSync(response.bodyBytes);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Previous prescription'),
        ),
        body: Center(
            child: prevAppointments == null || prevAppointments.isEmpty
                ? ListTile(
                    title: Text(
                      'No Appointments Today',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _buildListItem(prevAppointments[index], ctxt);
                    },
                    itemCount: prevAppointments.length,
                  )));
  }
}
