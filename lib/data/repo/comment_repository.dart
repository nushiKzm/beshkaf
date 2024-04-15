import 'package:shop_project/common/http_client.dart';
import 'package:shop_project/data/comment.dart';
import 'package:shop_project/data/source/comment_data_source.dart';

final commentRepository =
    CommentRepository(CommentRemoteDataSource(httpClient));

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required String productId});
  Future<bool> add(String productId, String title, String content);
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<List<CommentEntity>> getAll({required String productId}) =>
      dataSource.getAll(productId: productId);

  @override
  Future<bool> add(String productId, String title, String content) =>
      dataSource.add(productId, title, content);
}
