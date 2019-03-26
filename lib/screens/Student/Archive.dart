import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';

import 'package:flex_out/screens/Student/widgets/RequestCard.dart';
import 'package:flex_out/screens/Student/widgets/RequestCard_Helper.dart';

class STU_Archive extends StatefulWidget {
  STU_Archive({Key key, this.title}) : super(key: key);
  final String title;

  @override
  STU_ArchiveState createState() => STU_ArchiveState();
}

class STU_ArchiveState extends State<STU_Archive> {
  List<Request> requests = Database.getArchivedRequests();
  List<Widget> listItems;

  @override
  Widget build(BuildContext context) {
    //requests = Database.getArchivedRequests(User.current.email);
    listItems = new List();
    set_no_expandables(requests);

    for(Request r in requests)
      listItems.add(STU_RequestCard(r));

    return new Scaffold(
        appBar: AppBar(
          leading: MaterialButton(
              child: FlexIcons.BACK_ARROW,
              onPressed: () {Navigator.of(context).pop();}),
          title: Text(Lang.trans('archived_title')),
          backgroundColor: FlexColors.BF_PURPLE,
        ),
        backgroundColor: Colors.grey[300],
        body: _buildListView()
    );
  }

  static Widget _dismiss(bool secondary) {
    return Card(
      color: Colors.yellow[700],
      child: Container(
          alignment: secondary? Alignment.centerRight : Alignment.centerLeft,
          padding: secondary? EdgeInsets.only(right: 25) : EdgeInsets.only(left: 25),
          child: Icon(Icons.unarchive)
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return Dismissible(
          background: _dismiss(false),
          secondaryBackground: _dismiss(true),
          key: ObjectKey(listItems[index]),
          child: Container(
            child: listItems[index],
          ),
          onDismissed: (direction) {
            setState((){
              Request r = requests.elementAt(index);
              Database.unarchive(r);
              requests.remove(r);
            });
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(Lang.trans('request_unarchived_msg')))
            );
          },
        );
      },
    );
  }

}