import 'package:flutter/material.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/structures/Teacher.dart';
import 'package:flex_out/structures/Responce.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/screens/Teacher/widgets/RequestCard_Helper.dart';
import 'package:flex_out/screens/Teacher/widgets/Respond.dart';
import 'package:flex_out/screens/Teacher/CurrentRequests.dart';

class TEA_RequestCard extends StatelessWidget {

  Request r;
  TEA_CurrentRequestState access;

  TEA_RequestCard(this.r, {this.access});

  @override
  Widget build(BuildContext context) {

    Widget baseCard = createBaseCard(r, context);

    List<Widget> expanded = new List();

    if (r.from_reason != null)
      expanded.add(
          createReasonRow(
              r.from.teacher.id == Teacher.current.id? " You" : " " + r.from.teacher.first_last(),
              r.from_reason
          )
      );
    if (r.to_reason != null)
      expanded.add(
          createReasonRow(
              r.to.teacher.id == Teacher.current.id? " You" : " " + r.to.teacher.first_last(),
              r.to_reason
          )
      );

    bool canAccept, canDeny;

    if (access != null) {
      if (r.from.teacher.id == Teacher.current.id) {
        canAccept = !r.cancelled && r.from_responce != Responce.approved;
        canDeny = !r.cancelled && r.from_responce != Responce.denied;
      }
      else {
        canAccept = !r.cancelled && r.to_responce != Responce.approved;
        canDeny = !r.cancelled && r.to_responce != Responce.denied;
      }
    }

    if (expanded.isEmpty)
      return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              baseCard,
              access == null? Container() : buttonRow(context, canAccept, canDeny)
            ],
          ),
      );

    expanded.insert(0, Divider(color: Colors.grey[700]));

    if (expanded.length == 2) expanded.add(Text(""));
    expanded.add(Container(height: 5));

    return Card(
        child: Stack(
          children: <Widget>[
            baseCard,
            Column (
              children: <Widget>[
                ExpansionTile(
                  title: Container(height: 140),
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.comment),
                      subtitle: Column(children: expanded),
                    ),
                  ],
                ),
                access == null? Container() : buttonRow(context, canAccept, canDeny)
              ],
            ),

          ],
        )
    );
  }

  Widget buttonRow(BuildContext context, bool canAccept, bool canDeny) {
    if (!canAccept && !canDeny)
      return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          child: Text(Lang.trans('accept_button'), style: TextStyle(
              color: canAccept? Colors.green[900] : Colors.grey[700],
              decoration: canAccept? TextDecoration.none : TextDecoration.lineThrough
          )),
          onPressed: () {
            if (canAccept)
              showDialog(context: context,
                builder: (BuildContext context) {
                  return Respond([r], Responce.approved, null);
                });
          },
        ),
        FlatButton(
          child: Text(Lang.trans('deny_button'), style: TextStyle(
              color: canDeny? Colors.red[900] : Colors.grey[700],
              decoration: canDeny? TextDecoration.none : TextDecoration.lineThrough
          )),
          onPressed: () {
            if (canDeny)
              showDialog(context: context,
                builder: (BuildContext context) {
                  return Respond([r], Responce.denied, null);
                });
          },
        ),
      ],
    );
  }

}