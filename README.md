# Flutter Enterprise Starter App

企业业务型 Flutter 模板 App，业务场景为”客户资料管理 Demo App”。项目不是 Todo Demo，也不是空目录架构，而是用于展示中大型业务 App 常见的分层、路由、状态管理、网络 Mock、复杂表单和通用业务能力封装。

## 文档导航

- **[README.md](README.md)** - 你正在阅读的项目主文档（技术栈、运行方式、功能列表）
- **[CLAUDE.md](CLAUDE.md)** - AI 协作指南（给 Claude Code 等 AI 工具的快速上手文档，包含角色定位、行为准则、代码规范等）
- **[docs/AI_WORKFLOW.md](docs/AI_WORKFLOW.md)** - AI 打磨工作流指南（如何高效地通过 AI 改进项目）
- **[docs/AI_FEEDBACK.md](docs/AI_FEEDBACK.md)** - AI 反馈记录（沉淀 AI 给出的改进建议、问题模式、用户协作偏好）
- **[docs/CHANGELOG.md](docs/CHANGELOG.md)** - AI 协作文档变更日志（记录文档体系的重要变更）

## 技术栈

- 状态管理：`flutter_riverpod`、`riverpod_annotation`
- 路由：`go_router`
- 网络：`dio`
- 模型与代码生成预留：`freezed`、`json_serializable`、`build_runner`
- 本地存储：`shared_preferences`、`flutter_secure_storage`
- 国际化：Flutter 官方 `gen-l10n`、`flutter_localizations`
- 工具：`intl`、`collection`
- 测试：`flutter_test`、`mocktail`
- 诊断日志：`talker_flutter`、`talker_dio_logger`

当前模板为了便于直接阅读，DTO/Entity 使用手写 Dart class。真实项目推荐逐步替换为 `freezed + json_serializable`：

```bash
dart run build_runner build --delete-conflicting-outputs
```

> 当前 Flutter 3.38 / Dart 3.10 环境下，`build_runner` 固定为 `2.8.0`。升级到 `2.10+` 可能触发 `dart compile does not support build hooks`，需要等对应工具链完全兼容后再放开。

## 目录结构

```text
lib/
  app/              # App、路由、主题、环境配置
  app/l10n/         # ARB 文案、语言状态、生成的 AppLocalizations
  core/             # 网络、存储、日志、权限等基础设施
  shared/           # 无业务属性的 UI、工具、扩展
  capabilities/     # OCR、活体、Soft Token、登录态等跨业务能力
  features/         # feature-first 业务模块
```

复杂业务模块按轻量 Clean Architecture 分层：

- `presentation`：页面、Controller、页面状态
- `domain`：Entity、Repository 抽象、UseCase、Policy
- `data`：API、DTO、RepositoryImpl、DTO 到 Entity 转换

## 架构设计

### 整体架构：Clean Architecture（简化版）

本项目采用 **Clean Architecture（整洁架构）的简化版**，结合 **MVVM + 单向数据流** 实现分层和解耦。

```
┌─────────────────────────────────────────────────────────────┐
│  Presentation Layer（展示层）                                │
│  ┌─────────────┐      ┌─────────────┐                       │
│  │   Page      │ ←─── │  Controller │                       │
│  │  (View)     │      │ (ViewModel) │                       │
│  └─────────────┘      └──────┬──────┘                       │
│                              │                               │
│                        State（单向数据流）                    │
└──────────────────────────────┼──────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────┐
│  Domain Layer（领域层）                                       │
│  ┌─────────────┐      ┌─────────────┐      ┌───────────┐    │
│  │   UseCase   │ ←─── │  Repository │      │  Entity   │    │
│  │             │      │  (抽象接口)  │      │           │    │
│  └──────┬──────┘      └─────────────┘      └───────────┘    │
│         │                                                    │
│   业务逻辑（纯 Dart，不依赖 Flutter）                         │
└─────────┼───────────────────────────────────────────────────┘
          ↓
┌─────────────────────────────────────────────────────────────┐
│  Data Layer（数据层）                                         │
│  ┌─────────────────┐      ┌─────────────┐                  │
│  │ RepositoryImpl  │ ←─── │    API      │                  │
│  │                 │      │  (网络请求)  │                  │
│  └─────────────────┘      └─────────────┘                  │
│                                                              │
│   数据获取、缓存、DTO → Entity 转换                          │
└─────────────────────────────────────────────────────────────┘
```

### 与 MVC/MVP/MVVM 的关系

| 名称 | 类型 | 说明 |
|------|------|------|
| **MVC** | UI 架构模式 | Model-View-Controller |
| **MVP** | UI 架构模式 | Model-View-Presenter |
| **MVVM** | UI 架构模式 | Model-View-ViewModel |
| **Clean Architecture** | 系统架构 | 分层架构，关注职责分离和依赖规则 |

**区别：**
- MVC/MVP/MVVM 关注的是 **UI 层** 如何组织（View 和逻辑的关系）
- Clean Architecture 关注的是 **整个系统** 如何分层（presentation、domain、data）

本项目是 **Clean Architecture + MVVM + 单向数据流** 的组合：
- **系统架构**：Clean Architecture（简化版三层）
- **UI 架构**：MVVM + Unidirectional Data Flow（通过 Riverpod 实现）
- **依赖注入**：Provider 模式（Riverpod）

这不是 MVP，因为 MVP 的 Presenter 持有 View 引用，双向通信；而本项目的 Controller 不持有 Page 引用，通过 State 流驱动 UI 重建。

### 数据流

```
用户输入 → Controller 状态更新 → Page 重建 → UI 更新
```

具体流程：
1. 用户在输入框输入 "abc"
2. onChanged 回调触发 → Controller.usernameChanged("abc", l10n)
3. Controller 状态更新 → state = state.copyWith(username: "abc")
4. Riverpod 通知监听者 → Page 重建
5. AppTextField 的 initialValue 变为 "abc"

### 依赖倒置原则（DIP）

依赖倒置原则（Dependency Inversion Principle，DIP）是 SOLID 原则中的 **D**。

**核心思想：高层模块不应依赖低层模块，两者都应依赖抽象；抽象不应依赖细节，细节应依赖抽象。**

#### 传统依赖 vs 依赖倒置

```
❌ 传统依赖（高层依赖低层）

┌─────────────┐
│  Controller │ ──────→ ┌─────────────┐ ──────→ ┌─────────────┐
│   (高层)     │        │  UseCase    │        │  Repository │
└─────────────┘        └─────────────┘        └─────────────┘
                             ↓                       ↓
                        ┌─────────────┐        ┌─────────────┐
                        │ RepositoryImpl│      │   API/DB   │
                        └─────────────┘        └─────────────┘

问题：
- Controller 直接依赖具体的 UseCase 实现
- UseCase 直接依赖具体的 RepositoryImpl
- 替换实现需要改Controller 代码


✅ 依赖倒置（高层依赖抽象）

┌─────────────┐
│  Controller │ ──────→ ┌─────────────┐
│   (高层)     │        │ UseCase      │
└─────────────┘        │ (抽象接口)    │
                       └──────┬──────┘
                              │
                       ┌──────↓──────┐
                       │ Repository  │
                       │ (抽象接口)    │
                       └──────┬──────┘
                              │
         ┌────────────────────┼────────────────────┐
         ↓                    ↓                    ↓
┌─────────────┐        ┌─────────────┐        ┌─────────────┐
│ MockRepo    │        │ RealRepo    │        │ TestRepo    │
│ (测试实现)   │        │ (真实实现)   │        │ (单元测试)  │
└─────────────┘        └─────────────┘        └─────────────┘

好处：
- Controller 只依赖 UseCase 抽象
- UseCase 只依赖 Repository 抽象
- 替换实现不需要改高层代码
```

#### 本项目中的体现

| 层 | 抽象 | 具体实现 |
|---|------|---------|
| Domain | `LoginRepository`（接口） | `LoginRepositoryImpl`（data 层） |
| Domain | `LoginUseCase` | - |
| Presentation | `loginUseCaseProvider`（Provider） | `LoginUseCase` 实例 |
| Capabilities | `OcrService`（接口） | `MockOcrService` / `VendorOcrService` |

```dart
// ❌ 错误：直接依赖具体实现
class LoginController {
  void login() {
    final useCase = LoginUseCase(// 直接 new
      LoginRepositoryImpl(LoginApi(...)),
      SessionManager(),
    );
    useCase(...);
  }
}

// ✅ 正确：依赖抽象（通过 Provider 注入）
class LoginController extends Notifier<LoginState> {
  Future<void> login() async {
    // 从 Provider 获取，不关心具体实现
    final useCase = ref.read(loginUseCaseProvider);
    await useCase(...);
  }
}

// Provider 负责创建具体实例
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    LoginRepositoryImpl(LoginApi(ref.read(apiClientProvider))),
    ref.read(sessionManagerProvider.notifier),
  );
});
```

#### 依赖倒置的好处

| 场景 | 不用 DIP | 用 DIP |
|------|---------|--------|
| 切换 API 实现 | 改Controller 代码 | 只改 Provider |
| 单元测试 | 难以 Mock | 轻松替换 TestRepo |
| 接真实 SDK | 改所有调用方 | 只改 Provider 注入 |
| 代码可读性 | 能看到所有依赖细节 | 只看抽象，细节隐藏 |

#### 一句话总结

> **依赖倒置就是：我只要"能登录"，不管你用什么方式登录（密码、指纹、人脸）；我只要"能获取数据"，不管你从哪获取（网络、缓存、Mock）。**

## 运行

安装依赖：

```bash
flutter pub get
```

普通运行默认使用 `sit` 环境，并开启默认接口 Mock 规则，因此可以直接跑通完整流程：

```bash
flutter run
```

也可以显式指定打包默认环境：

```bash
flutter run --dart-define=APP_ENV=sit
```

登录页默认填入了演示账号：

```text
username: demo
password: demo123
```

使用指定默认环境：

```bash
flutter run --dart-define=APP_ENV=uat
```

App 启动后可以在全局悬浮“开发工具”里切换 `sit/sit2/sit3/uat/uat1/uat2/prd`。环境只决定 baseUrl；接口 Mock 是独立能力，可以打开总开关并逐条选择哪些接口使用本地 mock。切换结果会写入本地存储，下次启动继续使用。

设置页支持运行时切换语言：

- 跟随系统
- 简体中文
- English

语言选择会写入本地存储，下次启动继续生效。新增页面文案时，不建议在页面里直接写死字符串；推荐按下面流程扩展：

### 新增国际化文案

**步骤 1：添加文案到 ARB 文件**

中文 `lib/app/l10n/app_zh.arb`：
```json
{
  "loginTitle": "Flutter 企业模板"
}
```

英文 `lib/app/l10n/app_en.arb`：
```json
{
  "loginTitle": "Flutter Enterprise Starter"
}
```

**步骤 2：运行生成命令**

```bash
flutter gen-l10n
```

这会自动生成 Dart 代码到 `lib/app/l10n/generated/` 目录。

**步骤 3：在代码中使用**

```dart
// 获取 l10n 实例
final l10n = context.l10n;

// 使用文案
Text(l10n.loginTitle)
```

### 带参数的文案

如果文案需要动态参数：

```json
// app_zh.arb
"greeting": "你好，{name}！",
"@greeting": {
  "placeholders": {
    "name": {}
  }
}
```

```dart
// 使用
Text(l10n.greeting('张三'))  // 输出：你好，张三！
```

### 国际化文件说明

| 文件/目录 | 说明 | 是否可手动编辑 |
|----------|------|--------------|
| `l10n.yaml` | 国际化配置文件 | ✅ 可编辑 |
| `app_zh.arb` | 中文文案（JSON 格式） | ✅ 可编辑 |
| `app_en.arb` | 英文文案（JSON 格式） | ✅ 可编辑 |
| `generated/` | 自动生成的 Dart 代码 | ❌ 不要编辑 |

业务规则层不要直接依赖某一种语言，复杂表单可以像 `CustomerUpdatePolicy` 一样返回错误码，再由 presentation 层翻译成当前语言文案。

测试/开发包中会出现全局悬浮“开发工具”按钮。测试人员可以在这里查看：

- Dio 请求、响应、错误和耗时
- 前端业务日志，例如登录、资料提交、OCR 流程
- 前端运行时错误，包括错误信息、上下文和堆栈，可复制给开发排查
- Flutter 异常和错误历史
- 当前登录用户和脱敏 token
- 运行时切换 `sit/sit2/sit3/uat/uat1/uat2/prd`
- 进入独立 Mock 管理页，查看当前哪些接口被 Mock，并逐接口开关 Mock 规则

日志只保存在 App 内存历史中，Talker 页面也支持清空和分享日志，便于测试反馈接口报错现场。

Mock 管理：

- 底部开发工具只展示当前网络和 Mock 摘要，避免规则变多后面板过长。
- 点击“接口 Mock 规则”进入独立 Mock 管理页。
- Mock 管理页支持总开关、恢复默认规则、逐接口开关。
- 网络失败由 `TalkerDioLogger` 统一记录 http-error，业务日志层不重复写 error，避免 Talker 错误列表被同一请求刷屏。

生产打包应关闭环境切换总开关，此时 App 会强制使用 `prd`，并强制关闭所有接口 Mock：

```bash
flutter build apk --release --dart-define=ENV_SWITCH_ENABLED=false --dart-define=APP_ENV=prd
flutter build ipa --release --dart-define=ENV_SWITCH_ENABLED=false --dart-define=APP_ENV=prd
```

`ApiClient` 内有 release 安全检查：release 包中如果最终有效配置仍然打开了接口 Mock，会直接抛出错误，避免 mock 数据或假流程进入生产。

控制台长日志处理：

- Talker 诊断页保留完整日志历史。
- Android logcat/IDE 控制台可能截断超长单行文本，因此控制台输出会通过 `LongLogPrinter` 按块打印。
- 每块默认 800 字符，格式如 `[long-log 1/3] ...`。
- release 或 `prd` 环境下会关闭控制台输出，避免生产环境打印敏感数据。

前端错误捕获：

- `bootstrap` 中安装全局错误处理器，捕获 Flutter framework error、未捕获异步 error 和路由错误。
- 测试/开发包里捕获到前端错误后会自动弹框，测试人员可以直接复制摘要，也可以进入详情页复制完整堆栈。
- 全局悬浮“开发工具”中提供“前端错误”列表，保留最近 30 条运行时错误。
- 开发工具里有“触发测试异常”入口，用于验证弹框、列表和复制链路。
- release 或关闭环境切换的生产包不展示开发工具，也不会主动向真实用户弹出堆栈详情。

业务追踪日志：

- `BusinessTraceLogger` 位于 `lib/core/logging/business_trace_logger.dart`，用于 OCR、蓝牙、启动弹框等业务流程的埋点追踪。
- `startFlow` 创建一次业务流程追踪，`info/warning/error/debug` 记录关键动作和上下文，内部使用环形缓存，避免日志无限增长。
- `upload` / `uploadSilently` 会把当前流程快照上传到 `/diagnostics/business-log/upload`；上传失败只返回失败结果或写 warning，不会抛到页面，不影响用户流程。
- `uploadOneShot` / `uploadOneShotSilently` 适合单点日志，例如“下载 PDF 失败啦，错误信息...”，不需要先手动创建完整流程。
- 埋点属性会做基础脱敏和长度裁剪，例如 token、password、secret、authorization、id_number 会被替换为 `***`。
- `identity_update` 流程已接入示例：OCR 开始/成功/失败、提交开始/成功/失败；失败时会自动汇总当前流程日志并静默上传。
- `Demo -> 业务日志上传` 提供了一条 PDF 下载失败日志的一键上传演示。
- 模板内提供了 mock 上传接口“业务日志上传”，用于本地演示和测试。

## 已实现页面

- `/login`：登录、loading、失败 toast、保存 token
- `/home/demos`：功能 Demo Hub，承载业务 demo 和基础设施 demo 的入口
- `/home/customers`：客户列表、loading/error/empty/success、下拉刷新
- `/home/demos/business-log`：业务日志上传 demo，演示单点日志静默上传
- `/home/settings`：登录状态、清除 token、退出登录、语言切换、应用信息
- `/customer/:id`：客户详情、认证状态、更新时间、跳转修改资料/证件更新
- `/customer/:id/update`：复杂表单、行业职业联动、checkbox/radio/date picker、Policy 校验、UseCase 提交
- `/customer/:id/identity-update`：Mock OCR、Mock 活体、Mock Soft Token 签名、证件更新接口
- `/result`：统一结果页

## 新增 Feature

建议按业务先建 feature 目录：

```text
features/order_apply/
  data/
  domain/
  presentation/
```

简单页面可以只保留 `presentation`；涉及接口、复杂状态、业务规则或多步骤流程时，再补齐 `data/domain/presentation`。

如果是用于展示模板能力或业务能力的 demo，推荐挂到 `features/demo_hub` 的入口列表中。底部 Tab 保持“Demo / 设置”的稳定结构，新增能力通过 Demo Hub 扩展，避免底部导航越来越重。

路由约定：

- 底部 `StatefulShellRoute.indexedStack` 只承载一级 Tab，例如 `/home/announcements`、`/home/demos` 和 `/home/me`。
- 具体功能 demo 不放在 `StatefulShellRoute` 下，而是从 Demo Hub 使用 `context.push(...)` 打开，例如 `/home/customers` 和 `/home/demos/business-log`。
- 这样 demo 页面会显示返回按钮，Android 返回键或侧滑返回会回到 Demo Hub，而不是直接退出 App。
- `path` 是 URL/深链地址，`name` 是代码里的稳定路由身份；不要用 path 去匹配 `Route.settings.name`。
- 路由名统一使用 `feature.page` / `feature.action` 风格，并定义在对应 `XxxRoutes` 类中，例如 `CustomerRoutes.customersName = 'customer.list'`。
- 控制台看到 route name 后，优先全局搜索该字符串或对应 `xxxName` 常量，即可定位到 `features/<feature>/routing/*_routes.dart`，再从 `builder` 跳到页面文件。

当前主要路由名：

| Route name | Path | 路由定义 | 页面 |
| --- | --- | --- | --- |
| `auth.login` | `/login` | `AuthRoutes.loginName` | `features/auth/login/presentation/login_page.dart` |
| `announcement.list` | `/home/announcements` | `AnnouncementRoutes.announcementsName` | `features/announcement/presentation/announcement_page.dart` |
| `announcement.detail` | `/announcement/detail` | `AnnouncementRoutes.detailName` | `features/announcement/presentation/announcement_detail_page.dart` |
| `demo.hub` | `/home/demos` | `DemoRoutes.demosName` | `features/demo/presentation/demo_hub_page.dart` |
| `demo.businessLog` | `/home/demos/business-log` | `DemoRoutes.businessLogDemoName` | `features/demo/presentation/business_log_demo_page.dart` |
| `settings.me` | `/home/me` | `SettingsRoutes.meName` | `features/settings/presentation/me_page.dart` |
| `settings.index` | `/setting` | `SettingsRoutes.settingsPageName` | `features/settings/presentation/settings_page.dart` |
| `settings.language` | `/setting/language` | `SettingsRoutes.settingLanguageName` | `features/settings/presentation/setting_language_page.dart` |
| `settings.font` | `/setting/font` | `SettingsRoutes.settingFontSizeName` | `features/settings/presentation/setting_font_page.dart` |
| `customer.list` | `/home/customers` | `CustomerRoutes.customersName` | `features/customer/list/presentation/customer_list_page.dart` |
| `customer.detail` | `/customer/:id` | `CustomerRoutes.customerDetailName` | `features/customer/detail/presentation/customer_detail_page.dart` |
| `customer.update` | `/customer/:id/update` | `CustomerRoutes.customerUpdateName` | `features/customer/update/presentation/customer_update_page.dart` |
| `customer.identityUpdate` | `/customer/:id/identity-update` | `CustomerRoutes.identityUpdateName` | `features/customer/identity/presentation/identity_update_page.dart` |
| `result.default` | `/result` | `ResultRoutes.resultName` | `features/result/presentation/result_page.dart` |

## 新增接口

1. 在 feature 的 `data` 中新增 `XxxApi`，通过 `ApiClient` 调用接口。
2. 在 `data/dto` 或同层 DTO 文件中解析接口 JSON。
3. 在 `domain` 中定义 Entity 和 Repository 抽象。
4. 在 `data` 中实现 RepositoryImpl，并完成 DTO -> Entity 转换。
5. 页面或 Controller 调用 Repository/UseCase，不直接调用 Dio，不直接解析 JSON。
6. Mock 接口加到 `lib/core/network/mock/mock_rule.dart`，响应 JSON 放在对应 mock JSON 文件中。开发工具会自动展示新规则开关。

## 替换真实 SDK

`capabilities/ocr`、`capabilities/face_verify`、`capabilities/soft_token` 当前都是 Mock 实现。接真实 SDK 时：

- 保留 `OcrService`、`FaceVerifyService`、`SoftTokenService` 抽象。
- 新增真实实现类，例如 `VendorOcrService`。
- 修改 provider 注入的实现。
- 页面和 UseCase 继续依赖抽象接口，避免 SDK 细节扩散到业务页面。

## 注意事项

- Mock JSON 使用 Dart raw string，不放 `assets/mock`。
- 不使用 mock server。
- Mock 数据必须脱敏，禁止真实姓名、手机号、证件号、token、密钥、生产域名。
- `shared/utils` 只放纯工具，业务规则放对应 feature 的 Policy。
- 页面不直接 new Dio，不直接解析后端 JSON，不直接调用 OCR/活体/Soft Token SDK。
- 用户可见文案走 `app/l10n`；临时 demo 文案也建议先放 ARB，避免后续从模板演进成业务 App 时再集中迁移。
