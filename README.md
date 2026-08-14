# NestedScrollViewDemo

## 高德地图本地运行

1. 复制 `amap_keys.example.json` 为 `amap_keys.json`，填写 Android 和 iOS Key。
2. Android Key 需绑定包名 `com.goeco.bike`，Debug SHA1 为
   `38:28:83:77:E5:A9:DF:E8:7A:28:F8:28:DF:29:7D:93:33:F0:CE:53`。
3. iOS Key 需绑定 Bundle ID `com.goeco.bike`。
4. Android Studio 选择 `main.dart (高德地图)`，或执行：

   ```sh
   flutter run --dart-define-from-file=amap_keys.json
   ```

A new Flutter project for NestedScrollView的个人资料页面demo.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
