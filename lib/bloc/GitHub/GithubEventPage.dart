import 'package:first_project/bloc/GitHub/GithubEventCubit.dart';
import 'package:first_project/bloc/GitHub/GithubEventModel.dart';
import 'package:first_project/bloc/GitHub/GithubEventState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GithubEventPage extends StatelessWidget {
  const GithubEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      GithubEventCubit()
        ..fetchGithubEvents(),
      child: const GithubEventView(),
    );
  }
}

class GithubEventView extends StatefulWidget {
  const GithubEventView({super.key});

  @override
  State<GithubEventView> createState() => _GithubEventViewState();
}

class _GithubEventViewState extends State<GithubEventView> {

  late ScrollController _scrollController;
  bool _isShopTopBtn = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scroll);
  }

  void _scroll() {
    if (_scrollController.position.pixels > MediaQuery
        .of(context)
        .size
        .height) {
      setState(() {
        _isShopTopBtn = true;
      });
    } else {
      setState(() {
        _isShopTopBtn = false;
      });
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<GithubEventCubit>().loadMoreGithubEvents();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut);
  }

  void _onShare(GithubEventModel event) {
    // Share.share(event.repoUrl);
  }


  Future<void> _onCopy(GithubEventModel event) async {
    await Clipboard.setData(
      ClipboardData(
        text: "nam"
            "e: ${event.username}\navatar: ${event.avatarUrl}\nrepo: ${event
            .repoUrl}",
      ),
    );
    if (await Clipboard.hasStrings()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Copied Successfully"),
              duration: Duration(seconds: 1))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github Event'),
      ),
      body: BlocBuilder<GithubEventCubit, GithubEventState>(
          builder: (context, state) {
            if (state is GithubEventLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GithubEventError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            if (state is GithubEventLoaded) {
              return RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.githubEvents.length,
                      itemBuilder: (context, index) {
                        final event = state.githubEvents[index];
                        return Dismissible(
                            key: ValueKey(event.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 25.0),
                              child: const Icon(CupertinoIcons.trash, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              context.read<GithubEventCubit>().removeGithubEventItem(event);
                            },
                            child: Material(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                  maxHeight: 80
                                ),
                                child: CupertinoContextMenu(
                                    actions: [
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                        _onCopy(event);
                                        Navigator.pop(context);
                                      },
                                          child: const Text("Copy")),

                                      CupertinoContextMenuAction(
                                        child: const Text("Share"),
                                        onPressed: () => _onShare(event),
                                      ),

                                    ],
                                    child: Container(
                                      color: Colors.transparent,
                                      width: double.infinity,
                                      height: 80,
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                        title: Text(event.username),
                                        subtitle: Text(event.repoUrl),
                                        leading: _buildAvatar(event.avatarUrl),
                                      ),
                                    )),
                              ),
                            )
                        );
                      }),
                  onRefresh: () =>
                      context.read<GithubEventCubit>().fetchGithubEvents());
            }
            
            return const Center(child: Text('No events'));
          }),
      
      floatingActionButton: _isShopTopBtn ? FloatingActionButton(
          onPressed: _scrollToTop,
          child: const Icon(Icons.arrow_circle_up),
      ) : null,
    );
  }

  // 关键修改4：封装图片组件
  Widget _buildAvatar(String url) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          url,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: frame != null
                  ? child
                  : Container( // 强制占位符尺寸
                width: 48,
                height: 48,
                color: Colors.grey[200],
              ),
            );
          },
          errorBuilder: (_, __, ___) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
