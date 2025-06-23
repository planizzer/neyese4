// lib/data/repositories/firestore_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neyese4/data/models/saved_recipe.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Anlık giriş yapmış kullanıcının ID'sini alır.
  String? get _userId => _auth.currentUser?.uid;

  // Firestore'da kullanıcının tarifler koleksiyonuna bir referans.
  CollectionReference<SavedRecipe> _getRecipesCollection() {
    final userId = _userId;
    if (userId == null) {
      throw Exception('Kullanıcı giriş yapmamış.');
    }
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_recipes')
        .withConverter<SavedRecipe>(
      fromFirestore: (snapshot, _) => SavedRecipe.fromJson(snapshot.data()!),
      toFirestore: (recipe, _) => recipe.toJson(),
    );
  }

  // Firestore'a yeni bir tarif kaydeder.
  Future<void> saveRecipe(SavedRecipe recipe) async {
    await _getRecipesCollection().doc(recipe.id.toString()).set(recipe);
  }

  // Firestore'dan bir tarifi siler.
  Future<void> deleteRecipe(int recipeId) async {
    await _getRecipesCollection().doc(recipeId.toString()).delete();
  }

  // Bir tarifin kayıtlı olup olmadığını kontrol eder.
  Future<bool> isRecipeSaved(int recipeId) async {
    final doc = await _getRecipesCollection().doc(recipeId.toString()).get();
    return doc.exists;
  }

  // Kaydedilmiş tüm tarifleri anlık olarak dinleyen bir Stream döndürür.
  Stream<List<SavedRecipe>> getSavedRecipesStream() {
    return _getRecipesCollection()
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}