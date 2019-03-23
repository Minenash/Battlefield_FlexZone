import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';

import 'package:flex_out/screens/Student/widgets/RequestCardMultiSelect.dart';
import 'package:flex_out/screens/Student/widgets/RequestCard.dart';
import 'package:flex_out/screens/Student/widgets/RequestCard_Helper.dart';
import 'package:flex_out/screens/Student/widgets/LangaugeSelect.dart';


enum MenuAction { log_out, classes, language }

class STU_CurrentRequest extends StatefulWidget {
  STU_CurrentRequest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  STU_CurrentRequestState createState() => STU_CurrentRequestState();
}

class STU_CurrentRequestState extends State<STU_CurrentRequest> {
  static STU_CurrentRequestState access;
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  //20 char Limit
  List<Request> requests = Database.getRequests();
  List<Widget> listItems;

  Queue<Request> recently_archived = new Queue();
  Queue<int> recently_archived_index = new Queue();

  bool ms_enabled = false;

  @override
  Widget build(BuildContext context) {
    //requests = Database.getRequests(User.current.email);
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
      listItems.add(STU_RequestCard(r));

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
          child: const Icon(Icons.create),
            onPressed: () {Navigator.of(context).pushNamed('/stu/create');},
          backgroundColor: FlexColors.BF_PURPLE,),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.archive),
                  onPressed: () {Navigator.of(context).pushNamed('/stu/archive');},
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
      int numSeleceted = STU_RequestCardMS.selected.length;

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
    STU_RequestCardMSState.setAllSelected( mscheckboxicon != Icons.check_box );
    setMSAppBarCheckBoxSymbol();
  }

  List<Request> last_MS_selection;
  List<Request> ms_backup;

  void msArchive() {
    setState(() {
      last_MS_selection = List.from(STU_RequestCardMS.selected);
      ms_backup = List.from(requests);
      for (Request r in STU_RequestCardMS.selected) {
        int index = requests.indexOf(r);
        recently_archived.addLast(r);
        recently_archived_index.addLast(index);
        requests.remove(r);
      }
      STU_RequestCardMSState.setAllSelected(false);
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
      listItems.add(STU_RequestCardMS(r));
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
            IconButton(icon: Icon(Icons.archive), onPressed: () {msArchive();}, tooltip: Lang.trans('archive_button_tooltip')),
            IconButton(icon: Icon(mscheckboxicon), onPressed: () {onMSCheckBoxPress();}, tooltip: Lang.trans('multiselect_checkbox')),
          ],
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: Lang.trans('new_request_button_tooltip'),
          child: const Icon(Icons.create), onPressed: () {},
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
          value: MenuAction.classes,
          child: _menuOption(Icons.class_, Lang.trans('menu_classes')),
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
      case MenuAction.classes: return onClassSel();
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

  void onClassSel() {
    Navigator.of(context).pushNamed('/stu/classes');
  }



  void archiveItem(Request request, {bool cancel}){
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
      if (cancel)
        Database.cancel(request);
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

  static Widget _dismiss(Request r, bool secondary) {
    bool isCancel = secondary? r.cancelled? false : true : false;
    return Card(
      color: isCancel? Colors.red : Colors.green,
      child: Container(
          alignment: secondary? Alignment.centerRight : Alignment.centerLeft,
          padding: secondary? EdgeInsets.only(right: 25) : EdgeInsets.only(left: 25),
          child: isCancel? Icon(Icons.close) : Icon(Icons.archive)
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return Dismissible(
          background: _dismiss(requests[index],false),
          secondaryBackground: _dismiss(requests[index],true),
          key: ObjectKey(listItems[index]),
          child: Container(
            child: listItems[index],
          ),
          onDismissed: (direction) {

            var item = requests.elementAt(index);
            archiveItem(item, cancel: direction == DismissDirection.endToStart && !item.cancelled);

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
