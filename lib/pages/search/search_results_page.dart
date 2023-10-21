import 'package:flutter/material.dart';
import 'package:together_online/models/file.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/pages/missions/missions.dart';
import 'package:together_online/providers/algolia.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/search_result_item.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app_localizations.dart';

class SearchResultsPage extends StatefulWidget {
  static const routeName = "/SearchResultPage";
  final bool searchByCategory;
  final dynamic categories;
  final String searchText;

  SearchResultsPage(
      {this.searchByCategory = false, this.categories, this.searchText = ''});
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {

  List<Future<dynamic>> searches = [];

  @override
  void initState() {
    createSearchFuture();
    super.initState();
  }

  createSearchFuture() {
    if (widget.searchByCategory) {
      searches.add(AlgoliaSearch.searchMissionsByCategory(
          search: widget.searchText,
          categories: widget.categories,
          userTags: {}));
    } else {
      //searches.add(AlgoliaSearch.searchLibrary(search: widget.searchText));
      searches.add(AlgoliaSearch.searchMissions(
          search: widget.searchText, userTags: {}));
    }
  }

  goToMission(Mission mission) {
    Navigator.of(context).pushNamed('mission', arguments: {
      'mission': new Mission.fromMission({
        'url': mission.url,
        'image': mission.image,
        'id': mission.id,
        'level': mission.level,
        'happy': mission.happy,
        'title': mission.title,
        'body': mission.body,
        'current': mission.current,
        'limit': mission.limit,
        'target': mission.target,
        'date': mission.date,
        'expectedTime': mission.expectedTime,
        'actions': mission.actions,
        'proposedComments': mission.proposedComments,
        'missionStatus': mission.missionStatus,
        'points': mission.points,
        'completedActions': mission.completedActions,
        'tags': mission.tags
      })
    }).then((a) {
      reloadMissions();
    });
  }

  goToFile(File file) {
    //TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: globalHeight * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('Search Results')!,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * .028,
              ),
            ),
            SizedBox(
              height: globalHeight * .02,
            ),
            Expanded(
              child: FutureBuilder(
                future: Future.wait(searches),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                    //return CircularProgressIndicator();
                  } else {
                    if (true/*widget.searchByCategory*/) {
                      List<Mission> missions = (snapshot.data as Map)[0];
                      return ListView.builder(
                        itemCount: missions.length,
                        itemBuilder: (context, index) => SearchResultItem(
                          isMission: true,
                          title: missions[index].title,
                          image: missions[index].image,
                          onTap: () {
                            goToMission(missions[index]);
                          },
                        ),
                      );
                    } else {
                      List<Mission> missions = (snapshot.data as Map)[1];
                      List<File> files = (snapshot.data as Map)[0];
                      return ListView.builder(
                        itemCount: files.length + missions.length,
                        itemBuilder: (context, index) {
                          if (index < files.length) {
                            return SearchResultItem(
                              isMission: false,
                              title: files[index].name,
                              onTap: () {
                                goToFile(files[index]);
                              },
                            );
                          }
                          return SearchResultItem(
                            isMission: true,
                            title: missions[index - files.length].title,
                            image: missions[index - files.length].image,
                            onTap: () {
                              goToMission(missions[index - files.length]);
                            },
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
