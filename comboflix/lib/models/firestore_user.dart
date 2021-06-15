import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/models/media.dart';
import 'package:comboflix/models/media_list.dart';

class FirestoreUser {
  final String name, year, email, uid;
  final List<Media>? medias;
  final List<MediaList>? lists;

  const FirestoreUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.year,
    this.medias = const [],
    this.lists = const [],
  });

  FirestoreUser copyWith({
    String? name,
    String? year,
    String? email,
    String? uid,
    List<Media>? medias,
    List<MediaList>? lists,
  }) {
    return FirestoreUser(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      year: year ?? this.year,
      medias: medias ?? this.medias,
      lists: lists ?? this.lists,
    );
  }

  FirestoreUser.fromMap(Map<String, dynamic> map,
      {DocumentReference? reference})
      : name = map['name'],
        uid = map['uid'],
        year = map['year'],
        medias = map['medias'] != null
            ? List.from(map['medias']).map((e) => Media.fromJson(e)).toList()
            : null,
        lists = map['lists'] != null
            ? List.from(map['lists']).map((e) => MediaList.fromJson(e)).toList()
            : null,
        email = map['email'];

  FirestoreUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'email': this.email,
        'year': this.year,
        'uid': this.uid,
        'medias': this.medias,
        'lists': this.lists,
      };

  @override
  String toString() {
    return 'FirestoreUser{name: $name, year: $year, email: $email, uid: $uid, media: $medias, mediaList: $lists}';
  }
}
