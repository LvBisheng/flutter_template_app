# Flutter Enterprise Starter App

企业业务型 Flutter 模板 App，业务场景为“客户资料管理 Demo App”。项目不是 Todo Demo，也不是空目录架构，而是用于展示中大型业务 App 常见的分层、路由、状态管理、网络 Mock、复杂表单和通用业务能力封装。

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
flutter pub run build_runner build --delete-conflicting-outputs
```

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

1. 在 `lib/app/l10n/app_zh.arb` 增加中文 key。
2. 在 `lib/app/l10n/app_en.arb` 增加同名英文 key。
3. 执行 Flutter 本地化生成：

```bash
flutter gen-l10n
```

4. 页面通过 `context.l10n.xxx` 读取文案。业务规则层不要直接依赖某一种语言，复杂表单可以像 `CustomerUpdatePolicy` 一样返回错误码，再由 presentation 层翻译成当前语言文案。

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

- 底部 `ShellRoute` 只承载一级 Tab，例如 `/home/demos` 和 `/home/settings`。
- 具体功能 demo 不放在 `ShellRoute` 下，而是从 Demo Hub 使用 `context.push(...)` 打开，例如 `/home/customers` 和 `/home/demos/business-log`。
- 这样 demo 页面会显示返回按钮，Android 返回键或侧滑返回会回到 Demo Hub，而不是直接退出 App。

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
