import 'package:dio/dio.dart';
import 'package:dio_api/constant/api_constant.dart';
import 'package:dio_api/model/postmodel.dart';

class PostService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // GET
  Future<List<PostModel>> fetchPosts() async {
    final response = await _dio.get(ApiConstants.postsEndpoint);
    final List data = response.data;
    return data.map((e) => PostModel.fromJson(e)).toList();
  }

  // POST
  Future<PostModel> createPost(PostModel post) async {
    final response = await _dio.post(
      ApiConstants.postsEndpoint,
      data: post.toJson(),
    );
    return PostModel.fromJson(response.data);
  }

  // PUT
  Future<PostModel> updatePost(int id, PostModel post) async {
    final response = await _dio.put(
      '${ApiConstants.postsEndpoint}/$id',
      data: post.toJson(),
    );
    return PostModel.fromJson(response.data);
  }

  // PATCH
  Future<PostModel> patchPost(int id, Map<String, dynamic> updates) async {
    final response = await _dio.patch(
      '${ApiConstants.postsEndpoint}/$id',
      data: updates,
    );
    return PostModel.fromJson(response.data);
  }

  // DELETE
  Future<void> deletePost(int id) async {
    await _dio.delete('${ApiConstants.postsEndpoint}/$id');
  }
}
