

import 'package:equatable/equatable.dart';
import 'package:first_project/bloc/GitHub/GithubEventModel.dart';

sealed class GithubEventState extends Equatable {
  final List<GithubEventModel> githubEvents;
  const GithubEventState(this.githubEvents);

  @override
  // TODO: implement props
  List<Object?> get props => [githubEvents];
}

final class GithubEventInitial extends GithubEventState {
  const GithubEventInitial() : super(const []);
}

final class GithubEventLoading extends GithubEventState {
  const GithubEventLoading() : super(const []);
}

final class GithubEventLoaded extends GithubEventState {
  const GithubEventLoaded(super.githubEvents);
}

final class GithubEventError extends GithubEventState {
  final String message;
  const GithubEventError(this.message, super.githubEvents);

  @override
  // TODO: implement props
  List<Object?> get props => [message, ...githubEvents];
}



