import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter/material.dart';
import 'RequestCardMultiSelect.dart';
import 'RequestCard.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/Screens/Login.dart';
import 'package:flex_out/Request.dart';
import 'package:flex_out/User.dart';
import 'package:flex_out/FlexIcons.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/Screens/Student/RequestCard_Helper.dart';
import 'LangaugeSelect.dart';

enum MenuAction { log_out, classes, language }

class STU_CurrentRequest extends StatefulWidget {
  STU_CurrentRequest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  STU_CurrentRequestState createState() => STU_CurrentRequestState();
}

class STU_CurrentRequestState extends State<STU_CurrentRequest> {
  static STU_CurrentRequestState access;

  //20 char Limit
  Map<int,Request> requests = getRequests(User.current.email);
  List<Widget> listItems;

  bool ms_enabled = false;

  @override
  Widget build(BuildContext context) {
    access = this;

    listItems = new List();
    set_no_expandables(requests);

    if (ms_enabled)
      return multiselect();
    else
      return normal();


  }

  Widget normal() {
    for(Request r in requests.values)
      listItems.add(STU_RequestCard(r));

    return new Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.only(left: 10),
            child: FlexIcons.APP,
          ),
          title: Text(Lang.trans('current_request_title')),
          backgroundColor: BF_PURPLE,
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
          child: const Icon(Icons.create), onPressed: () {},
          backgroundColor: BF_PURPLE,),
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

  void msArchive() {
    setState(() {
      for (int id in STU_RequestCardMS.selected)
        requests.remove(id);
    });

  }

  Widget multiselect() {
    for(Request r in requests.values)
      listItems.add(STU_RequestCardMS(r));

    return new Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.only(left: 10),
            child: FlexIcons.APP,
          ),
          title: Text(Lang.trans('current_request_title')),
          backgroundColor: BF_PURPLE,
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
          backgroundColor: BF_PURPLE,),
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
    FlutterKeychain.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void onLangSel() {

    showDialog(context: context,
        builder: (BuildContext context) {
          return LangaugeSelect(this);
        });
  }

  void onClassSel() {}



  void archiveItem(id){
    setState((){
      requests.remove(id);
    });
  }

  void undoArchive(index, item){
  //  setState((){
  //    listItems.insert(index, item);
   // });
  }

  static Widget _dismiss(bool secondary) {
    return Card(
      color: secondary? Colors.red : Colors.green,
      child: Container(
          alignment: secondary? Alignment.centerRight : Alignment.centerLeft,
          padding: secondary? EdgeInsets.only(right: 25) : EdgeInsets.only(left: 25),
          child: secondary? Icon(Icons.close) : Icon(Icons.archive)
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
            var item = listItems.elementAt(index);
            archiveItem(index);

            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(Lang.trans('request_archived_msg')),
                action: SnackBarAction(
                    label: Lang.trans('undo_button'),
                    onPressed: () {undoArchive(index, item);}
                )
            )
            );
          },
        );
      },
    );
  }

}
