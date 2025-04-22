



import 'package:bloc/bloc.dart';
import 'package:first_project/bloc/GitHub/GithubEventModel.dart';
import 'package:first_project/bloc/GitHub/GithubEventRepository.dart';
import 'package:first_project/bloc/GitHub/GithubEventState.dart';

class GithubEventCubit extends Cubit<GithubEventState> {

  final GithubEventRepository _githubEventRepository = GithubEventRepository();
  int _page = 1;
  bool _isLoadMore = false;

  GithubEventCubit() : super(const GithubEventInitial());


  Future<void> fetchGithubEvents() async {
    try {
      emit(const GithubEventLoading());
      _page = 1;
      final events = await _githubEventRepository.fetchGithubEvents(page: _page);
      emit(GithubEventLoaded(events));
    } on Exception catch (e) {
      emit(GithubEventError(e.toString(), state.githubEvents));
    }
  }

  Future<void> loadMoreGithubEvents() async {
    if (_isLoadMore) return;
    _isLoadMore = true;
    try {
      _page ++;
      final events = await _githubEventRepository.fetchGithubEvents(page: _page);
      emit(GithubEventLoaded([...state.githubEvents, ...events]));
    } on Exception catch (e) {
       emit(GithubEventError(e.toString(), state.githubEvents));
    } finally {
      _isLoadMore = false;
    }
  }

  void removeGithubEventItem(GithubEventModel githubEventModel) {
    final List<GithubEventModel> githubEvents = List.from(state.githubEvents);
    githubEvents.remove(githubEventModel);
    emit(GithubEventLoaded(githubEvents));
  }

}