import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter/material.dart';
import 'RequestCardMultiSelect.dart';
import 'RequestCard.dart';
import 'package:flex_out/Screens/Login.dart';


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
  List<Widget> listItems = [
    createCard("Mr. Merrmans", "Ms. May", Responce.approved, Responce.denied, "No Comment", null, "2/28", "11:32 AM"),
    createCard("Mr. Merrmans", "Ms. May", Responce.denied, Responce.waiting, "Ugg", "This can't happen", "10:24 PM", ""),
    createCard("Mr. Merrmans", "Ms. May", Responce.waiting, Responce.approved, null, null, "3/3", "Yesterday"),
    createCard("Mr. Merrmans", "Ms. May", Responce.waiting, Responce.waiting, null, null, "", ""),
    createCard("Mr. Merrmans", "Ms. May", Responce.approved, Responce.approved, null, null, "10:24 AM", "11:32 PM"),
  ];

  List<RequestCardMS> listItems2 = [
    RequestCardMS(0,"Mr. Merrmans", "Ms. May", Responce.approved, Responce.denied, "No Comment", null, "2/28", "11:32 AM"),
    RequestCardMS(1,"Mr. Merrmans", "Ms. May", Responce.denied, Responce.waiting, "Ugg", "This can't happen", "10:24 PM", ""),
    RequestCardMS(2,"Mr. Merrmans", "Ms. May", Responce.waiting, Responce.approved, null, null, "3/3", "Yesterday"),
    RequestCardMS(3,"Mr. Merrmans", "Ms. May", Responce.waiting, Responce.waiting, null, null, "", ""),
    RequestCardMS(4,"Mr. Merrmans", "Ms. May", Responce.approved, Responce.approved, null, null, "10:24 AM", "11:32 PM"),
  ];

  bool ms_enabled = false;

  @override
  Widget build(BuildContext context) {
    access = this;

    if (ms_enabled)
      return multiselect();
    else
      return normal();


  }

  Widget normal() {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Current Requests"),
          backgroundColor: BF_PURPLE,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check_box_outline_blank), onPressed: () {setState(() {
              ms_enabled = true;
            });}, tooltip: "CheckBox")
          ],
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: "Create New Request",
          child: const Icon(Icons.create), onPressed: () {},
          backgroundColor: BF_PURPLE,),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.archive), onPressed: () {}, tooltip: "Archive"),
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
      int numSeleceted = RequestCardMS.selected.length;

      if (numSeleceted == 0)
        mscheckboxicon = Icons.check_box_outline_blank;
      else if (numSeleceted == listItems2.length)
        mscheckboxicon = Icons.check_box;
      else
        mscheckboxicon = Icons.indeterminate_check_box;
    });
  }

  IconData mscheckboxicon = Icons.check_box_outline_blank;

  void onMSCheckBoxPress() {
    RequestCardMSState.setAllSelected( mscheckboxicon != Icons.check_box );
    setMSAppBarCheckBoxSymbol();
  }

  void msArchive() {
    List<Widget> toremove = List();
    List<Widget> toremove2 = List();
    setState(() {
      ms_enabled = false;
      for (int index in RequestCardMS.selected) {
        toremove.add(listItems[index]);
        toremove2.add(listItems[index]);
      }
      for (Widget w in toremove)
        listItems.remove(w);
      for (Widget w in toremove2)
        listItems2.remove(w);
    });

  }

  Widget multiselect() {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Current Requests"),
          backgroundColor: BF_PURPLE,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.arrow_back), onPressed: () {setState(() {
              ms_enabled = false;
            });}, tooltip: "Exit MultiSelect"),
            IconButton(icon: Icon(Icons.archive), onPressed: () {msArchive();}, tooltip: "Archive"),
            IconButton(icon: Icon(mscheckboxicon), onPressed: () {onMSCheckBoxPress();}, tooltip: ""),
          ],
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: "Create New Request",
          child: const Icon(Icons.create), onPressed: () {},
          backgroundColor: BF_PURPLE,),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.archive), onPressed: () {}, tooltip: "Archive"),
              _menuButton()
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: ListView(children: listItems2)
    );
  }

  Widget _menuButton() {
    return PopupMenuButton<MenuAction>(
      tooltip: "Menu",
      onSelected: (MenuAction result) { setState(() { onMenuSel(result); }); },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
        PopupMenuItem<MenuAction>(
          value: MenuAction.language,
          child: _menuOption(Icons.language, "Language"),
        ),
        PopupMenuItem<MenuAction>(
          value: MenuAction.classes,
          child: _menuOption(Icons.class_, "Classes"),
        ),
        PopupMenuItem<MenuAction>(
          value: MenuAction.log_out,
          child: _menuOption(Icons.exit_to_app, "Log Out"),
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

  void onLangSel() {}

  void onClassSel() {}



  void archiveItem(index){
    setState((){
      listItems.removeAt(index);
      listItems2.removeAt(index);
    });
  }

  void undoArchive(index, item){
    setState((){
      listItems.insert(index, item);
    });
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
                content: Text("Request Archived"),
                action: SnackBarAction(
                    label: "UNDO",
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
