
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider：适合提供只读值、配置、简单计算结果。
final appTitleProvider = Provider<String>((ref) {
  return 'Riverpod11 入门';
});

final counterProvider = StateProvider<int>((ref) {
  return 0;
});

// 计算属性： 依赖其他Provider 的值，自动更新
final counterMessageProvider = Provider<String>((ref) {
  final count = ref.watch(counterProvider);

  if (count == 0) {
    return '还没有点击按钮';
  }
  return '你已经点击了 $count 次';
});


class RiverPodReadPage extends ConsumerWidget {
  const RiverPodReadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

// listen 用来监听状态变化并触发一次性动作，例如 SnackBar。
    ref.listen(counterProvider, (previous, next) {
      if (next == 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已经点到 5 次了')),
        );
      }
    });

    // watch 用在 UI 构建中。Provider 变化时，界面会自动刷新。
    final title = ref.watch(appTitleProvider);

    final count = ref.watch(counterProvider);

    final message = ref.watch(counterMessageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '$count',
                  style: Theme.of(context).textTheme.displayLarge
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: () {
                ref.read(counterProvider.notifier).state++;
              },
                  child: const Text('add 1')),
              const SizedBox(height: 16),

              Text(message),
              const SizedBox(height: 16),

              const SizedBox(height: 16),

              TextButton(onPressed: () {
                ref.watch(counterProvider.notifier).state = 0;
              }, child: const Text('reset')),

              const SizedBox(height: 16),

              TextButton(onPressed: () {
                final current = ref.watch(counterProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('当前读取到：$current')),
                );
              }, child: const Text('用 read 读取一次'))
            ],
          ),
        ),
      );
  }
}
