part of 'commentlistbloc_bloc.dart';

abstract class CommentListEvent extends Equatable {
  const CommentListEvent();

  @override
  List<Object> get props => [];
}

class CommentListStarted extends CommentListEvent {}

// class CommentAddButtonCliked extends CommentListEvent {}