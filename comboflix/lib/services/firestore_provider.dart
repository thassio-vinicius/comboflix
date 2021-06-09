import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreProvider {
  FirebaseFirestore firestore;
  FirebaseAuth firebaseAuth;

  FirestoreProvider(this.firestore, this.firebaseAuth);

  Future<FirestoreUser> currentUser({bool cache = true}) async {
    Map<String, dynamic>? doc = await fetchDocument(
      documentPath: firebaseAuth.currentUser!.uid,
      collectionPath: 'users',
      cache: cache,
    );

    print('uid from firestore ' + firebaseAuth.currentUser!.uid.toString());

    print("doc from firestore" + doc.toString());

    return FirestoreUser.fromMap(doc ?? {});
  }

  Stream<FirestoreUser>? currentUserStream() {
    Stream<DocumentSnapshot> stream = fetchDocumentStream(
        collectionPath: 'users', documentPath: firebaseAuth.currentUser!.uid);

    return stream.map((event) => FirestoreUser.fromSnapshot(event));
  }

  Future<void> setData({
    required String collectionPath,
    required String? documentPath,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = firestore.collection(collectionPath).doc(documentPath);
    print('$documentPath: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> deleteData({
    required String collectionPath,
    required String documentPath,
  }) async {
    final reference = firestore.collection(collectionPath).doc(documentPath);
    print('delete: $documentPath');
    await reference.delete();
  }

  Future<bool> checkDocumentExists({
    required String collectionPath,
    required String? documentPath,
  }) async {
    bool exists = false;
    try {
      await firestore
          .collection(collectionPath)
          .doc(documentPath)
          .get(GetOptions(source: Source.server))
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateData({
    required String collectionPath,
    required String? documentPath,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(collectionPath).doc(documentPath).update(data);
  }

  Stream<QuerySnapshot> fetchCollectionStream<T>({
    required String collectionPath,
  }) {
    var query = firestore.collection(collectionPath);
    return query.snapshots();
  }

  Future<List<DocumentSnapshot>> fetchCollection<T>({
    required String collectionPath,
  }) async {
    var query = await firestore.collection(collectionPath).get();
    return query.docs;
  }

  Future<Map<String, dynamic>?> fetchDocument<T>({
    required String collectionPath,
    required String? documentPath,
    bool cache = true,
  }) async {
    final DocumentReference reference =
        firestore.collection(collectionPath).doc(documentPath);
    final DocumentSnapshot snapshot = await reference
        .get(GetOptions(source: cache ? Source.serverAndCache : Source.server));
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<List<DocumentSnapshot>> fetchArrayContainsCollection<T>({
    required String collectionPath,
    required dynamic condition,
    required dynamic fieldWhere,
  }) async {
    QuerySnapshot query = await firestore
        .collection(collectionPath)
        .where(fieldWhere, arrayContains: condition.toLowerCase())
        .get();

    return query.docs;
  }

  Future<List<DocumentSnapshot>> fetchEqualToCollection<T>({
    required String collectionPath,
    required dynamic fieldWhere,
    required dynamic condition,
  }) async {
    var query = await firestore
        .collection(collectionPath)
        .where(fieldWhere, isEqualTo: condition)
        .get();

    return query.docs;
  }

  Stream<DocumentSnapshot> fetchDocumentStream<T>({
    required String collectionPath,
    required String documentPath,
  }) {
    final DocumentReference reference =
        firestore.collection(collectionPath).doc(documentPath);
    var snapshotStream = reference.snapshots();
    return snapshotStream;
  }
}
