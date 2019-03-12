import 'package:flutter/material.dart';

enum Responce {approved, denied, waiting}

const APPROVED_ICON = Icon(Icons.done, color: Colors.green);
const DENIED_ICON = Icon(Icons.close, color: Colors.red);
const WAITING_ICON = Icon(Icons.alarm, color: Colors.blueGrey);
const ALL_APPROVED_ICON = Icon(Icons.done_all, color: Colors.green);
const IRRELEVANT_ICON = Icon(Icons.alarm_off, color: Colors.blueGrey);

bool no_expandables = false;

Widget createCard(String teacher_1, String teacher_2,
              Responce res_1,   Responce res_2,
              String reason_1,  String reason_2,
              String time_1,    String time_2) {

  Icon icon = getMainIcon(res_1, res_2);
  Icon icon_1, icon_2;

  if (res_1 == Responce.denied && res_2 == Responce.waiting) {
    icon_1 = DENIED_ICON;
    icon_2 = IRRELEVANT_ICON;
  }
  else if (res_1 == Responce.waiting && res_2 == Responce.denied) {
    icon_1 = IRRELEVANT_ICON;
    icon_2 = DENIED_ICON;
  }
  else {
    icon_1 = getTeacherIcon(res_1);
    icon_2 = getTeacherIcon(res_2);
  }

  Widget baseCard = createBaseCard(icon, icon_1, icon_2, teacher_1, teacher_2, time_1, time_2);

  List<Widget> expanded = new List();

  if (reason_1 != null) expanded.add(createReasonRow(teacher_1, reason_1));
  if (reason_2 != null) expanded.add(createReasonRow(teacher_2, reason_2));

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







Icon getMainIcon(Responce res_1, Responce res_2) {
  return res_1 == Responce.denied || res_2 == Responce.denied? DENIED_ICON
       : res_1 == Responce.waiting || res_2 == Responce.waiting? WAITING_ICON
       : ALL_APPROVED_ICON;
}

Icon getTeacherIcon(Responce responce) {
  return responce == Responce.approved ? APPROVED_ICON
       : responce == Responce.denied   ? DENIED_ICON
       :                                 WAITING_ICON;
}

Widget createBaseCard(Icon icon, Icon icon_1, Icon icon_2,
                       String teacher_1, String teacher_2,
                       String time_1,    String time_2) {
  return ListTile(
    leading: icon,
    title: Text("$teacher_1 to $teacher_2"),
    subtitle: Column(
      children: <Widget>[
        createResponceRow(icon_1, teacher_1, time_1),
        createResponceRow(icon_2, teacher_2, time_2),
      ],
    ),
  );
}

Widget createResponceRow(Icon icon, String teacher, String time) {
  return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [icon, Text(teacher)]),
        Container(
            padding: EdgeInsets.only(right: no_expandables? 0 : 50),
            child: Text(time,
              style: TextStyle(
                  fontStyle: FontStyle.italic
              ),
            )
        )
      ]
  );
}

Widget createReasonRow(String teacher, String reason) {
  return Row(
      children: <Widget>[
        Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: teacher + ": ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: reason,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.grey))
                  ],
                ),
              )
            ],
          ),
        ),
      ]
  );
}