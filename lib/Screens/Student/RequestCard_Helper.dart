import 'package:flutter/material.dart';
import 'package:flex_out/Responce.dart';
import 'package:flex_out/FlexIcons.dart';
import 'package:flex_out/Request.dart';
import 'package:flex_out/Lang.dart';

bool no_expandables = false;

Icon getMainIcon(bool cancelled, Responce res_1, Responce res_2) {
  return cancelled? FlexIcons.CANCELLED_BIG
      : res_1 == Responce.denied || res_2 == Responce.denied? FlexIcons.DENIED_BIG
      : res_1 == Responce.waiting || res_2 == Responce.waiting? FlexIcons.WAITING_BIG
      : FlexIcons.ALL_APPROVED_BIG;
}

Icon getTeacherIcon(Responce responce) {
  return responce == Responce.approved ? FlexIcons.APPROVED
      : responce == Responce.denied   ? FlexIcons.DENIED
      :                                 FlexIcons.WAITING;
}

Widget createBaseCard(Request r, bool checkbox) {

  Icon icon = getMainIcon(r.cancelled, r.from_responce, r.to_responce);
  Icon icon_1, icon_2;

  if (r.from_responce == Responce.denied && r.to_responce == Responce.waiting) {
    icon_1 = FlexIcons.DENIED;
    icon_2 = FlexIcons.IRRELEVANT;
  }
  else if (r.from_responce == Responce.waiting && r.to_responce == Responce.denied) {
    icon_1 = FlexIcons.IRRELEVANT;
    icon_2 = FlexIcons.DENIED;
  }
  else {
    icon_1 = getTeacherIcon(r.from_responce);
    icon_2 = getTeacherIcon(r.to_responce);
  }

  return ListTile(
    leading: Column(
      children: [ SizedBox(height: 5), icon ],
    ),
    title: Text(r.from.class_name + " " + Lang.trans('class_card_connecting_word') + " " + r.to.class_name, style: TextStyle(
        fontWeight: FontWeight.bold
    )),
    subtitle: Column(
      children: <Widget>[
        createResponceRow(icon_1, r.from.teacher_name, r.from_time, checkbox),
        createResponceRow(icon_2, r.to.teacher_name, r.to_time, checkbox),
      ],
    ),
  );
}

Widget createResponceRow(Icon icon, String teacher, String time, bool checkbox) {
  return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [icon, Text(" $teacher")]),
        Container(
            padding: EdgeInsets.only(right: no_expandables && !checkbox? 10 : 50),
            child: Text(time == null? "" : time,
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

bool set_no_expandables(List<Request> requests) {
  for (Request request in requests) {
    if (request.from_reason != null) {
      no_expandables = false;
      return false;
    }
    if (request.to_reason != null) {
      no_expandables = false;
      return false;
    }
  }
  no_expandables = true;
  return true;
}