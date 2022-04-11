import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:helpers/helpers.dart';
import 'package:models/models.dart';

class FirebaseService {
  const FirebaseService._();

  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // ----------------------------------- Collection Reference --------------------------------------
  static final CollectionReference<CategoryModel> _categoriesCollection = _firebaseFirestore
      .collection(Collections.categories)
      .withConverter<CategoryModel>(
          fromFirestore: (snapshot, _) => CategoryModel.fromMap(snapshot.data()!),
          toFirestore: (categoryModel, _) => categoryModel.toMap());

  // ----------------------------------- Methods --------------------------------------

  static Future<dynamic> uploadCategories({required List<CategoryModel> categories, required}) async {
    try {
      DialogHelper.showLoadingDialog(message: 'Uploading categories');

      for (final CategoryModel category in categories) {
        final DocumentReference categoryReference = await _categoriesCollection.add(category);

        await categoryReference.update({'categoryID': categoryReference.id});
      }

      DialogHelper.closeDialog();
    } on FirebaseException catch (e) {
      DialogHelper.closeDialog();
      "Image Upload Firebase Error --> $e".log();
      return null;
    } catch (e, st) {
      DialogHelper.closeDialog();
      DialogHelper.showSnackBar(
        'Unknown Error',
        'Some unknown error occured while uploading categories.',
        dialogType: DialogType.warning,
      );
      "Category Upload Error --> $e\n$st".log();
      return null;
    }
  }

  /// This method will upload the file and will return the download url from firestore
  static Future<String?> uploadFile({
    required File file,
    required String name,
    required String fileType,
    required String path,
  }) async {
    try {
      DialogHelper.showLoadingDialog(message: 'Uploading image');

      final String fileName = "$name.$fileType";

      final Reference reference = _firebaseStorage.ref().child(path).child('/$fileName');

      final metaData = SettableMetadata(
        contentType: 'file/$fileType',
      );

      reference.putFile(file, metaData);

      final String link = await getDownloadUrl(fileName, path);

      DialogHelper.closeDialog();

      return link;
    } on FirebaseException catch (e) {
      "Image Upload Firebase Error --> $e".log();
      return null;
    } catch (e, st) {
      DialogHelper.showSnackBar(
        'Unknown Error',
        'Some unknown error occured while uploading image.',
        dialogType: DialogType.warning,
      );
      "Image Upload Error --> $e\n$st".log();
      return null;
    }
  }

  static Future<String> getDownloadUrl(String name, String path) async {
    ListResult list = await _firebaseStorage.ref().child(path).listAll();

    if (list.items.last.name == name) {
      return await _firebaseStorage.ref().child(path).child("/$name").getDownloadURL();
    } else {
      return await getDownloadUrl(name, path);
    }
  }
}
