import 'package:flutter/material.dart';
import 'package:together_online/widgets/myFlatButton.dart';

class ProfileBarIcon extends StatelessWidget {
  final name;
  final selectedIndex;
  final index;
  final Function? onPageChanged;
  ProfileBarIcon({this.selectedIndex, this.index, this.name, this.onPageChanged});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
    child: Text(
      name,
      style: TextStyle(
        color: selectedIndex == index? Color(0xFF2a388f) : Color(0xFF92939a),
        fontWeight: FontWeight.bold
      ),
    ),
    onPressed: () =>  onPageChanged!(index),
  );
  }
}