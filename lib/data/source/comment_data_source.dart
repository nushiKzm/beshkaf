import 'package:dio/dio.dart';
import 'package:shop_project/data/comment.dart';
import 'package:shop_project/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required String productId});
  Future<bool> add(String productId, String title, String content);
}

class CommentRemoteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required String productId}) async {
    final response = await httpClient.get('user/productComments/$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    (response.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }

  @override
  Future<bool> add(String productId, String title, String content) async {
    final response =
        await httpClient.post('user/addCommentProduct/$productId', data: {
      'title': title,
      'content': content,
    });
    validateResponse(response);
    return response.data;
  }
}
