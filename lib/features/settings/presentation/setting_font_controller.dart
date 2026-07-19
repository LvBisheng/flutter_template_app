import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage.dart';
import '../../../shared/ui/screen/screen_config.dart';

const _fontScaleStorageKey = 'app.font.scale';

/// 字体大小档位（类似微信）
///
/// 参考微信的字体大小设置：
/// - 小：0.85
/// - 标准：1.0（默认）
/// - 大：1.15
/// - 特大：1.3
/// - 巨大：1.5
enum FontSizeOption {
  small('small', 0.85),
  standard('standard', 1.0),
  large('large', 1.15),
  extraLarge('extraLarge', 1.3),
  huge('huge', 1.5);

  const FontSizeOption(this.storageValue, this.scale);

  final String storageValue;
  final double scale;

  static FontSizeOption fromStorage(String? value) {
    for (final option in values) {
      if (option.storageValue == value) return option;
    }
    return FontSizeOption.standard;
  }
}

/// 字体大小状态
class FontSizeState {
  const FontSizeState({required this.option});

  final FontSizeOption option;
  double get scale => option.scale;
}

final settingFontControllerProvider =
    NotifierProvider<SettingFontController, FontSizeState>(
      SettingFontController.new,
    );

/// 字体大小控制器。
///
/// 功能：
/// 1. 持久化字体大小设置
/// 2. 同步更新 ScreenConfig.customFontScale
/// 3. 支持类似微信的 5 档字体大小
class SettingFontController extends Notifier<FontSizeState> {
  @override
  FontSizeState build() {
    final option = FontSizeOption.fromStorage(
      LocalStorage.getString(_fontScaleStorageKey),
    );
    // 初始化时同步到 ScreenConfig（确保 APP 启动时字体设置正确）
    ScreenConfig.customFontScale = option.scale;
    return FontSizeState(option: option);
  }

  /// 选择字体大小
  Future<void> select(FontSizeOption option) async {
    // 1. 更新状态（触发 UI 重建）
    state = FontSizeState(option: option);

    // 2. 同步到 ScreenConfig（立即生效）
    ScreenConfig.customFontScale = option.scale;

    // 3. 持久化存储
    await LocalStorage.setString(_fontScaleStorageKey, option.storageValue);
  }

  /// 重置为标准大小
  Future<void> reset() async {
    await select(FontSizeOption.standard);
  }
}
