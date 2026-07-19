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
  String get exitConfirmTitle => '退出应用';

  @override
  String get exitConfirmMessage => '确定要退出应用吗？';

  @override
  String get navCustomers => '客户';

  @override
  String get navAnnouncements => '首页';

  @override
  String get navDemos => 'Demo';

  @override
  String get navMe => '我的';

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
  String get loginTitle => 'Flutter 企业模板';

  @override
  String get loginPassword => '密码';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginEmptyCredentials => '请输入用户名和密码';

  @override
  String get loginInvalidUsername => '用户名只能输入字母、数字或下划线';

  @override
  String get loginUsernameTooShort => '用户名至少需要 4 个字符';

  @override
  String get loginPasswordTooShort => '密码至少需要 6 个字符';

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
  String get settingsLogout => '退出登录';

  @override
  String get settingsLogoutConfirm => '确认退出当前登录？';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageDescription => '选择应用显示语言，更改后立即生效。';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageSystemDesc => '根据系统语言自动切换';

  @override
  String get settingsLanguageChinese => '简体中文';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppInfo => '应用信息';

  @override
  String get settingsFontSize => '字体大小';

  @override
  String get settingsFontSizeDesc => '调整应用内字体大小';

  @override
  String get settingsFontSizeSmall => '小';

  @override
  String get settingsFontSizeStandard => '标准';

  @override
  String get settingsFontSizeLarge => '大';

  @override
  String get settingsFontSizeExtraLarge => '特大';

  @override
  String get settingsFontSizeHuge => '巨大';

  @override
  String get settingsFontSizePreview => '预览效果';

  @override
  String get settingsTheme => '深色模式';

  @override
  String get settingsThemeDescription => '选择应用主题模式，切换后立即生效';

  @override
  String get settingsThemeLight => '普通模式';

  @override
  String get settingsThemeLightDesc => '使用浅色主题';

  @override
  String get settingsThemeDark => '深色模式';

  @override
  String get settingsThemeDarkDesc => '使用深色主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeSystemDesc => '自动切换深/浅色主题';

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
  String get meTitle => '我的';

  @override
  String get meNotLoggedIn => '未登录';

  @override
  String get meTapToLogin => '点击登录';

  @override
  String get meLoggedInUser => '已登录';

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

  @override
  String get announcementTitle => '公告列表';

  @override
  String get announcementEmpty => '暂无公告';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Flutter Enterprise Starter';

  @override
  String get commonRetry => '重試';

  @override
  String get commonNoData => '暫無資料';

  @override
  String get commonLoading => '載入中';

  @override
  String get commonErrorTitle => '處理失敗';

  @override
  String get commonOk => '知道了';

  @override
  String get commonConfirmTitle => '請確認';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '確認';

  @override
  String get exitConfirmTitle => '退出應用';

  @override
  String get exitConfirmMessage => '確定要退出應用嗎？';

  @override
  String get navCustomers => '客戶';

  @override
  String get navAnnouncements => '首頁';

  @override
  String get navDemos => 'Demo';

  @override
  String get navMe => '我的';

  @override
  String get navSettings => '設定';

  @override
  String get demoHubTitle => '功能 Demo';

  @override
  String get demoCustomerTitle => '客戶資料管理';

  @override
  String get demoCustomerSubtitle => '業務型頁面、路由、網路 Mock、覆雜表單和證件更新流程';

  @override
  String get demoBusinessLogTitle => '業務日誌上傳';

  @override
  String get demoBusinessLogSubtitle => '演示一條簡單業務日誌的靜默上傳';

  @override
  String get demoBusinessLogDescription =>
      '適合接口失敗、SDK 失敗、檔案下載失敗等輕量場景。調用方只關心記錄和上傳，上傳失敗不會打斷用戶流程。';

  @override
  String get demoBusinessLogUploadPdfFailure => '模擬上傳 PDF 下載失敗日誌';

  @override
  String get demoBusinessLogUploadSuccess => '日誌上傳成功';

  @override
  String get demoBusinessLogUploadSkipped => '日誌上傳已跳過';

  @override
  String get demoBusinessLogUploadFailed => '日誌上傳失敗但已靜默處理';

  @override
  String get loginUsername => '使用者名稱';

  @override
  String get loginTitle => 'Flutter 企業樣板';

  @override
  String get loginPassword => '密碼';

  @override
  String get loginSubmit => '登入';

  @override
  String get loginEmptyCredentials => '請輸入使用者名稱和密碼';

  @override
  String get loginInvalidUsername => '使用者名稱只能輸入字母、數字或底線';

  @override
  String get loginUsernameTooShort => '使用者名稱至少需要 4 個字元';

  @override
  String get loginPasswordTooShort => '密碼至少需要 6 個字元';

  @override
  String get customerListTitle => '客戶資料管理';

  @override
  String get customerListEmpty => '暫無客戶資料';

  @override
  String customerDetailTitle(Object customerId) {
    return '客戶詳情 $customerId';
  }

  @override
  String get customerEmail => '電子信箱';

  @override
  String get customerMobile => '手機';

  @override
  String get customerVerificationStatus => '認證狀態';

  @override
  String get customerIndustryProfession => '行業/職業';

  @override
  String get customerLastUpdated => '最近更新';

  @override
  String get customerEditProfile => '修改資料';

  @override
  String get customerUpdateIdentity => '更新證件';

  @override
  String get customerUpdateTitle => '修改資料';

  @override
  String get customerName => '姓名';

  @override
  String get customerIndustry => '行業';

  @override
  String get customerChooseIndustry => '請選擇行業';

  @override
  String get customerProfession => '職業';

  @override
  String get customerChooseProfession => '請選擇職業';

  @override
  String get customerChooseIndustryFirst => '請先選擇行業';

  @override
  String customerBirthdayValue(Object value) {
    return '生日：$value';
  }

  @override
  String get customerAcceptedTerms => '我確認客戶資料真實有效';

  @override
  String get customerContactMethod => '首選聯繫管道';

  @override
  String get customerContactEmail => '電子信箱';

  @override
  String get customerContactMobile => '手機';

  @override
  String get customerSubmitEdit => '提交修改';

  @override
  String get customerUpdateSuccessTitle => '客戶資料已更新';

  @override
  String get customerUpdateSuccessMessage => '客戶資料修改流程已通過 mock 接口完成。';

  @override
  String get validationRequiredName => '請輸入姓名';

  @override
  String get validationRequiredEmail => '請輸入電子信箱';

  @override
  String get validationInvalidEmail => '電子信箱格式不正確，例如 demo@example.com';

  @override
  String get validationRequiredMobile => '請輸入手機號';

  @override
  String get validationInvalidMobile => '手機號需為 11 位數字';

  @override
  String get validationRequiredIndustry => '請選擇行業';

  @override
  String get validationRequiredProfession => '請選擇職業';

  @override
  String get validationAcceptedTermsRequired => '請勾選資料真實性聲明';

  @override
  String get industryTech => '科技 / 網路 / 軟體與資訊服務';

  @override
  String get industryFinance => '金融 / 保險 / 證券與財富管理';

  @override
  String get industryService => '專業服務 / 諮詢 / 客戶營運';

  @override
  String get professionEngineer => '高級軟體工程師 / 解決方案架構師';

  @override
  String get professionDesigner => '產品設計師 / 用戶體驗專家';

  @override
  String get professionAnalyst => '風險分析師 / 投資研究分析師';

  @override
  String get professionAdvisor => '私人客戶顧問 / 財務規劃顧問';

  @override
  String get professionOperator => '客戶營運經理 / 服務交付負責人';

  @override
  String get professionConsultant => '業務顧問 / 實施專家';

  @override
  String get identityUpdateTitle => '證件更新';

  @override
  String get identityFlowDescription => 'OCR -> 活體驗證 -> Soft Token 簽名 -> 提交接口';

  @override
  String get identityStartOcr => '開始 OCR';

  @override
  String get identityRescanOcr => '重新 OCR';

  @override
  String get identityName => '證件姓名';

  @override
  String get identityNumber => '證件號碼';

  @override
  String get identityBirthday => '出生日期';

  @override
  String get identityExpiryDate => '證件有效期';

  @override
  String get identitySubmitNext => '下一步並提交';

  @override
  String get identityResultTitle => '證件資訊已更新';

  @override
  String get identityResultMessage => 'OCR、活體驗證和 Soft Token mock 流程已完成。';

  @override
  String get identityStepWaitingOcr => '等待 OCR';

  @override
  String get identityStepScanning => 'OCR 識別中';

  @override
  String get identityStepOcrCompleted => 'OCR 完成';

  @override
  String get identityStepSigning => '活體驗證與簽名中';

  @override
  String get identityStepCompleted => '證件更新完成';

  @override
  String get identityScanRequired => '請先完成 OCR';

  @override
  String get identityFaceVerifyFailed => '活體驗證未通過';

  @override
  String get resultTitle => '處理結果';

  @override
  String get resultDefaultTitle => '提交成功';

  @override
  String get resultDefaultMessage => '業務處理已完成。';

  @override
  String get resultBackCustomers => '返回客戶列表';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLogout => '退出登入';

  @override
  String get settingsLogoutConfirm => '確認退出當前登入？';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageDescription => '選擇應用程式顯示語言，變更後立即生效。';

  @override
  String get settingsLanguageSystem => '跟隨系統';

  @override
  String get settingsLanguageSystemDesc => '根據系統語言自動切換';

  @override
  String get settingsLanguageChinese => '簡體中文';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppInfo => '應用資訊';

  @override
  String get settingsFontSize => '字型大小';

  @override
  String get settingsFontSizeDesc => '調整應用內字型大小';

  @override
  String get settingsFontSizeSmall => '小';

  @override
  String get settingsFontSizeStandard => '標準';

  @override
  String get settingsFontSizeLarge => '大';

  @override
  String get settingsFontSizeExtraLarge => '特大';

  @override
  String get settingsFontSizeHuge => '巨大';

  @override
  String get settingsFontSizePreview => '預覽效果';

  @override
  String get settingsTheme => '深色模式';

  @override
  String get settingsThemeDescription => '選擇應用程式主題模式，切換後立即生效';

  @override
  String get settingsThemeLight => '普通模式';

  @override
  String get settingsThemeLightDesc => '使用淺色主題';

  @override
  String get settingsThemeDark => '深色模式';

  @override
  String get settingsThemeDarkDesc => '使用深色主題';

  @override
  String get settingsThemeSystem => '跟隨系統';

  @override
  String get settingsThemeSystemDesc => '自動切換深/淺色主題';

  @override
  String get settingsCurrentEnv => '當前環境';

  @override
  String get settingsBaseUrl => 'Base URL';

  @override
  String get settingsDiagnosticsTool => '診斷工具';

  @override
  String get settingsFloatingButton => '右下角懸浮按鈕';

  @override
  String get settingsProductionDisabled => '生產包已關閉';

  @override
  String get meTitle => '我的';

  @override
  String get meNotLoggedIn => '未登入';

  @override
  String get meTapToLogin => '點擊登入';

  @override
  String get meLoggedInUser => '已登入';

  @override
  String get devToolTitle => '開發工具';

  @override
  String get devToolCurrentNetwork => '當前網路';

  @override
  String devToolEnvLine(Object env) {
    return '環境：$env';
  }

  @override
  String devToolMockMasterLine(Object status) {
    return 'Mock 總開關：$status';
  }

  @override
  String get devToolMockOn => '開啟';

  @override
  String get devToolMockOff => '關閉';

  @override
  String get devToolMockPrdDisabled => 'prd 禁用';

  @override
  String devToolMockedApiCountLine(Object count) {
    return '已 Mock 接口：$count 個';
  }

  @override
  String get devToolMockMasterSwitch => '接口 Mock 總開關';

  @override
  String get devToolMockMasterEnabledHint => '開啟後，只攔截下方啟用的接口';

  @override
  String get devToolMockMasterPrdHint => 'prd 環境不允許接口 Mock';

  @override
  String get devToolMockRules => '接口 Mock 規則';

  @override
  String get devToolNoMockedApi => '當前沒有接口被 mock';

  @override
  String get devToolRestoreDefaultRules => '恢復預設 Mock 規則';

  @override
  String get devToolViewLogs => '查看日誌';

  @override
  String get devToolLogTitle => '診斷日誌';

  @override
  String devToolLogCount(Object count) {
    return '當前 $count 條';
  }

  @override
  String get devToolClearLogs => '清空日誌';

  @override
  String get devToolCurrentUser => '當前登入用戶';

  @override
  String get devToolMockTools => 'Mock 工具';

  @override
  String get devToolMockToolsSubtitle => '預留入口：接口錯誤注入、假資料場景、功能開關';

  @override
  String get mockToolTitle => 'Mock 管理';

  @override
  String get runtimeErrorTitle => '前端錯誤';

  @override
  String get runtimeErrorDetailTitle => '錯誤詳情';

  @override
  String get runtimeErrorCaptured => '捕獲到前端錯誤';

  @override
  String get runtimeErrorEmpty => '暫無前端錯誤';

  @override
  String runtimeErrorCount(Object count) {
    return '當前 $count 條';
  }

  @override
  String get runtimeErrorClear => '清空錯誤';

  @override
  String get runtimeErrorCopy => '複製';

  @override
  String get runtimeErrorCopyAll => '複製完整資訊';

  @override
  String get runtimeErrorCopied => '錯誤資訊已複製';

  @override
  String get runtimeErrorViewDetail => '查看詳情';

  @override
  String get runtimeErrorSource => '來源';

  @override
  String get runtimeErrorTime => '時間';

  @override
  String get runtimeErrorContext => '上下文';

  @override
  String get runtimeErrorMessage => '錯誤資訊';

  @override
  String get runtimeErrorStack => '堆疊資訊';

  @override
  String get runtimeErrorTriggerTest => '觸發測試異常';

  @override
  String get runtimeErrorTriggerTestSubtitle => '用於驗證前端錯誤捕獲、彈框和複製能力';

  @override
  String get announcementTitle => '公告列表';

  @override
  String get announcementEmpty => '暫無公告';
}
