import 'package:flutter/material.dart';
import 'RequestCard.dart';

class RequestCardMS extends StatefulWidget {

  String teacher_1, teacher_2, reason_1, reason_2, time_1, time_2;
  Responce res_1, res_2;

  RequestCardMS(this.teacher_1, this.teacher_2,
                this.res_1,     this.res_2,
                this.reason_1,  this.reason_2,
                this.time_1,    this.time_2, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  RequestCardMSState createState() => RequestCardMSState(teacher_1, teacher_2, res_1, res_2, reason_1, reason_2, time_1, time_2);
}

class RequestCardMSState extends State<RequestCardMS> {

  String teacher_1, teacher_2, reason_1, reason_2, time_1, time_2;
  Responce res_1, res_2;
  bool cb_val = false;

  RequestCardMSState(this.teacher_1, this.teacher_2,
                     this.res_1,     this.res_2,
                     this.reason_1,  this.reason_2,
                     this.time_1,    this.time_2);

  @override
  Widget build(BuildContext context) {
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

    return Card(
        child: Stack(
          children: <Widget>[
            baseCard,
            Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(top: 10),
                child: Checkbox(
                  onChanged: (bool val) {print("hi"); setState(() {cb_val = val;});},
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

}