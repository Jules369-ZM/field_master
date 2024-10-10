// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:net_source/net_source.dart';
import 'package:path/path.dart';
import 'package:services_repo/services_repo.dart';

import '../utils.dart';

part 'firebase_state.dart';

bool shouldUseFirebaseEmulator = false;

late final FirebaseApp firebaseApp;
late final fire_auth.FirebaseAuth authInstance;
late final FirebaseFirestore firebaseFirestore;
late final FirebaseStorage firebaseStorage;
late final FirebaseAppCheck appCheck;
String? cachedAppCheckToken;

class FirebaseCubit extends Cubit<FirebaseState> {
  FirebaseCubit({this.authRepo, this.servicesRepo})
      : super(const FirebaseState());
  final AuthRepo? authRepo;
  final ServicesRepo? servicesRepo;

  ///Notifies about changes to the user's sign-in state
  ///(such as sign-in ?or sign-out).
  StreamSubscription<fire_auth.User?>? firebaseAuthStreamSubscription;
  @override
  Future<void> close() {
    firebaseAuthStreamSubscription?.cancel();
    return super.close();
  }

  /// monitors authStateChanges
  Future<void> monitorAuthStateChanges(
    FirebaseApp app,
    fire_auth.FirebaseAuth auth,
  ) async {
    firebaseAuthStreamSubscription = auth.authStateChanges().listen((fireUser) {
      log('firebaseAuthStreamSubscription');
      log('fireUser = $fireUser');

      if (fireUser != null) {
        emit(
          state.copyWith(
            message: 'Auth State Changed',
            status: CurrentStatus.signedIn,
            fireUser: fireUser,
            auth: auth,
            app: app,
          ),
        );
      } else {
        emit(
          state.copyWith(
            message: 'Auth State Changed user null',
            status: CurrentStatus.signedOut,
            fireUser: fireUser,
            auth: auth,
            app: app,
          ),
        );
      }
    });
  }

  /// add record to firbase
  FutureOr<void> addDocument(
    JsonMap data,
    String collectionPath,
    String id,
  ) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));

      final docCollectionRef =
          firebaseFirestore.collection(collectionPath).doc(id);
      await docCollectionRef.set(data);
      emit(
        state.copyWith(
          status: CurrentStatus.success,
          message: 'success',
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CurrentStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  /// read a list record from firbase
  Stream<List<JsonMap>> readDocuments({required String collectionPath}) =>
      firebaseFirestore.collection(collectionPath).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc.data()).toSet().toList(),
          );

  /// Read a list of records from Firestore by status
  Future<List<JsonMap>> readDocumentsByStatus({
    required String collectionPath,
    required String status,
  }) async {
    try {
      // Fetch documents from Firestore based on the status
      final QuerySnapshot snapshot = await firebaseFirestore
          .collection(collectionPath)
          .where('status', isEqualTo: status) // Filter by status
          .get();

      // Map the documents to JsonMap
      return snapshot.docs.map((doc) => doc.data()! as JsonMap).toList();
    } catch (e) {
      // Handle any errors that may occur
      log('Error reading documents: $e');
      return []; // Return an empty list on error
    }
  }

  // ignore: comment_references
  /// read records [where] from firbase
  Future<List<JsonMap>> readDocumentsWhere({
    required String collectionPath,
    required String field,
    required String value,
  }) async {
    emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
    final documents = <Map<String, dynamic>>[];
    try {
      final querySnapshot = await firebaseFirestore
          .collection(collectionPath)
          .where(
            field,
            isEqualTo: value,
          )
          .get();
      final data_ = querySnapshot.docs.map((e) => e.data()).toList();
      documents.addAll(data_);
      final data = <String, dynamic>{'data': documents};
      if (state.data != null) {
        data.addAll(state.data!);
      }
      emit(
        state.copyWith(
          data: data,
          message: 'Success',
          status: CurrentStatus.success,
        ),
      );
    } catch (e) {
      log('Error getting documents: $e');
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
    return documents;
  }

  // Function to get documents based on user UID
  Future<List<Map<String, dynamic>>> getDocumentsByUserId({
    required String collectionPath,
    required String feild,
    required String value,
  }) async {
    emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
    final documents = <Map<String, dynamic>>[];

    try {
      final querySnapshot = await firebaseFirestore
          .collection(collectionPath)
          .where(feild, isEqualTo: value)
          .get();

      for (final document in querySnapshot.docs) {
        documents.add(document.data());
      }
      final data = <String, dynamic>{'data': documents};
      if (state.data != null) {
        data.addAll(state.data!);
      }
      emit(
        state.copyWith(
          data: data,
          message: 'Success',
          status: CurrentStatus.success,
        ),
      );
    } catch (e) {
      log('Error getting documents: $e');
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
    return documents;
  }

  /// read one record from firbase
  Future<JsonMap?> readDocument({
    required String collectionPath,
    required String id,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

  /// update record in firbase
  Future<void> updateDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
      final ref = firebaseFirestore.collection(collectionPath).doc(id);
      await ref.update(data);
      emit(
        state.copyWith(
          data: data,
          message: 'Success',
          status: CurrentStatus.success,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
  }

  /// replace record in firbase
  Future<void> replaceDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    await ref.set(data);
  }

  /// delete record in firbase
  Future<void> deleteDocument({
    required String collectionPath,
    required String id,
  }) async {
    final ref = firebaseFirestore.collection(collectionPath).doc(id);
    await ref.delete();
  }

  /// Count the number of documents in a collection
  Future<int> countDocuments(String collectionName) async {
    try {
      final QuerySnapshot querySnapshot =
          await firebaseFirestore.collection(collectionName).get();
      return querySnapshot.docs.length;
    } catch (e) {
      log('Error counting documents: $e');
      return 0;
    }
  }

  /// Count documents by status
  Future<Map<String, int>> countDocumentsByStatus(String collectionName) async {
    try {
      // Count documents with status 'Pending'
      final QuerySnapshot pendingSnapshot = await firebaseFirestore
          .collection(collectionName)
          .where('status', isEqualTo: 'Pending')
          .get();
      final pendingCount = pendingSnapshot.docs.length;

      // Count documents with status 'In Progress'
      final QuerySnapshot inProgressSnapshot = await firebaseFirestore
          .collection(collectionName)
          .where('status', isEqualTo: 'In Progress')
          .get();
      final inProgressCount = inProgressSnapshot.docs.length;

      // Count documents with status 'Complete'
      final QuerySnapshot completeSnapshot = await firebaseFirestore
          .collection(collectionName)
          .where('status', isEqualTo: 'Complete')
          .get();
      final completeCount = completeSnapshot.docs.length;

      // Return a map with the counts
      return {
        'Pending': pendingCount,
        'InProgress': inProgressCount,
        'Complete': completeCount,
      };
    } catch (e) {
      log('Error counting documents by status: $e');
      return {
        'Pending': 0,
        'InProgress': 0,
        'Complete': 0,
      };
    }
  }

  /// Uploads image to Firebase Storage and returns the download URL
  Future<String?> uploadImage(File imageFile, JsonMap id) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
      // Get the file extension
      final fileName = basename(imageFile.path);
      final ref = firebaseStorage.ref().child('images/$fileName');

      // Upload the image file
      final uploadTask = ref.putFile(imageFile);

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await saveImageUrlToFirestore(downloadUrl, id);
      emit(state.copyWith(status: CurrentStatus.initial));
      return downloadUrl;
    } catch (e) {
      log('Error uploading image: $e');
      emit(state.copyWith(status: CurrentStatus.error, message: e.toString()));
      return null;
    }
  }

  /// Save image URL to Firestore
  Future<void> saveImageUrlToFirestore(String downloadUrl, JsonMap id) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading));
      await firebaseFirestore.collection('images').add({
        'id': id['id'],
        'uuid': id['uuid'],
        'userName': id['email'],
        'url': downloadUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
      });
      emit(state.copyWith(status: CurrentStatus.initial, message: 'loading'));
    } catch (e) {
      log('Error saving image URL to Firestore: $e');
      emit(state.copyWith(status: CurrentStatus.error, message: e.toString()));
    }
  }

  /// Fetches a list of image URLs from Firestore
  Future<List<String>> fetchImageUrls() async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
      // Query the Firestore collection for image documents
      final QuerySnapshot snapshot =
          await firebaseFirestore.collection('images').get();

      // Extract the URLs from the documents
      final imageUrls = snapshot.docs.map((doc) {
        return doc['url'] as String; // Assuming each document has a 'url' field
      }).toList();
      emit(state.copyWith(status: CurrentStatus.initial));
      return imageUrls;
    } catch (e) {
      log('Error fetching image URLs: $e');
      emit(state.copyWith(status: CurrentStatus.error, message: e.toString()));
      return [];
    }
  }

  /// Query images by id or uuid from Firestore
  Future<List<Map<String, dynamic>>> queryImages({
    String? id,
    String? uuid,
  }) async {
    try {
      emit(state.copyWith(status: CurrentStatus.loading, message: 'loading'));
      // Check if either id or uuid is provided
      if (id == null && uuid == null) {
        log('Either id or uuid must be provided');
        return [];
      }

      // Create a query based on the provided id or uuid
      Query<Map<String, dynamic>> query =
          firebaseFirestore.collection('images');

      if (id != null) {
        query = query.where('id', isEqualTo: id);
      } else if (uuid != null) {
        query = query.where('uuid', isEqualTo: uuid);
      }

      // Execute the query
      final querySnapshot = await query.get();

      // Extract the image documents
      final images = querySnapshot.docs.map((doc) => doc.data()).toList();

      log('Query returned ${images.length} images');
      emit(state.copyWith(status: CurrentStatus.initial));
      return images;
    } catch (e) {
      log('Error querying images from Firestore: $e');
      emit(state.copyWith(status: CurrentStatus.error, message: e.toString()));
      return [];
    }
  }
}

abstract class OurDatabase {
  static final db = firebaseFirestore;

  static Future<void> create(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(document).set(data);
  }

  static Future<Map<String, dynamic>?> read(
    String collection,
    String document,
  ) async {
    final snapshot = await db.collection(collection).doc(document).get();
    return snapshot.data();
  }

  static Future<void> update(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(document).update(data);
  }

  static Future<void> replace(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(document).set(data);
  }

  static Future<void> delete(String collection, String document) async {
    await db.collection(collection).doc(document).delete();
  }
}

///diocuments
String usersDoc = 'users';
String serviceRequestDoc = 'serviceRequests';
// const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';
const kWebRecaptchaSiteKey = '6D117AF8-51F9-4FBB-B4C6-B1C239B41451';
const kDebugToken = 'aa591939-32ba-47f1-9a3c-a1094687aef8';
String message = '';
String eventToken = 'not yet';

// om.google.firebase.appcheck.debug.internal.DebugAppCheckProvider( 9048):
//Enter this debug secret into the allow list in the Firebase Console for your
// project: aa591939-32ba-47f1-9a3c-a1094687aef8
