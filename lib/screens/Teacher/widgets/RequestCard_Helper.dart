import 'package:flutter/material.dart';
import 'package:flex_out/structures/Responce.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Teacher.dart';

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

Widget createBaseCard(Request r, BuildContext context) {

  Icon icon = getMainIcon(r.cancelled, r.from_responce, r.to_responce);
  Icon icon_0, icon_1, icon_2;

  icon_0 = r.cancelled? FlexIcons.CANCELLED : FlexIcons.APPROVED;

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
    title: Text(r.from.display() + " " + Lang.trans('class_card_connecting_word') + " " + r.to.display(), style: TextStyle(
        fontWeight: FontWeight.bold
    )),
    subtitle: Column(
      children: <Widget>[
        SizedBox(height: 5),
        createResponceRow(icon_0, r.timestamp, student_name: r.student_name, requestReason: r.description, context: context),
        Divider(color: Colors.grey[700]),
        createResponceRow(icon_1, r.from_time, teacher: r.from.teacher, fclass: r.from.display()),
        SizedBox(height: 5),
        createResponceRow(icon_2, r.to_time, teacher: r.to.teacher, fclass: r.to.display()),
      ],
    ),
  );
}

Widget createResponceRow(Icon icon, String time, {String fclass, String requestReason, BuildContext context, Teacher teacher, String student_name}) {


  return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row (children: [
          Column(
            children: <Widget>[
              SizedBox(height: 5),
              icon
            ],
          ),
          fclass == null ? Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(" $student_name", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black
                                )),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 4),
                                    Container(
                                        width: MediaQuery.of(context).size.width - 235,
                                        child: createReasonRow(Lang.trans('reason'), requestReason)
                                    )
                                  ],
                                ),

                              ],
                           )
                         : Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                 Text(" $fclass", style: TextStyle(
                                   fontWeight: FontWeight.bold
                                 )),
                                 Text(teacher.id == Teacher.current.id? " " + Lang.trans('you') : " " + teacher.first_last())
                              ]
                           )
        ],
        crossAxisAlignment: CrossAxisAlignment.start),
        Container(
            padding: EdgeInsets.only(right: 50),
            child: Text(time == null? "" : time,
              style: TextStyle(
                  fontStyle: FontStyle.italic
              ),
            )
        )
      ]
  );
}

Widget createReasonRow(String prefix, String reason) {
  return Row(
      children: <Widget>[
        Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: prefix + ": ",
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