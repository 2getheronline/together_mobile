import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:together_online/models/file.dart';
import 'package:together_online/models/folder.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/providers/localstorage.dart';

import '../app_localizations.dart';

class LibraryItem extends StatefulWidget {
  final bool isFavorite;
  final Folder? folder;
  final File? file;
  final Function? onTap;

  LibraryItem({this.folder, this.file, this.onTap, this.isFavorite = false});

  _LibraryItemState createState() => _LibraryItemState();
}

class _LibraryItemState extends State<LibraryItem> {
  unfavorite() async {
    if (await LocalStorageProvider.removeFileFromFavorites(widget.file)) {
      setState(() {
        widget.file!.isFavorite = false;
      });
    }
  }

  favorite() async {
    if (await LocalStorageProvider.addFileToFavorites(widget.file!)) {
      setState(() {
        widget.file!.isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.file == null) {
      // Folder
      return GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: widget.isFavorite ? Color(0xffebeeff) : Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  leading: widget.isFavorite
                      ? SvgPicture.asset(
                          'assets/icons/library/favorites_files.svg')
                      : !(widget.folder!.seen)
                          ? SvgPicture.asset(
                              'assets/icons/library/folder_not_observed.svg')
                          : SvgPicture.asset('assets/icons/library/folder.svg'),
                  title: Text(
                    widget.folder!.name!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${widget.folder!.fileCount} ' +
                        AppLocalizations.of(context)!.translate('Files')! +
                        ' | ${DateFormat.yMMMd().format(widget.folder!.lastUpdated!)}',
                    style: TextStyle(color: Color(0xFFacacac)),
                  ),
                  trailing: Icon(Icons.navigate_next)),
            ),
            !widget.isFavorite ? Divider() : SizedBox(),
          ],
        ),
      );
    } else {
      // File
      return GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                leading: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset(
                    widget.file!.format == 'pdf'
                        ? 'assets/icons/library/files/pdf_file.svg'
                        : widget.file!.format == 'video'
                            ? 'assets/icons/library/files/xls_file.svg'
                            : 'assets/icons/library/files/doc_file.svg',
                    height: globalHeight * .047,
                  ),
                ),
                title: Text(
                  widget.file!.name!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: widget.file!.isFavorite
                    ? GestureDetector(
                        onTap: unfavorite,
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow[600],
                          size: globalHeight * .04,
                        ),
                      )
                    : GestureDetector(
                        onTap: favorite,
                        child: Icon(
                          Icons.star_border,
                          color: Colors.yellow[600],
                          size: globalHeight * .04,
                        ),
                      )),
            Divider(),
          ],
        ),
      );
    }
  }
}
