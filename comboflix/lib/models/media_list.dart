import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/models/media.dart';

class MediaList {
  final String name;
  final DateTime creationDate;
  final List<Media>? content;

  const MediaList(
      {required this.name, required this.creationDate, this.content});

  MediaList copyWith(
    String? name,
    List<Media>? content,
    DateTime? creationDate,
  ) =>
      MediaList(
        name: name ?? this.name,
        creationDate: creationDate ?? this.creationDate,
        content: content ?? this.content,
      );

  MediaList.fromJson(Map<String, dynamic> json, {DocumentReference? reference})
      : name = json['name'],
        creationDate = json['creationDate'].toDate(),
        content = json['content'] != null
            ? List.from(json['content']).map((e) => Media.fromJson(e)).toList()
            : null;

  MediaList.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data()! as Map<String, dynamic>,
            reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'creationDate': this.creationDate,
        'content': this.content,
      };
}
