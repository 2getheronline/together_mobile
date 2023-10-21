import 'package:algolia/algolia.dart';
import 'package:together_online/models/file.dart';
import 'package:together_online/models/mission.dart';


class AlgoliaSearch {

  static final Algolia algolia = Algolia.init(
      applicationId: 'VSV4EIKEO1',
      apiKey: 'e34149abed89fb45e798c149b1b81b26',
  );

//TODO: Change for production
  static final AlgoliaIndexReference missionsIndex = algolia.index('dev_missions');
  static final AlgoliaIndexReference libraryIndex = algolia.index('dev_library');


  static dynamic searchMissions({ required Map<String, bool> userTags, String search = "" }) async {
    Map<String, bool> tags = Map<String, bool>.from(userTags);
    tags.removeWhere((k,v) => !v);

    AlgoliaQuery query = missionsIndex.search(search);

    tags.forEach((k, v) => query.setFacetFilter('tags.$k:true'));

    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<Mission> results = [];
    snap.hits.forEach((AlgoliaObjectSnapshot o) => results.add(Mission.fromMission(o.data)));

    return results;
  }

  static dynamic searchMissionsByCategory({ required Map<String, bool> userTags, required List<String> categories, String search = "" }) async {
    Map<String, bool> tags = Map<String, bool>.from(userTags);
    tags.removeWhere((k,v) => !v);

    AlgoliaQuery query = missionsIndex.search(search);

    tags.forEach((k, v) => query.setFacetFilter('tags.$k:true'));
    categories.forEach((c) => query.setFilters('categories:$c'));

    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<Mission> results = [];
    snap.hits.forEach((AlgoliaObjectSnapshot o) => results.add(Mission.fromMission(o.data)));

    return results;
  }

  static dynamic searchLibrary({ String search = "" }) async {

    AlgoliaQuery query = libraryIndex.search(search);

    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<File> results = [];
    snap.hits.forEach((AlgoliaObjectSnapshot o) => results.add(File.fromJson(o.data)));

    return results;
  }
}