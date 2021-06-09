import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  final String name, year, email, uid;

  const FirestoreUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.year,
  });

  FirestoreUser copyWith({
    String? name,
    String? year,
    String? email,
    String? uid,
  }) {
    return FirestoreUser(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      year: year ?? this.year,
    );
  }

  FirestoreUser.fromMap(Map<String, dynamic> map,
      {DocumentReference? reference})
      : name = map['name'],
        uid = map['uid'],
        year = map['year'],
        email = map['email'];

  FirestoreUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'email': this.email,
        'year': this.year,
        'uid': this.uid,
      };

  @override
  String toString() {
    return 'FirestoreUser{name: $name, year: $year, email: $email, uid: $uid}';
  }
}
