import 'package:dio_api/model/postmodel.dart';
import 'package:get/get.dart';
import '../services/post_service.dart';

class PostController extends GetxController {
  final PostService _postService = PostService();
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  Future<void> fetchPosts() async {
    isLoading(true);
    try {
      posts.value = await _postService.fetchPosts();
    } catch (e) {
      Get.snackbar("Error", "Failed to load posts: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> createNewPost(String title, String body) async {
    try {
      final newPost = await _postService.createPost(
        PostModel(title: title, body: body, userId: 1),
      );
      posts.insert(0, newPost);
      Get.snackbar("Success", "Post Created!");
    } catch (e) {
      Get.snackbar("Error", "Failed to create post");
    }
  }

  Future<void> updatePost(int id, String title, String body) async {
    try {
      final updatedPost = await _postService.updatePost(
        id,
        PostModel(id: id, title: title, body: body, userId: 1),
      );
      int index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        posts[index] = updatedPost;
        posts.refresh();
      }
      Get.snackbar("Updated", "Post updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update post");
    }
  }

  Future<void> patchPost(int id, String title) async {
    try {
      final patched = await _postService.patchPost(id, {'title': title});
      int index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        posts[index] = patched;
        posts.refresh();
      }
      Get.snackbar("Updated", "Title updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to patch post");
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await _postService.deletePost(id);
      posts.removeWhere((p) => p.id == id);
      Get.snackbar("Deleted", "Post deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete post");
    }
  }
}
