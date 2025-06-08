import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadProfileImageToFirebase(File file, String userId) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
    final metadata = SettableMetadata(contentType: 'image/jpeg');

    final uploadTask = await storageRef.putFile(file, metadata);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  } catch (e, stack) {
    print('❌ Firebase Storage 업로드 실패: $e');
    print('🔍 StackTrace: $stack');
    return null;
  }
}