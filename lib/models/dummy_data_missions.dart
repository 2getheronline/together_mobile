
// Mission m1 = Mission({
//   'title':
//       'Pay No Mind To The Fake Ruckus About a Phony Israel Anti-Boycott Law',
//   'image':
//       'https://static01.nyt.com/images/2019/07/28/world/28BDS/merlin_158470698_f83435c5-0e6c-46db-810d-0c8cb027e684-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
//   'subtitle':
//       'The ACLU, The Intercept and AIPAC are all yelling about a nothingburger of a bill that fights an imaginary boycott, and no one is making any sense.',
//   'current': 95,
//   'limit': 100,
//   'date': Timestamp.now(),
//   'target': 'Instagram',
//   'actions': [Actions['COMMENT'], Actions['DISLIKE']],
//   'id': '0',
//   'level': 3,
//   'happy': false,
//   'expectedTime': 2.5,
// });
// Mission m2 = Mission({
//   'title':
//       'Palestinians, Jews, citizens of Israel, join the Palestinian call for a BDS campaign against Israel',
//   'image':
//       'https://assets.nst.com.my/images/articles/13ntboycott_1550067699.jpg',
//   'subtitle':
//       'Some progressives are up in arms about a new law that would make it a crime to boycott Israel. Trouble is, theres no such thing.',
//   'current': 15,
//   'limit': 230,
//   'date': Timestamp.now(),
//   'target': 'Twitter',
//   'actions': [Actions['REPORT'], Actions['DISLIKE']],
//   'id': '1',
//   'level': 4,
//   'happy': false,
//   'expectedTime': 2.0,
// });
// Mission m3 = Mission({
//   'title':
//       'STUDENTS, STAFF AT UK UNIVERSITY VOTE TO BAN CONTACT WITH ISRAELI INSTITUTIONS',
//   'image':
//       'https://images.jpost.com/image/upload/f_auto,fl_lossy/t_Article2016_Control/260715',
//   'subtitle':
//       'Result not binding, says administration of School of Oriental and African Studies.',
//   'current': 112,
//   'limit': 230,
//   'date': Timestamp.now(),
//   'target': 'Facebook',
//   'actions': [Actions['REPORT'], Actions['COMMENT']],
//   'id': '2',
//   'level': 1,
//   'happy': true,
//   'expectedTime': 0.5,
// });
// Mission m4 = Mission({
//   'title':
//       'Hate-motivated graffiti – including swastikas and other racist and vulgar drawings – was found spray painted on a school in Mississauga.',
//   'image':
//       'https://assets-global.website-files.com/578f91a7337a79e75e95a0e4/5cb1164faa806803e4ac2b5b_Antisemitic%20campaign%20at%20Stephen%20Lewish%20Secondary%20School.PNG',
//   'subtitle':
//       'In April 2019, FSWC was notified by community members about an antisemitic campaign that was taking place at Stephen Lewis Secondary School in Mississauga. The campaign, which promotes the false and antisemitic idea that Israel conducts ‘human testing’ of medicine on Palestinian prisoners, was reportedly being promoted by students on social media and inside the school as part of a school project.',
//   'current': 1000,
//   'limit': 8000,
//   'date': Timestamp.now(),
//   'target': 'Site',
//   'actions': [Actions['LIKE']],
//   'id': '3',
//   'level': 5,
//   'happy': false,
//   'expectedTime': 1.5,
// });

// List<Mission> dummyMissions = [
//   Mission({
//     'title':
//         'Pay No Mind To The Fake Ruckus About a Phony Israel Anti-Boycott Law',
//     'image':
//         'https://static01.nyt.com/images/2019/07/28/world/28BDS/merlin_158470698_f83435c5-0e6c-46db-810d-0c8cb027e684-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
//     'subtitle':
//         'The ACLU, The Intercept and AIPAC are all yelling about a nothingburger of a bill that fights an imaginary boycott, and no one is making any sense.',
//     'current': 95,
//     'limit': 100,
//     'date': Timestamp.now(),
//     'target': 'Instagram',
//     'actions': [Actions['COMMENT'], Actions['DISLIKE']],
//     'id': '0',
//     'level': 3,
//     'happy': false,
//     'expectedTime': 2.5,
//   }),
// ];

class DummyPerson {
  final String? name;
  final int? points;
  final String? imageUrl;

  DummyPerson({this.imageUrl, this.name, this.points});
}

List<DummyPerson> dummyPersonsList = [
  DummyPerson(
      name: 'Daniel Vofchuk',
      points: 1902,
      imageUrl: 'https://randomuser.me/api/portraits/men/55.jpg'),
  DummyPerson(
      name: 'Michael Kullock',
      points: 938,
      imageUrl: 'https://randomuser.me/api/portraits/men/75.jpg'),
  DummyPerson(
      name: 'David Zimberknopf',
      points: 856,
      imageUrl: 'https://randomuser.me/api/portraits/men/15.jpg'),
  DummyPerson(
      name: 'Naftali Kugelmann',
      points: 802,
      imageUrl: 'https://thispersondoesnotexist.com/image'),
  DummyPerson(
      name: 'Itzik Ben Yaakov',
      points: 546,
      imageUrl: 'https://randomuser.me/api/portraits/men/25.jpg'),
  DummyPerson(
      name: 'Yossef Levi',
      points: 102,
      imageUrl: 'https://randomuser.me/api/portraits/men/35.jpg'),
  DummyPerson(
      name: 'Avi Segal',
      points: 15,
      imageUrl: 'https://randomuser.me/api/portraits/men/45.jpg'),
  DummyPerson(
      name: 'Eduardo Vofchuk',
      points: 3,
      imageUrl: 'https://randomuser.me/api/portraits/men/18.jpg'),
];
