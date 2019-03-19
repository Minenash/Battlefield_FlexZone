import 'package:flutter/material.dart';
import 'package:flex_out/screens/Student/CurrentRequests.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/screens/Student/widgets/RequestCard_Helper.dart';

class STU_RequestCardMS extends StatefulWidget {

  static Set<Request> selected = new Set();

  Request request;

  STU_RequestCardMS(this.request, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  STU_RequestCardMSState createState() => STU_RequestCardMSState(request);
}

class STU_RequestCardMSState extends State<STU_RequestCardMS> {

  static Map<Request, STU_RequestCardMSState> states = new Map();

  Request r;
  bool cb_val = false;

  STU_RequestCardMSState(this.r);

  @override
  void dispose() {
    states.remove(r);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    states[r] = this;

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
                      STU_RequestCardMS.selected.add(r);
                    else
                      STU_RequestCardMS.selected.remove(r);
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
        STU_RequestCardMS.selected.add(r);
      else
        STU_RequestCardMS.selected.remove(r);
    });
  }

  static void setAllSelected(bool val) {
    for (STU_RequestCardMSState state in states.values)
      state.setSelected(val);
  }

}