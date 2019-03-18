import 'package:flutter/material.dart';
import 'package:flex_out/Request.dart';
import 'package:flex_out/Screens/Student/widgets/RequestCard_Helper.dart';

class STU_RequestCard extends StatelessWidget {

  Request r;

  STU_RequestCard(this.r);

  @override
  Widget build(BuildContext context) {

    Widget baseCard = createBaseCard(r, false);

    List<Widget> expanded = new List();

    if (r.from_reason != null) expanded.add(createReasonRow(r.from.teacher.title_last(), r.from_reason));
    if (r.to_reason != null) expanded.add(createReasonRow(r.to.teacher.title_last(), r.to_reason));

    if (expanded.isEmpty)
      return Card( child: baseCard );

    expanded.insert(0, Divider(color: Colors.grey[700]));

    if (expanded.length == 2) expanded.add(Text(""));
    expanded.add(Container(height: 5));

    return Card(
        child: Stack(
          children: <Widget>[
            baseCard,
            ExpansionTile(
              title: Container(height: 65),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.comment),
                  subtitle: Column(children: expanded),
                ),
              ],
            ),
          ],
        )
    );
  }

}