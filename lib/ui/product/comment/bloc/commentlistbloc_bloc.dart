import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/data/comment.dart';
import 'package:shop_project/data/repo/comment_repository.dart';

part 'commentlistbloc_event.dart';
part 'commentlistbloc_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final String productId;
  CommentListBloc({required this.repository, required this.productId})
      : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStarted) {
        emit(CommentListLoading());
        try {
          final comments = await repository.getAll(productId: productId);
          emit(CommentListSuccess(comments));
        } catch (e) {
          emit(CommentListError(AppException()));
        }
      }
      //  else if (event is CommentAddButtonCliked) {
      //   emit(CommentAddLoading());
      //   try {
      //     await repository.add(productId: productId);
      //     emit(CommentAddSuccess());
      //   } catch (e) {
      //     emit(CommentAddError(AppException()));
      //   }
      // }
    });
  }
}
