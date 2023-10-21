import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LevelFace extends StatelessWidget {

  final int level;
  final bool? happy;
  
  LevelFace({this.happy, this.level = 0});


  @override
  Widget build(BuildContext context) {

    Color color = Color(0xffea4a6a);

    if(happy!){
      color = Color(0xff0ce80e);
    }
    print(level);
    /*TODO change not to be chip because of the opacity*/
    return Chip(
      backgroundColor: Color(0xffeeeef0).withOpacity(.83),
                  label: Row(
                    children: <Widget>[
                      happy!
                          ? SvgPicture.asset(
                                'assets/icons/faces/happy.svg',
                              )
                          : SvgPicture.asset('assets/icons/faces/sad.svg'),
                      SizedBox(
                        width: 6,
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: color,
                            maxRadius: 4,
                          ),
                          SizedBox(width: 4,),
                          CircleAvatar(
                           backgroundColor:  level >= 2 ? color : color.withOpacity(.25),
                            maxRadius: 4,
                          ),
                          SizedBox(width: 4,),
                          CircleAvatar(
                            backgroundColor: level >= 3 ? color : color.withOpacity(.25),
                            maxRadius: 4,
                          ),
                          SizedBox(width: 4,),
                          CircleAvatar(
                            backgroundColor: level >= 4 ? color : color.withOpacity(.25),
                            maxRadius: 4,
                          ),
                          SizedBox(width: 4,),
                          CircleAvatar(
                            backgroundColor: level == 5 ? color : color.withOpacity(.25),
                            maxRadius: 4,
                          ),
                        ],
                      )
                    ],
                  ),
                );
  }
}