import 'package:flutter/material.dart';

class MessegeBox extends StatelessWidget {
  final String name;
  final String msg;
  final VoidCallback onLongPress;
  final AlignmentGeometry align;
  final Color color;
  final bool sent;
  const MessegeBox({
    super.key,
    required this.name,
    required this.msg,
    required this.onLongPress,
    required this.align,
    required this.color,
    required this.sent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      child: Align(
          alignment: align,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: Stack(children: [
              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: sent
                        ? BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                  ),
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
