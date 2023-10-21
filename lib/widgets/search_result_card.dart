import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SearchResultCard extends StatelessWidget {
  final String? image;
  final String? tittle;
  final String? type;

  SearchResultCard({this.image, this.tittle, this.type});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: constrains.maxHeight,
            height: constrains.maxHeight,
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        image!,
                        height: constrains.maxHeight * 0.5,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: Container(
                      //     width: constrains.maxWidth * 0.3,
                      //     height: constrains.maxHeight * 0.15,
                      //     color: Colors.blue,
                      //   ),
                      //)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: AutoSizeText(
                    tittle!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxFontSize: 20,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
