

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


// FutureProvider：适合一次性异步加载。
final latestArticlesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  // 用延迟模拟网络请求。
  await Future<void>.delayed(const Duration(seconds: 3));
    return ['article_001', 'article_002', 'article_003'];
});

final tickingSecondsProvider = StreamProvider.autoDispose<int>((ref) async* {
  var value = 0;

  while(true) {
    await Future<void>.delayed(Duration(seconds: 1));
    value++;
    // yield 会把新的秒数推送给 UI。
    yield value;
  }
});

// StateProvider：保存当前选择的文章 ID。
final selectedArticleIdProvider = StateProvider<String>((ref) {
  return 'article_001';
});

// family： 让provider 接收外部参数
final articleDetailProvider = FutureProvider.autoDispose.family<String, String>(
    (ref,
    articleId,
    ) async {
      await Future<void>.delayed(const Duration(seconds: 5));
      return '这是 $articleId 的详情内容';
    }
);


final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<String>>(
  // 模拟首次进入页面时从本地或网络加载数据。
TodoListNotifier.new
);

class TodoListNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return ['学习 Provider', '学习 FutureProvider'];
  }

  Future<void> addTodo() async {
    final oldItems = state.value ?? <String>[];
    final nextIndex = oldItems.length + 1;

    state = const AsyncLoading();

    await Future<void>.delayed(const Duration(seconds: 1));
    
    state = AsyncData([...oldItems, '新任务 $nextIndex']);
  }

  Future<void> clear() async {
    state = const AsyncData([]);
  }
}

class RiverPodAsyncPage extends ConsumerWidget {
  const RiverPodAsyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 本步先准备页面结构，后面再逐步 watch 异步 Provider。
    
    final articlesState = ref.watch(latestArticlesProvider);

    // watch StreamProvider 后，同样会拿到 AsyncValue。
    final secondsState = ref.watch(tickingSecondsProvider);

    // 选中的文章 ID 变化时，Radio 和详情都会更新。
    final selectedId = ref.watch(selectedArticleIdProvider);

    final detailState = ref.watch(articleDetailProvider(selectedId));

    // watch AsyncNotifierProvider 后，UI 拿到 AsyncValue<List<String>>。
    final todoState = ref.watch(todoListProvider);
    /*
    autoDispose: 表示： 当没有widget继续监听这个Provider时，它可以被自动注销
    详情页数据，搜索结果，临时筛选结果适合autoDispose
    全局Dio客户端，全局路由对象，应用级配置不适合随便autoDispose
     */

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 异步入门')),
      body:ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Divider(height: 32),
          Text(
            'AsyncNotifierProvider：异步待办',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          todoState.when(
              data: (data) => Column(
                children: [
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton(onPressed: () {
                        ref.watch(todoListProvider.notifier).addTodo();
                      }, child: Text('add Task')),

                      OutlinedButton(onPressed: () {
                        ref.watch(todoListProvider.notifier).clear();
                      }, child: Text('clear'))
                    ],
                  ),

                  if(data.isEmpty)
                    const Text('暂无任务')
                  else
                    for(final item in data) Text('- $item'),
                ],
              ),
              error:(error, _) => Text('加载失败：$error'),
              loading:() => const Center(child: CircularProgressIndicator()),
          ),
          secondsState.when(
              data: (value) => Text('StreamProvider：已经过 $value 秒'),
              error: (error, stackTrace) => Text('秒表错误：$error'),
              loading: () => const Text('秒表启动中...'),
          ),
          const SizedBox(height: 32),
          Text(
            'FutureProvider：文章列表',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          articlesState.when(
             data: (articles) => RadioGroup(
               // Flutter 3.35 起，RadioGroup 统一管理当前选中值。
             groupValue: selectedId,
                 onChanged: (value) {
                   if (value == null) {
                     return;
                   }
                   // 点击 Radio 时，只修改一次选中状态，用 read。
                   ref.read(selectedArticleIdProvider.notifier).state = value;
                 },
                 child: Column(
                   children: [
                     Text('当前选中：$selectedId'),
                     for (final id in articles) ListTile(title: Text(id)),

                        // RadioListTile<String>(
                        //   value: id,
                        //   title: Text(id),
                        // ),

                   ],
                 )
             ),

             error: (error, stackTrace) => Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('load failure: $error'),
                 TextButton(onPressed: () {
                   // invalidate 会让 Provider 失效并重新执行。
                   ref.invalidate(latestArticlesProvider);
                 }, child: const Text('retried'))
               ],
             ),
             loading: () => const Center(child: CircularProgressIndicator()),
         ),
          const Divider(height: 32),
          Text(
            'family：当前详情',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          detailState.when(
              data: (detail) => Text(detail),
              error: (error, stackTrace) => Text('详情错误：$error'),
              loading: () => const Text('详情加载中...'),
          )
        ],
      ),
    );
  }

}
