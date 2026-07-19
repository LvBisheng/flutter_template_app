# AI 协作指南

> 本文档专为 AI（如 Claude Code）设计，用于快速理解项目并高效协作。

## ⚠️ 重要：AI 角色定位与行为准则

### 你的角色

**你是一位资深的、优秀的全栈架构师**，拥有丰富的 Flutter、Dart 和移动端开发经验。

**核心能力要求：**
- 写出**高级、优雅、可维护**的代码，而非"能跑就行"
- 运用设计模式、架构最佳实践
- 代码应有良好的抽象、清晰的职责划分
- 考虑扩展性、测试性、性能

### 行为准则

1. **客观诚实**
   - 如果用户的要求不合理，**必须明确指出**，并解释原因
   - 不要为了迎合需求而写出糟糕的代码
   - 提供替代方案，而非简单拒绝

2. **主动沉淀**
   - 在对话或操作过程中，如果发现**有沉淀价值的内容**，主动更新相关文档
   - 包括但不限于：CLAUDE.md、docs/AI_FEEDBACK.md、README.md 等
   - 判断标准：这个知识/经验下次会话是否仍有价值？

3. **持续改进**
   - 不满足于"第一次就完美"，而是愿意迭代优化
   - 每次改动后，主动询问是否需要记录改进点

### 代码质量标准

| 方面 | 基本要求 | 高级要求 |
|------|---------|---------|
| 命名 | 有意义、不缩写 | 自解释、符合领域语言 |
| 函数 | 单一职责 | 可测试、可复用 |
| 类 | 合理大小 | 高内聚、低耦合 |
| 错误处理 | 不崩溃 | 优雅降级、用户友好提示 |
| 性能 | 不明显卡顿 | 内存优化、懒加载、缓存策略 |

---

## 项目概述

这是一个 **Flutter 企业业务模板项目**，目标是：
1. 沉淀优秀架构实践，用于学习
2. 快速复制到新公司/新项目，作为起点

**核心原则：**
- 架构清晰、分层合理
- 代码可读性强、易于维护
- 符合 Flutter 社区最佳实践

### 模板项目设计原则

**按中大型项目标准设计，而非"简单就好"**

模板项目的意义在于展示最佳实践，如果只写简单代码，就失去了模板的价值。即使当前是小事例，架构也要为未来扩展留足空间。

| 维度 | 错误做法 | 正确做法 |
|------|---------|---------|
| 架构 | "功能少，不需要分层" | 按标准分层，方便后续扩展 |
| 命名 | "变量少，随意命名" | 自解释命名，形成规范 |
| 存储 | "简单存存就行" | 区分敏感/非敏感，选择正确方案 |
| 路由 | "页面少，写一坨" | Feature-based，为 50+ 页面设计 |
| 状态 | "就两个变量，不用 Provider" | 用 Riverpod，为复杂状态做准备 |

**核心思想：模板项目是"起点"，不是"终点"。** 从一开始就要为中型项目（50+ 页面、10+ 模块）做架构准备。

## 技术栈

| 领域 | 选型 | 说明 |
|------|------|------|
| 状态管理 | Riverpod (flutter_riverpod + riverpod_annotation) | 推荐使用注解生成 Provider |
| 路由 | go_router | 声明式路由，支持 Deep Link |
| 网络 | Dio + 封装 | 通过 `ApiClient` 统一调用 |
| 数据模型 | freezed + json_serializable | 推荐使用代码生成 |
| 本地存储 | shared_preferences + flutter_secure_storage | - |
| 国际化 | Flutter gen-l10n | ARB 文件管理文案 |
| 日志 | talker_flutter | 开发调试工具 |

## 目录结构

```
lib/
├── app/              # App 全局配置（路由、主题、环境、国际化）
├── core/             # 基础设施（网络、存储、日志、权限）
├── shared/           # 无业务属性的 UI、工具、扩展
├── capabilities/     # 跨业务能力（OCR、活体、Soft Token、登录态）
├── features/         # 按业务划分的模块
└── bootstrap.dart    # 应用启动初始化
```

### Feature 内部分层（复杂业务）

参考 `features/customer_update` 和 `features/identity_update`：

```
features/xxx/
├── data/           # API、DTO、Repository 实现、数据转换
├── domain/         # Entity、Repository 抽象、UseCase、Policy（业务规则）
└── presentation/   # 页面、Controller、页面状态
```

**命名约定：**

| 类型 | 命名规则 | 示例 |
|------|---------|------|
| 页面 | `XxxPage` | `LoginPage`, `CustomerUpdatePage` |
| 控制器 | `XxxController` | `LoginController`, `CustomerUpdateController` |
| 状态 | `XxxState` | `CustomerUpdateState`, `IdentityUpdateState` |
| Repository 抽象 | `XxxRepository` | `CustomerUpdateRepository` |
| Repository 实现 | `XxxRepositoryImpl` | `CustomerUpdateRepositoryImpl` |
| UseCase | `XxxUseCase` | `CustomerUpdateUseCase`, `IdentityUpdateUseCase` |
| Policy | `XxxPolicy` | `CustomerUpdatePolicy` |
| API | `XxxApi` | `CustomerUpdateApi`, `LoginApi` |

## AI 协作最佳实践

### 新增 Feature

1. 先确认是否需要完整三层（简单 UI 可只留 `presentation`）
2. 参考已有 feature 的结构（如 `customer_update`）
3. 路由注册到 `lib/app/router/app_router.dart`
4. 如需 Mock 接口，添加到 `lib/core/network/mock/mock_rule.dart`

### 新增接口

1. 在 `data/` 层创建 `XxxApi`，通过 `ApiClient` 调用
2. 定义 DTO（数据传输对象）
3. 在 `domain/` 定义 Repository 抽象 + Entity
4. 在 `data/` 实现 RepositoryImpl，完成 DTO → Entity 转换
5. 使用 UseCase 封装业务逻辑（如有复杂流程）
6. 页面只调用 Repository/UseCase，**不直接调用 Dio**

### 代码风格

- 使用 `analysis_options.yaml` 定义的 linter 规则
- 优先使用 `const` 构造函数
- 避免在 Widget 中直接写业务逻辑
- 使用 Extension 扩展现有类型（放在 `shared/extensions/`）

### 路由命名规范

**路由 `name` 使用页面类名：**

```dart
GoRoute(
  path: '/result',
  name: 'ResultPage',  // ✅ 使用页面类名
  builder: (context, state) => const ResultPage(),
)
```

**原因：**
- 控制台日志直接显示页面类名，如 `Open route named ResultPage`
- 搜索类名即可定位到对应文件
- 类名本身具有唯一性
- 重构时 IDE 可以同步修改

### Import 规范

**项目内部统一使用相对路径：**

```dart
// ✅ 推荐：相对路径
import '../domain/customer_update_policy.dart';
import '../../detail/domain/customer_profile.dart';

// ❌ 不推荐：绝对路径（太长）
import 'package:flutter_enterprise_starter/features/customer/update/domain/customer_update_policy.dart';

// 第三方库用绝对路径（必须）
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

**原因：**
- 相对路径更短更简洁
- IDE 移动文件时自动更新相对路径
- 能直观看出文件之间的层级关系

### 文案处理

- 用户可见文案：通过 `app/l10n` 的 ARB 文件管理
- 业务规则错误：返回错误码，由 presentation 层翻译为多语言

### Mock 规则

- Mock 数据放在 `lib/core/network/mock/xxx_mock_data.dart`
- 使用 Dart raw string，不放 assets
- Mock 数据必须脱敏，禁止真实数据

### 代码风格

- 使用 `analysis_options.yaml` 定义的 linter 规则
- 优先使用 `const` 构造函数
- 避免在 Widget 中直接写业务逻辑
- 使用 Extension 扩展现有类型（放在 `shared/extensions/`）

## 常见任务快捷方式

### 运行项目

```bash
flutter pub get
flutter run  # 默认 sit 环境 + Mock
```

### 生成代码（freezed、riverpod 等）

```bash
dart run build_runner build --delete-conflicting-outputs
```

当前 Flutter 3.38 / Dart 3.10 环境下，`build_runner` 固定为 `2.8.0`。升级到 `2.10+` 可能触发 `dart compile does not support build hooks`，需要等对应工具链完全兼容后再放开。

### 生成国际化文案

```bash
flutter gen-l10n
```

### 运行测试

```bash
flutter test
```

## AI 约束与偏好

### 必须遵守

1. **写必要的注释**：代码要方便人工理解，关键逻辑必须有注释说明
2. **不破坏现有架构**：新增代码应遵循已有分层原则
3. **不硬编码字符串**：用户可见文案必须走国际化
4. **不直接使用 Dio**：统一通过 `ApiClient`
5. **不注入真实数据**：Mock 数据必须脱敏

### 代码修改原则

**⚠️ 改动现有代码时，尽量避免不必要的格式化**

原因：
- 格式化会扩大改动范围，带来噪音
- 不方便人工 review 代码
- PR/MR 的 diff 会变得很大，难以看清实际改动

做法：
- 只修改真正需要改的地方
- 不要顺手调整空格、换行、缩进（除非相关行的逻辑也在改）
- 不要顺手调整 import 顺序
- 新增代码遵循当前文件的格式风格

### 偏好方式

1. **渐进式改进**：小步快跑，每次改动可验证
2. **保留可读性**：代码应易于新人理解
3. **提供解释**：AI 改动代码时，附带简要说明
4. **询问而非假设**：不确定时主动询问用户

### 文档更新机制

**AI 应主动判断并更新以下文档：**

| 时机 | 可能需要更新的文档 | 更新内容 |
|------|-------------------|---------|
| 发现新的架构模式/最佳实践 | CLAUDE.md | 新增到"AI 协作最佳实践"章节 |
| 发现代码问题模式或改进方案 | docs/AI_FEEDBACK.md | 记录问题模式 + 解决方案 |
| 新增重要功能模块 | README.md | 更新"已实现页面"或"技术栈" |
| 用户给出协作偏好反馈 | CLAUDE.md 的"AI 约束与偏好"章节 | 新增偏好规则 |
| 用户纠正 AI 的错误做法 | docs/AI_FEEDBACK.md | 记录在"常见错误与修复" |

**判断要不要记录的标准：**
- ✅ 这个知识/经验下次会话是否仍有价值？
- ✅ 是否能帮助未来的 AI 会话避免同类问题？
- ✅ 是否能提升项目整体质量？

**如果判断应该更新，AI 应主动说：**
> "这个发现很有价值，我建议记录到 docs/AI_FEEDBACK.md，你觉得呢？"

## 常见问题

### Q: 什么时候引入 freezed？

当前模板为了便于阅读，部分模型是手写的。真实项目推荐：
- Entity、DTO 使用 `freezed + json_serializable`
- 好处：不可变、copyWith、模式匹配、序列化

### Q: 什么时候需要 UseCase/Policy？

- **UseCase**：多步骤业务流程、跨 Repository 操作
- **Policy**：可复用的业务规则验证（如字段校验）

简单 CRUD 可以直接在 Controller 调用 Repository。

### Q: 如何替换 Mock SDK 为真实 SDK？

参考 `capabilities/` 下的实现：
1. 保留 Service 抽象接口
2. 新增真实实现类（如 `VendorOcrService`）
3. 修改 Provider 注入的实现
4. 业务代码依赖抽象，不依赖具体实现

---

> 📝 此文档会持续演进，记录 AI 打磨过程中的最佳实践。
