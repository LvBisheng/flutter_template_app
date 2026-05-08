// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flutter Enterprise Starter';

  @override
  String get commonRetry => '重试';

  @override
  String get commonNoData => '暂无数据';

  @override
  String get commonLoading => '加载中';

  @override
  String get commonErrorTitle => '处理失败';

  @override
  String get commonOk => '知道了';

  @override
  String get commonConfirmTitle => '请确认';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确认';

  @override
  String get navCustomers => '客户';

  @override
  String get navDemos => 'Demo';

  @override
  String get navSettings => '设置';

  @override
  String get demoHubTitle => '功能 Demo';

  @override
  String get demoCustomerTitle => '客户资料管理';

  @override
  String get demoCustomerSubtitle => '业务型页面、路由、网络 Mock、复杂表单和证件更新流程';

  @override
  String get demoBusinessLogTitle => '业务日志上传';

  @override
  String get demoBusinessLogSubtitle => '演示一条简单业务日志的静默上传';

  @override
  String get demoBusinessLogDescription =>
      '适合接口失败、SDK 失败、文件下载失败等轻量场景。调用方只关心记录和上传，上传失败不会打断用户流程。';

  @override
  String get demoBusinessLogUploadPdfFailure => '模拟上传 PDF 下载失败日志';

  @override
  String get demoBusinessLogUploadSuccess => '日志上传成功';

  @override
  String get demoBusinessLogUploadSkipped => '日志上传已跳过';

  @override
  String get demoBusinessLogUploadFailed => '日志上传失败但已静默处理';

  @override
  String get loginUsername => '用户名';

  @override
  String get loginPassword => '密码';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginEmptyCredentials => '请输入用户名和密码';

  @override
  String get customerListTitle => '客户资料管理';

  @override
  String get customerListEmpty => '暂无客户资料';

  @override
  String customerDetailTitle(Object customerId) {
    return '客户详情 $customerId';
  }

  @override
  String get customerEmail => '邮箱';

  @override
  String get customerMobile => '手机';

  @override
  String get customerVerificationStatus => '认证状态';

  @override
  String get customerIndustryProfession => '行业/职业';

  @override
  String get customerLastUpdated => '最近更新';

  @override
  String get customerEditProfile => '修改资料';

  @override
  String get customerUpdateIdentity => '更新证件';

  @override
  String get customerUpdateTitle => '修改资料';

  @override
  String get customerName => '姓名';

  @override
  String get customerIndustry => '行业';

  @override
  String get customerChooseIndustry => '请选择行业';

  @override
  String get customerProfession => '职业';

  @override
  String get customerChooseProfession => '请选择职业';

  @override
  String get customerChooseIndustryFirst => '请先选择行业';

  @override
  String customerBirthdayValue(Object value) {
    return '生日：$value';
  }

  @override
  String get customerAcceptedTerms => '我确认客户资料真实有效';

  @override
  String get customerContactMethod => '首选联系渠道';

  @override
  String get customerContactEmail => '邮箱';

  @override
  String get customerContactMobile => '手机';

  @override
  String get customerSubmitEdit => '提交修改';

  @override
  String get customerUpdateSuccessTitle => '客户资料已更新';

  @override
  String get customerUpdateSuccessMessage => '客户资料修改流程已通过 mock 接口完成。';

  @override
  String get validationRequiredName => '请输入姓名';

  @override
  String get validationRequiredEmail => '请输入邮箱';

  @override
  String get validationInvalidEmail => '邮箱格式不正确，例如 demo@example.com';

  @override
  String get validationRequiredMobile => '请输入手机号';

  @override
  String get validationInvalidMobile => '手机号需为 11 位数字';

  @override
  String get validationRequiredIndustry => '请选择行业';

  @override
  String get validationRequiredProfession => '请选择职业';

  @override
  String get validationAcceptedTermsRequired => '请勾选资料真实性声明';

  @override
  String get industryTech => '科技 / 互联网 / 软件与信息服务';

  @override
  String get industryFinance => '金融 / 保险 / 证券与财富管理';

  @override
  String get industryService => '专业服务 / 咨询 / 客户运营';

  @override
  String get professionEngineer => '高级软件工程师 / 解决方案架构师';

  @override
  String get professionDesigner => '产品设计师 / 用户体验专家';

  @override
  String get professionAnalyst => '风险分析师 / 投资研究分析师';

  @override
  String get professionAdvisor => '私人客户顾问 / 财务规划顾问';

  @override
  String get professionOperator => '客户运营经理 / 服务交付负责人';

  @override
  String get professionConsultant => '业务顾问 / 实施专家';

  @override
  String get identityUpdateTitle => '证件更新';

  @override
  String get identityFlowDescription => 'OCR -> 活体验证 -> Soft Token 签名 -> 提交接口';

  @override
  String get identityStartOcr => '开始 OCR';

  @override
  String get identityRescanOcr => '重新 OCR';

  @override
  String get identityName => '证件姓名';

  @override
  String get identityNumber => '证件号码';

  @override
  String get identityBirthday => '出生日期';

  @override
  String get identityExpiryDate => '证件有效期';

  @override
  String get identitySubmitNext => '下一步并提交';

  @override
  String get identityResultTitle => '证件信息已更新';

  @override
  String get identityResultMessage => 'OCR、活体验证和 Soft Token mock 流程已完成。';

  @override
  String get identityStepWaitingOcr => '等待 OCR';

  @override
  String get identityStepScanning => 'OCR 识别中';

  @override
  String get identityStepOcrCompleted => 'OCR 完成';

  @override
  String get identityStepSigning => '活体验证与签名中';

  @override
  String get identityStepCompleted => '证件更新完成';

  @override
  String get identityScanRequired => '请先完成 OCR';

  @override
  String get identityFaceVerifyFailed => '活体验证未通过';

  @override
  String get resultTitle => '处理结果';

  @override
  String get resultDefaultTitle => '提交成功';

  @override
  String get resultDefaultMessage => '业务处理已完成。';

  @override
  String get resultBackCustomers => '返回客户列表';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsAccount => '账号';

  @override
  String get settingsLoginStatus => '登录状态';

  @override
  String settingsLoggedInUser(Object userName) {
    return '已登录：$userName';
  }

  @override
  String get settingsNotLoggedIn => '未登录';

  @override
  String get settingsClearToken => '清除 Token';

  @override
  String get settingsLogout => '退出登录';

  @override
  String get settingsLogoutConfirm => '确认退出当前登录？';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageChinese => '简体中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppInfo => '应用信息';

  @override
  String get settingsCurrentEnv => '当前环境';

  @override
  String get settingsBaseUrl => 'Base URL';

  @override
  String get settingsDiagnosticsTool => '诊断工具';

  @override
  String get settingsFloatingButton => '右下角悬浮按钮';

  @override
  String get settingsProductionDisabled => '生产包已关闭';

  @override
  String get devToolTitle => '开发工具';

  @override
  String get devToolCurrentNetwork => '当前网络';

  @override
  String devToolEnvLine(Object env) {
    return '环境：$env';
  }

  @override
  String devToolMockMasterLine(Object status) {
    return 'Mock 总开关：$status';
  }

  @override
  String get devToolMockOn => '开启';

  @override
  String get devToolMockOff => '关闭';

  @override
  String get devToolMockPrdDisabled => 'prd 禁用';

  @override
  String devToolMockedApiCountLine(Object count) {
    return '已 Mock 接口：$count 个';
  }

  @override
  String get devToolMockMasterSwitch => '接口 Mock 总开关';

  @override
  String get devToolMockMasterEnabledHint => '开启后，只拦截下方启用的接口';

  @override
  String get devToolMockMasterPrdHint => 'prd 环境不允许接口 Mock';

  @override
  String get devToolMockRules => '接口 Mock 规则';

  @override
  String get devToolNoMockedApi => '当前没有接口被 mock';

  @override
  String get devToolRestoreDefaultRules => '恢复默认 Mock 规则';

  @override
  String get devToolViewLogs => '查看日志';

  @override
  String get devToolLogTitle => '诊断日志';

  @override
  String devToolLogCount(Object count) {
    return '当前 $count 条';
  }

  @override
  String get devToolClearLogs => '清空日志';

  @override
  String get devToolCurrentUser => '当前登录用户';

  @override
  String get devToolMockTools => 'Mock 工具';

  @override
  String get devToolMockToolsSubtitle => '预留入口：接口错误注入、假数据场景、功能开关';

  @override
  String get mockToolTitle => 'Mock 管理';

  @override
  String get runtimeErrorTitle => '前端错误';

  @override
  String get runtimeErrorDetailTitle => '错误详情';

  @override
  String get runtimeErrorCaptured => '捕获到前端错误';

  @override
  String get runtimeErrorEmpty => '暂无前端错误';

  @override
  String runtimeErrorCount(Object count) {
    return '当前 $count 条';
  }

  @override
  String get runtimeErrorClear => '清空错误';

  @override
  String get runtimeErrorCopy => '复制';

  @override
  String get runtimeErrorCopyAll => '复制完整信息';

  @override
  String get runtimeErrorCopied => '错误信息已复制';

  @override
  String get runtimeErrorViewDetail => '查看详情';

  @override
  String get runtimeErrorSource => '来源';

  @override
  String get runtimeErrorTime => '时间';

  @override
  String get runtimeErrorContext => '上下文';

  @override
  String get runtimeErrorMessage => '错误信息';

  @override
  String get runtimeErrorStack => '堆栈信息';

  @override
  String get runtimeErrorTriggerTest => '触发测试异常';

  @override
  String get runtimeErrorTriggerTestSubtitle => '用于验证前端错误捕获、弹框和复制能力';
}
