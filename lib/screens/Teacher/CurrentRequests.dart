import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Responce.dart';
import 'package:flex_out/TestData.dart' as TestData;

import 'package:flex_out/screens/Teacher/widgets/RequestCardMultiSelect.dart';
import 'package:flex_out/screens/Teacher/widgets/RequestCard.dart';
import 'package:flex_out/screens/Teacher/widgets/RequestCard_Helper.dart';
import 'package:flex_out/screens/LangaugeSelect.dart';
import 'package:flex_out/screens/Teacher/widgets/Respond.dart';


enum MenuAction { log_out, language }

class TEA_CurrentRequest extends StatefulWidget {
  TEA_CurrentRequest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  TEA_CurrentRequestState createState() => TEA_CurrentRequestState();
}

class TEA_CurrentRequestState extends State<TEA_CurrentRequest> {
  static TEA_CurrentRequestState access;
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  //20 char Limit
  List<Request> requests;
  List<Widget> listItems;

  Queue<Request> recently_archived = new Queue();
  Queue<int> recently_archived_index = new Queue();

  bool ms_enabled = false;

  @override
  Widget build(BuildContext context) {
    requests = TestData.getTestRequests();
    access = this;
    listItems = new List();
    set_no_expandables(requests);

    if (ms_enabled)
      return multiselect();
    else
      return normal();
  }

  Widget normal() {
    for(Request r in requests)
      listItems.add(TEA_RequestCard(r, access: this));

    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.only(left: 10),
            child: FlexIcons.APP,
          ),
          title: Text(Lang.trans('current_request_title')),
          backgroundColor: FlexColors.BF_PURPLE,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check_box_outline_blank), onPressed: () {setState(() {
              ms_enabled = true;
            });}, tooltip: Lang.trans('multiselect_checkbox_tooltip'))
          ],
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: Lang.trans('new_request_button_tooltip'),
          child: const Icon(Icons.class_),
          onPressed: () {Navigator.of(context).pushNamed('/tea/classes');},
          backgroundColor: FlexColors.BF_PURPLE,),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.archive),
                  onPressed: () {Navigator.of(context).pushNamed('/tea/archive');},
                  tooltip: Lang.trans('archive_button_tooltip')),
              _menuButton()
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: _buildListView()
    );
  }

  void setMSAppBarCheckBoxSymbol() {
    setState(() {
      int numSeleceted = TEA_RequestCardMS.selected.length;

      if (numSeleceted == 0)
        mscheckboxicon = Icons.check_box_outline_blank;
      else if (numSeleceted == listItems.length)
        mscheckboxicon = Icons.check_box;
      else
        mscheckboxicon = Icons.indeterminate_check_box;
    });
  }

  IconData mscheckboxicon = Icons.check_box_outline_blank;

  void onMSCheckBoxPress() {
    TEA_RequestCardMSState.setAllSelected( mscheckboxicon != Icons.check_box );
    setMSAppBarCheckBoxSymbol();
  }


  void msRespond(Responce r) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Respond(List.from(TEA_RequestCardMS.selected), r, this);
        });
    ms_enabled = false;
  }

  List<Request> last_MS_selection;
  List<Request> ms_backup;

  void msArchive() {
    setState(() {
      last_MS_selection = List.from(TEA_RequestCardMS.selected);
      ms_backup = List.from(requests);
      for (Request r in TEA_RequestCardMS.selected) {
        int index = requests.indexOf(r);
        recently_archived.addLast(r);
        recently_archived_index.addLast(index);
        requests.remove(r);
      }
      TEA_RequestCardMSState.setAllSelected(false);
      ms_enabled = false;
    });

    Future.delayed(new Duration(milliseconds: 4000), () {
      if (last_MS_selection == null)
        return;
      for (Request r in last_MS_selection) {
        recently_archived.removeLast();
        recently_archived_index.removeLast();
        Database.archive(r);
      }
      last_MS_selection = null;
      ms_backup = null;
    });
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(Lang.trans('multiple_requests_archived_msg')),
        action: SnackBarAction(
            label: Lang.trans('undo_button'),
            onPressed: () {undo_msArchive();}
        )
    )
    );
  }

  void undo_msArchive() {
    setState(() {
      if (last_MS_selection == null)
        return;
      for (Request _ in last_MS_selection) {
        recently_archived.removeLast();
        recently_archived_index.removeLast();
      }
      requests = ms_backup;

      last_MS_selection = null;
      ms_backup = null;
    });

  }

  Widget multiselect() {
    for(Request r in requests) {
      listItems.add(TEA_RequestCardMS(r));
    }
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.only(left: 10),
            child: FlexIcons.APP,
          ),
          title: Text(Lang.trans('current_request_title')),
          backgroundColor: FlexColors.BF_PURPLE,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.arrow_back), onPressed: () {setState(() {
              ms_enabled = false;
            });}, tooltip: Lang.trans('multiselect_exit_button_tooltip')),
            IconButton(icon: Icon(Icons.check, color: Colors.green,), onPressed: () {msRespond(Responce.approved);}, tooltip: Lang.trans('accept_button_tooltip')),
            IconButton(icon: Icon(Icons.close, color: Colors.red,), onPressed: () {msRespond(Responce.denied);}, tooltip: Lang.trans('deny_button_tooltip')),
            IconButton(icon: Icon(Icons.archive), onPressed: () {msArchive();}, tooltip: Lang.trans('archive_button_tooltip')),
            IconButton(icon: Icon(mscheckboxicon), onPressed: () {onMSCheckBoxPress();}, tooltip: Lang.trans('multiselect_checkbox')),
          ],
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: Lang.trans('new_request_button_tooltip'),
          child: const Icon(Icons.class_),
          onPressed: () {
            Navigator.of(context).pushNamed('/tea/classes');
          },
          backgroundColor: FlexColors.BF_PURPLE,),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.archive), onPressed: () {}, tooltip: Lang.trans('archive_button_tooltip')),
              _menuButton()
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: ListView(children: listItems)
    );
  }

  Widget _menuButton() {
    return PopupMenuButton<MenuAction>(
      tooltip: "Menu",
      onSelected: (MenuAction result) { setState(() { onMenuSel(result); }); },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
        PopupMenuItem<MenuAction>(
          value: MenuAction.language,
          child: _menuOption(Icons.language, Lang.trans('menu_language')),
        ),
        PopupMenuItem<MenuAction>(
          value: MenuAction.log_out,
          child: _menuOption(Icons.exit_to_app, Lang.trans('menu_logout')),
        ),
      ],
    );
  }
  Widget _menuOption(IconData icon, String text) {
    return Row (
      children: <Widget>[
        Icon(icon), Text(text)
      ],
    );
  }

  void onMenuSel(MenuAction sel) {
    switch (sel) {
      case MenuAction.language: return onLangSel();
      case MenuAction.log_out: return onLogOutSel();
    }
  }

  void onLogOutSel() {
    Database.logout(context);
  }

  void onLangSel() {

    showDialog(context: context,
        builder: (BuildContext context) {
          return LangaugeSelect(this);
        });
  }

  void archiveItem(Request request){
    int index = requests.indexOf(request);
    setState((){
      recently_archived.addLast(request);
      recently_archived_index.addLast(index);
      requests.remove(request);
    });
    Future.delayed(new Duration(milliseconds: 4500), () {
      if (!recently_archived.contains(request))
        return;
      recently_archived.remove(request);
      recently_archived_index.remove(index);
      Database.archive(request);
    });
  }

  void undoArchive(){
    setState((){
      Request r = recently_archived.last;
      int index = recently_archived_index.last;
      recently_archived.removeLast();
      recently_archived_index.removeLast();
      requests.insert(index, r);
    });
  }


  static Widget _dismiss( bool secondary) {
    return Card(
      color: Colors.green,
      child: Container(
          alignment: secondary? Alignment.centerRight : Alignment.centerLeft,
          padding: secondary? EdgeInsets.only(right: 25) : EdgeInsets.only(left: 25),
          child: Icon(Icons.archive, size: 35)
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

            var item = requests.elementAt(index);
            archiveItem(item);

            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(Lang.trans('request_archived_msg')),
                action: SnackBarAction(
                    label: Lang.trans('undo_button'),
                    onPressed: () {undoArchive();}
                )
            )
            );
          },
        );
      },
    );
  }

}
