import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_trip_planner/core/errors/server_exception.dart';
import 'package:smart_trip_planner/features/auth/data/model/user_model.dart';

abstract interface class RemoteDataSoucre {
  Future<UserModel> signUpWithEmailAndPass({
    required String name,
    required String email,
    required String pass,
  });

  Future<UserModel> signInWithEmailAndPass({
    required String email,
    required String pass,
  });

  Future<UserModel?> getUserData();
}

class RemoteDataSourceImpl extends RemoteDataSoucre {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  @override
  Future<UserModel> signInWithEmailAndPass({
    required String email,
    required String pass,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUpWithEmailAndPass({
    required String name,
    required String email,
    required String pass,
  }) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final uid = res.user!.uid;

      final user = UserModel(
        uid: uid,
        name: name,
        email: email,
        password: pass,
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());

      return user;
    } catch (e) {
      throw ServerException(exception: e.toString());
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      if (_auth.currentUser != null) {
        final uid = _auth.currentUser!.uid;
        final doc = await _firestore.collection('users').doc(uid).get();
        debugPrint("${doc}");

        if (doc.exists && doc.data() != null) {
          debugPrint('nothing feathed');
          return UserModel.fromMap(doc.data()!);
        }
      }

      return null;
    } catch (e) {
      throw ServerException(exception: e.toString());
    }
  }
}
