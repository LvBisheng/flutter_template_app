# 国际化文案规范

> 本文档定义了 ARB 文件的命名规范和分组约定，确保文案可维护、易查找。

## 文件位置

```
lib/app/l10n/
├── app_zh.arb        # 简体中文
├── app_zh_Hant.arb   # 繁体中文
└── app_en.arb        # 英文
```

## 命名规范

### 必须遵守

所有文案 key **必须**带模块前缀，格式：`<模块名><用途>`

```
✅ 正确
loginUsername      # login 模块 + Username
settingsLanguage   # settings 模块 + Language
validationRequired # validation 模块 + Required

❌ 错误
username           # 没有模块前缀，容易冲突
title              # 太泛，不知道是哪个页面的标题
submit             # 不知道是哪个模块的提交按钮
```

### 前缀分类

| 前缀 | 用途 | 示例 |
|------|------|------|
| `common*` | 通用文案（按钮、状态、提示） | `commonRetry`, `commonNoData` |
| `nav*` | 导航相关（Tab、标题） | `navCustomers`, `navSettings` |
| `login*` | 登录模块 | `loginUsername`, `loginSubmit` |
| `customer*` | 客户模块 | `customerName`, `customerEmail` |
| `settings*` | 设置模块 | `settingsLanguage`, `settingsLogout` |
| `validation*` | 表单校验 | `validationRequiredName` |
| `devTool*` | 开发工具 | `devToolTitle`, `devToolMockOn` |
| `runtimeError*` | 运行时错误 | `runtimeErrorTitle`, `runtimeErrorCopy` |

### 命名风格

- **驼峰命名**：`loginUsername`（不是 `login_username`）
- **动词开头**：`validationRequired*`（表示"需要..."）
- **语义清晰**：`settingsClearToken`（而不是 `settingsAction1`）

## 分组约定

ARB 文件按模块分组，使用注释分隔：

```json
{
  "@@locale": "zh",

  "@commonSection": { "_comment": "══════════════ 通用文案 ════════════════" },
  "commonRetry": "重试",
  "commonNoData": "暂无数据",

  "@loginSection": { "_comment": "══════════════ 登录模块 ════════════════" },
  "loginUsername": "用户名",
  "loginPassword": "密码"
}
```

**注意**：分组注释格式必须是 `@xxxSection: { "_comment": "..." }`，普通 JSON 注释会报错。

## 新增文案流程

### 步骤 1：确定 key

```
模块前缀 + 用途 = key

例如：设置页 + 字体大小 = settingsFontSize
```

### 步骤 2：添加到所有语言 ARB

```json
// app_zh.arb
"settingsFontSize": "字体大小",

// app_zh_Hant.arb
"settingsFontSize": "字型大小",

// app_en.arb
"settingsFontSize": "Font Size",
```

### 步骤 3：运行生成命令

```bash
flutter gen-l10n
```

### 步骤 4：在代码中使用

```dart
Text(l10n.settingsFontSize)
```

## 带参数的文案

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
Text(l10n.greeting('张三'))  // 输出：你好，张三！
```

## 常见错误

| 错误 | 正确 |
|------|------|
| `"submit": "提交"` | `"loginSubmit": "提交"` |
| `"error1": "不能为空"` | `"validationRequiredName": "请输入姓名"` |
| `"button_text": "确定"` | `"commonConfirm": "确定"` |

## 文案撰写规范

### 中文

- 使用简体中文（大陆）
- 结尾不加句号（按钮、标签）
- 提示语加句号（完整句子）

### 英文

- 首字母大写
- 按钮用动词：`Sign in`（不是 `Sign In`）
- 标签用名词：`Username`

### 繁体中文

- 使用台湾繁体
- 术语参考台湾习惯：`登入`（不是 `登录`）、`設定`（不是 `设置`）

## 工具支持

IDE 插件推荐：
- **Flutter Intl**（VS Code / Android Studio）：自动补全、快速跳转

---

> 此规范应在团队内宣导，PR Review 时检查新增文案是否符合命名规范。
