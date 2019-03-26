import 'package:flutter/material.dart';
import 'package:flex_out/screens/Teacher/CurrentRequests.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/screens/Teacher/widgets/RequestCard_Helper.dart';

class TEA_RequestCardMS extends StatefulWidget {

  static Set<Request> selected = new Set();

  Request request;

  TEA_RequestCardMS(this.request, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  TEA_RequestCardMSState createState() => TEA_RequestCardMSState(request);
}

class TEA_RequestCardMSState extends State<TEA_RequestCardMS> {

  static Map<Request, TEA_RequestCardMSState> states = new Map();

  Request r;
  bool cb_val = false;

  TEA_RequestCardMSState(this.r);

  @override
  void dispose() {
    states.remove(r);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    states[r] = this;

    Widget baseCard = createBaseCard(r, context);

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
                      TEA_RequestCardMS.selected.add(r);
                    else
                      TEA_RequestCardMS.selected.remove(r);
                    TEA_CurrentRequestState.access.setMSAppBarCheckBoxSymbol();
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
        TEA_RequestCardMS.selected.add(r);
      else
        TEA_RequestCardMS.selected.remove(r);
    });
  }

  static void setAllSelected(bool val) {
    for (TEA_RequestCardMSState state in states.values)
      state.setSelected(val);
  }

}