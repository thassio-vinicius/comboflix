import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/utils/strings.dart';

class Media {
  final String name, genre, type, language, description;
  final int year, ageRestriction;
  final DateTime creationDate;
  final double rating;

  const Media({
    required this.name,
    required this.genre,
    required this.type,
    required this.language,
    required this.year,
    required this.ageRestriction,
    required this.rating,
    required this.creationDate,
    this.description = Strings.noDescription,
  });

  Media copyWith(
    String? name,
    String? genre,
    String? type,
    String? language,
    int? year,
    int? ageRestriction,
    String? description,
    double? rating,
    DateTime? creationDate,
  ) {
    return Media(
      name: name ?? this.name,
      genre: genre ?? this.genre,
      type: type ?? this.type,
      language: language ?? this.language,
      year: year ?? this.year,
      ageRestriction: ageRestriction ?? this.ageRestriction,
      rating: rating ?? this.rating,
      creationDate: creationDate ?? this.creationDate,
      description: description ?? this.description,
    );
  }

  Media.fromJson(Map<String, dynamic> json, {DocumentReference? reference})
      : name = json['name'],
        genre = json['genre'],
        type = json['type'],
        language = json['language'],
        year = json['year'],
        ageRestriction = json['ageRestriction'],
        rating = json['rating'],
        creationDate = json['creationDate'],
        description = json['description'];

  Media.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data()! as Map<String, dynamic>,
            reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'genre': this.genre,
        'type': this.type,
        'language': this.language,
        'year': this.year,
        'ageRestriction': this.ageRestriction,
        'creationDate': this.creationDate,
        'rating': this.rating,
        'description': this.description,
      };

  @override
  String toString() {
    return 'Media{name: $name, gender: $genre, type: $type, language: $language, description: $description, year: $year, ageRestriction: $ageRestriction, creationDate: $creationDate, rating: $rating}';
  }
}
