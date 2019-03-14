import 'package:flutter/material.dart';
import 'CurrentRequests.dart';
import 'package:flex_out/Request.dart';
import 'package:flex_out/Screens/Student/RequestCard_Helper.dart';

class STU_RequestCardMS extends StatefulWidget {

  static Set<int> selected = new Set();

  Request request;

  STU_RequestCardMS(this.request, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  STU_RequestCardMSState createState() => STU_RequestCardMSState(request);

}

class STU_RequestCardMSState extends State<STU_RequestCardMS> {

  static List<STU_RequestCardMSState> states = new List();

  Request r;
  bool cb_val = false;

  STU_RequestCardMSState(this.r);

  @override
  void deactivate() {
    states.remove(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    states.add(this);

    Widget baseCard = createBaseCard(r, true);

    return Card(
        child: Stack(
          children: <Widget>[
            baseCard,
            Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(top: 10),
                child: Checkbox(
                  onChanged: (bool val) { setState(() {
                    cb_val = val;
                    if (cb_val)
                      STU_RequestCardMS.selected.add(r.id);
                    else
                      STU_RequestCardMS.selected.remove(r.id);
                    STU_CurrentRequestState.access.setMSAppBarCheckBoxSymbol();
                  });},
                  value: cb_val,
                )
            )
          ],
        )
    );
  }

  bool getSelected() {
    return cb_val;
  }

  void setSelected(bool val) {
    setState(() {
      cb_val = val;
      if (cb_val)
        STU_RequestCardMS.selected.add(r.id);
      else
        STU_RequestCardMS.selected.remove(r.id);
    });
  }

  static void setAllSelected(bool val) {
    for (STU_RequestCardMSState state in states)
      state.setSelected(val);
  }

}