import 'package:flutter/material.dart';
import 'package:together_online/pages/search/search_results_page.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/my_search_chip.dart';
import 'package:together_online/widgets/raised_button.dart';
import 'package:together_online/widgets/search_result_card.dart';
import 'package:together_online/providers/database.dart';

import '../../app_localizations.dart';

class SearchPage extends StatefulWidget {
  final Function? closeModal;
  SearchPage({this.closeModal});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchTextController = TextEditingController();
  List<Map<String, dynamic>> categories = [];
  bool searchByCategories = false;

  @override
  void initState() {
    super.initState();
    Database.categoriesObj.forEach((c) {
      categories.add({'name': c['name'], 'isSelected': false});
    });
  }

  clickToggle(bool value) {
    if (!value) {
      categories.forEach((c) => c['isSelected'] = false);
    }
    setState(() {
      searchByCategories = value;
    });
  }

  void clickChip(String? name) {
    if (!searchByCategories) searchByCategories = true;

    int index = categories.indexWhere((dynamic e) {
      return e['name'] == name;
    });
    setState(() {
      categories[index]['isSelected'] = !categories[index]['isSelected'];
    });
  }

  search() {
    print('${
            categories.where((c) => c['isSelected']).map((c) => c['name']).toList()}');
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => SearchResultsPage(
        categories:
            List<String>.from(categories.where((c) => c['isSelected']).map((c) => c['name']).toList()),
        searchByCategory: searchByCategories,
        searchText: _searchTextController.text,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.translate('Find Missions or Article')!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20
              //fontSize: constrains.maxHeight * 0.03,
              ),
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            iconSize: globalWidth * 0.04,
            padding: const EdgeInsets.all(0),
            icon: Icon(Icons.close),
            onPressed: widget.closeModal as void Function()?,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: globalWidth * 0.07,
                right: globalWidth * 0.07,
                //top: constrains.maxWidth * 0.03,
              ),
              child: TextFormField(
                controller: _searchTextController,
                style: TextStyle(
                  fontSize: globalHeight * .025,
                ),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.translate('What are you looking for?'),
                    fillColor: Colors.green,
                    focusColor: Colors.green,
                    hoverColor: Colors.green,
                    
                    suffixStyle:  TextStyle(
                      fontSize: globalHeight * .0273,
                    ),
                    labelStyle: TextStyle(
                      fontSize: globalHeight * .0273,
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: globalWidth * 0.07,
                right: globalWidth * 0.07,
                top: globalWidth * 0.03,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('SEARCH BY CATEGORIES')!,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Switch(
                    value: searchByCategories,
                    onChanged: (value) {
                      clickToggle(value);
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                //horizontal: globalHeight * 0.01,
                vertical: globalHeight * 0.03,
              ),
              //height: globalHeight * 0.15,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 13,
                runSpacing: 10,
                children: <Widget>[
                  ...categories
                      .map((c) => MySearchChip(
                            isSelected: c['isSelected'],
                            text: c['name'],
                            onTap: () {
                              clickChip(c['name']);
                            },
                          ))
                      .toList(),
                ],
              ),
            ),
            /*
            Container(
              margin: EdgeInsets.only(
                left: globalWidth * 0.07,
                right: globalWidth * 0.07,
                //top: constrains.maxWidth * 0.03,
              ),
              child: Text(
                'YOU MAY BE INTRESTED',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  //DUMY DATA
                  SearchResultCard(
                      image:
                          'https://mfa.gov.il/MFA/PressRoom/2019/Photos2019/MASHAV-water%20distribution-Bahamas.jpg',
                      tittle:
                          'Israel provides Bahamas with water technology in wake of Hurrican'),
                  SearchResultCard(
                      image:
                          'https://www.israelhayom.com/wp-content/uploads/2019/08/07580602-1024x570.jpg',
                      tittle:
                          'Palestinians, Jews, citizens of Israel, join the Palestinian call for'),
                  SearchResultCard(
                      image:
                          'https://electronicintifada.net/sites/default/files/styles/original_800w/public/2016-09/rrb-boycott-activestills1462127931kt7xl.jpg?itok=nfWD_cI6',
                      tittle:
                          'Israelis seek to uncover government’s secret war against BDS'),
                  SearchResultCard(
                      image:
                          'https://images.jpost.com/image/upload/f_auto,fl_lossy/t_Article2016_ControlFaceDetect/428104',
                      tittle:
                          '39 JEWISH LEFT-WING GROUPS PEN LETTER SUPPORTING BDS'),
                ],
              ),
              
            ),*/
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: RaisedButton(
                  onPressed: search,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate('SEARCH')!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  color: Color.fromRGBO(42, 56, 143, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
