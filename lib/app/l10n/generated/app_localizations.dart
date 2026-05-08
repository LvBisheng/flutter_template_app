import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'Flutter Enterprise Starter'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonRetry;

  /// No description provided for @commonNoData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get commonNoData;

  /// No description provided for @commonLoading.
  ///
  /// In zh, this message translates to:
  /// **'加载中'**
  String get commonLoading;

  /// No description provided for @commonErrorTitle.
  ///
  /// In zh, this message translates to:
  /// **'处理失败'**
  String get commonErrorTitle;

  /// No description provided for @commonOk.
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get commonOk;

  /// No description provided for @commonConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'请确认'**
  String get commonConfirmTitle;

  /// No description provided for @commonCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get commonConfirm;

  /// No description provided for @navCustomers.
  ///
  /// In zh, this message translates to:
  /// **'客户'**
  String get navCustomers;

  /// No description provided for @navDemos.
  ///
  /// In zh, this message translates to:
  /// **'Demo'**
  String get navDemos;

  /// No description provided for @navSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get navSettings;

  /// No description provided for @demoHubTitle.
  ///
  /// In zh, this message translates to:
  /// **'功能 Demo'**
  String get demoHubTitle;

  /// No description provided for @demoCustomerTitle.
  ///
  /// In zh, this message translates to:
  /// **'客户资料管理'**
  String get demoCustomerTitle;

  /// No description provided for @demoCustomerSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'业务型页面、路由、网络 Mock、复杂表单和证件更新流程'**
  String get demoCustomerSubtitle;

  /// No description provided for @demoBusinessLogTitle.
  ///
  /// In zh, this message translates to:
  /// **'业务日志上传'**
  String get demoBusinessLogTitle;

  /// No description provided for @demoBusinessLogSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'演示一条简单业务日志的静默上传'**
  String get demoBusinessLogSubtitle;

  /// No description provided for @demoBusinessLogDescription.
  ///
  /// In zh, this message translates to:
  /// **'适合接口失败、SDK 失败、文件下载失败等轻量场景。调用方只关心记录和上传，上传失败不会打断用户流程。'**
  String get demoBusinessLogDescription;

  /// No description provided for @demoBusinessLogUploadPdfFailure.
  ///
  /// In zh, this message translates to:
  /// **'模拟上传 PDF 下载失败日志'**
  String get demoBusinessLogUploadPdfFailure;

  /// No description provided for @demoBusinessLogUploadSuccess.
  ///
  /// In zh, this message translates to:
  /// **'日志上传成功'**
  String get demoBusinessLogUploadSuccess;

  /// No description provided for @demoBusinessLogUploadSkipped.
  ///
  /// In zh, this message translates to:
  /// **'日志上传已跳过'**
  String get demoBusinessLogUploadSkipped;

  /// No description provided for @demoBusinessLogUploadFailed.
  ///
  /// In zh, this message translates to:
  /// **'日志上传失败但已静默处理'**
  String get demoBusinessLogUploadFailed;

  /// No description provided for @loginUsername.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get loginUsername;

  /// No description provided for @loginPassword.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get loginPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get loginSubmit;

  /// No description provided for @loginEmptyCredentials.
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名和密码'**
  String get loginEmptyCredentials;

  /// No description provided for @customerListTitle.
  ///
  /// In zh, this message translates to:
  /// **'客户资料管理'**
  String get customerListTitle;

  /// No description provided for @customerListEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无客户资料'**
  String get customerListEmpty;

  /// No description provided for @customerDetailTitle.
  ///
  /// In zh, this message translates to:
  /// **'客户详情 {customerId}'**
  String customerDetailTitle(Object customerId);

  /// No description provided for @customerEmail.
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get customerEmail;

  /// No description provided for @customerMobile.
  ///
  /// In zh, this message translates to:
  /// **'手机'**
  String get customerMobile;

  /// No description provided for @customerVerificationStatus.
  ///
  /// In zh, this message translates to:
  /// **'认证状态'**
  String get customerVerificationStatus;

  /// No description provided for @customerIndustryProfession.
  ///
  /// In zh, this message translates to:
  /// **'行业/职业'**
  String get customerIndustryProfession;

  /// No description provided for @customerLastUpdated.
  ///
  /// In zh, this message translates to:
  /// **'最近更新'**
  String get customerLastUpdated;

  /// No description provided for @customerEditProfile.
  ///
  /// In zh, this message translates to:
  /// **'修改资料'**
  String get customerEditProfile;

  /// No description provided for @customerUpdateIdentity.
  ///
  /// In zh, this message translates to:
  /// **'更新证件'**
  String get customerUpdateIdentity;

  /// No description provided for @customerUpdateTitle.
  ///
  /// In zh, this message translates to:
  /// **'修改资料'**
  String get customerUpdateTitle;

  /// No description provided for @customerName.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get customerName;

  /// No description provided for @customerIndustry.
  ///
  /// In zh, this message translates to:
  /// **'行业'**
  String get customerIndustry;

  /// No description provided for @customerChooseIndustry.
  ///
  /// In zh, this message translates to:
  /// **'请选择行业'**
  String get customerChooseIndustry;

  /// No description provided for @customerProfession.
  ///
  /// In zh, this message translates to:
  /// **'职业'**
  String get customerProfession;

  /// No description provided for @customerChooseProfession.
  ///
  /// In zh, this message translates to:
  /// **'请选择职业'**
  String get customerChooseProfession;

  /// No description provided for @customerChooseIndustryFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先选择行业'**
  String get customerChooseIndustryFirst;

  /// No description provided for @customerBirthdayValue.
  ///
  /// In zh, this message translates to:
  /// **'生日：{value}'**
  String customerBirthdayValue(Object value);

  /// No description provided for @customerAcceptedTerms.
  ///
  /// In zh, this message translates to:
  /// **'我确认客户资料真实有效'**
  String get customerAcceptedTerms;

  /// No description provided for @customerContactMethod.
  ///
  /// In zh, this message translates to:
  /// **'首选联系渠道'**
  String get customerContactMethod;

  /// No description provided for @customerContactEmail.
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get customerContactEmail;

  /// No description provided for @customerContactMobile.
  ///
  /// In zh, this message translates to:
  /// **'手机'**
  String get customerContactMobile;

  /// No description provided for @customerSubmitEdit.
  ///
  /// In zh, this message translates to:
  /// **'提交修改'**
  String get customerSubmitEdit;

  /// No description provided for @customerUpdateSuccessTitle.
  ///
  /// In zh, this message translates to:
  /// **'客户资料已更新'**
  String get customerUpdateSuccessTitle;

  /// No description provided for @customerUpdateSuccessMessage.
  ///
  /// In zh, this message translates to:
  /// **'客户资料修改流程已通过 mock 接口完成。'**
  String get customerUpdateSuccessMessage;

  /// No description provided for @validationRequiredName.
  ///
  /// In zh, this message translates to:
  /// **'请输入姓名'**
  String get validationRequiredName;

  /// No description provided for @validationRequiredEmail.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮箱'**
  String get validationRequiredEmail;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In zh, this message translates to:
  /// **'邮箱格式不正确，例如 demo@example.com'**
  String get validationInvalidEmail;

  /// No description provided for @validationRequiredMobile.
  ///
  /// In zh, this message translates to:
  /// **'请输入手机号'**
  String get validationRequiredMobile;

  /// No description provided for @validationInvalidMobile.
  ///
  /// In zh, this message translates to:
  /// **'手机号需为 11 位数字'**
  String get validationInvalidMobile;

  /// No description provided for @validationRequiredIndustry.
  ///
  /// In zh, this message translates to:
  /// **'请选择行业'**
  String get validationRequiredIndustry;

  /// No description provided for @validationRequiredProfession.
  ///
  /// In zh, this message translates to:
  /// **'请选择职业'**
  String get validationRequiredProfession;

  /// No description provided for @validationAcceptedTermsRequired.
  ///
  /// In zh, this message translates to:
  /// **'请勾选资料真实性声明'**
  String get validationAcceptedTermsRequired;

  /// No description provided for @industryTech.
  ///
  /// In zh, this message translates to:
  /// **'科技 / 互联网 / 软件与信息服务'**
  String get industryTech;

  /// No description provided for @industryFinance.
  ///
  /// In zh, this message translates to:
  /// **'金融 / 保险 / 证券与财富管理'**
  String get industryFinance;

  /// No description provided for @industryService.
  ///
  /// In zh, this message translates to:
  /// **'专业服务 / 咨询 / 客户运营'**
  String get industryService;

  /// No description provided for @professionEngineer.
  ///
  /// In zh, this message translates to:
  /// **'高级软件工程师 / 解决方案架构师'**
  String get professionEngineer;

  /// No description provided for @professionDesigner.
  ///
  /// In zh, this message translates to:
  /// **'产品设计师 / 用户体验专家'**
  String get professionDesigner;

  /// No description provided for @professionAnalyst.
  ///
  /// In zh, this message translates to:
  /// **'风险分析师 / 投资研究分析师'**
  String get professionAnalyst;

  /// No description provided for @professionAdvisor.
  ///
  /// In zh, this message translates to:
  /// **'私人客户顾问 / 财务规划顾问'**
  String get professionAdvisor;

  /// No description provided for @professionOperator.
  ///
  /// In zh, this message translates to:
  /// **'客户运营经理 / 服务交付负责人'**
  String get professionOperator;

  /// No description provided for @professionConsultant.
  ///
  /// In zh, this message translates to:
  /// **'业务顾问 / 实施专家'**
  String get professionConsultant;

  /// No description provided for @identityUpdateTitle.
  ///
  /// In zh, this message translates to:
  /// **'证件更新'**
  String get identityUpdateTitle;

  /// No description provided for @identityFlowDescription.
  ///
  /// In zh, this message translates to:
  /// **'OCR -> 活体验证 -> Soft Token 签名 -> 提交接口'**
  String get identityFlowDescription;

  /// No description provided for @identityStartOcr.
  ///
  /// In zh, this message translates to:
  /// **'开始 OCR'**
  String get identityStartOcr;

  /// No description provided for @identityRescanOcr.
  ///
  /// In zh, this message translates to:
  /// **'重新 OCR'**
  String get identityRescanOcr;

  /// No description provided for @identityName.
  ///
  /// In zh, this message translates to:
  /// **'证件姓名'**
  String get identityName;

  /// No description provided for @identityNumber.
  ///
  /// In zh, this message translates to:
  /// **'证件号码'**
  String get identityNumber;

  /// No description provided for @identityBirthday.
  ///
  /// In zh, this message translates to:
  /// **'出生日期'**
  String get identityBirthday;

  /// No description provided for @identityExpiryDate.
  ///
  /// In zh, this message translates to:
  /// **'证件有效期'**
  String get identityExpiryDate;

  /// No description provided for @identitySubmitNext.
  ///
  /// In zh, this message translates to:
  /// **'下一步并提交'**
  String get identitySubmitNext;

  /// No description provided for @identityResultTitle.
  ///
  /// In zh, this message translates to:
  /// **'证件信息已更新'**
  String get identityResultTitle;

  /// No description provided for @identityResultMessage.
  ///
  /// In zh, this message translates to:
  /// **'OCR、活体验证和 Soft Token mock 流程已完成。'**
  String get identityResultMessage;

  /// No description provided for @identityStepWaitingOcr.
  ///
  /// In zh, this message translates to:
  /// **'等待 OCR'**
  String get identityStepWaitingOcr;

  /// No description provided for @identityStepScanning.
  ///
  /// In zh, this message translates to:
  /// **'OCR 识别中'**
  String get identityStepScanning;

  /// No description provided for @identityStepOcrCompleted.
  ///
  /// In zh, this message translates to:
  /// **'OCR 完成'**
  String get identityStepOcrCompleted;

  /// No description provided for @identityStepSigning.
  ///
  /// In zh, this message translates to:
  /// **'活体验证与签名中'**
  String get identityStepSigning;

  /// No description provided for @identityStepCompleted.
  ///
  /// In zh, this message translates to:
  /// **'证件更新完成'**
  String get identityStepCompleted;

  /// No description provided for @identityScanRequired.
  ///
  /// In zh, this message translates to:
  /// **'请先完成 OCR'**
  String get identityScanRequired;

  /// No description provided for @identityFaceVerifyFailed.
  ///
  /// In zh, this message translates to:
  /// **'活体验证未通过'**
  String get identityFaceVerifyFailed;

  /// No description provided for @resultTitle.
  ///
  /// In zh, this message translates to:
  /// **'处理结果'**
  String get resultTitle;

  /// No description provided for @resultDefaultTitle.
  ///
  /// In zh, this message translates to:
  /// **'提交成功'**
  String get resultDefaultTitle;

  /// No description provided for @resultDefaultMessage.
  ///
  /// In zh, this message translates to:
  /// **'业务处理已完成。'**
  String get resultDefaultMessage;

  /// No description provided for @resultBackCustomers.
  ///
  /// In zh, this message translates to:
  /// **'返回客户列表'**
  String get resultBackCustomers;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In zh, this message translates to:
  /// **'账号'**
  String get settingsAccount;

  /// No description provided for @settingsLoginStatus.
  ///
  /// In zh, this message translates to:
  /// **'登录状态'**
  String get settingsLoginStatus;

  /// No description provided for @settingsLoggedInUser.
  ///
  /// In zh, this message translates to:
  /// **'已登录：{userName}'**
  String settingsLoggedInUser(Object userName);

  /// No description provided for @settingsNotLoggedIn.
  ///
  /// In zh, this message translates to:
  /// **'未登录'**
  String get settingsNotLoggedIn;

  /// No description provided for @settingsClearToken.
  ///
  /// In zh, this message translates to:
  /// **'清除 Token'**
  String get settingsClearToken;

  /// No description provided for @settingsLogout.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认退出当前登录？'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsLanguage.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageChinese.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageChinese;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsAppInfo.
  ///
  /// In zh, this message translates to:
  /// **'应用信息'**
  String get settingsAppInfo;

  /// No description provided for @settingsCurrentEnv.
  ///
  /// In zh, this message translates to:
  /// **'当前环境'**
  String get settingsCurrentEnv;

  /// No description provided for @settingsBaseUrl.
  ///
  /// In zh, this message translates to:
  /// **'Base URL'**
  String get settingsBaseUrl;

  /// No description provided for @settingsDiagnosticsTool.
  ///
  /// In zh, this message translates to:
  /// **'诊断工具'**
  String get settingsDiagnosticsTool;

  /// No description provided for @settingsFloatingButton.
  ///
  /// In zh, this message translates to:
  /// **'右下角悬浮按钮'**
  String get settingsFloatingButton;

  /// No description provided for @settingsProductionDisabled.
  ///
  /// In zh, this message translates to:
  /// **'生产包已关闭'**
  String get settingsProductionDisabled;

  /// No description provided for @devToolTitle.
  ///
  /// In zh, this message translates to:
  /// **'开发工具'**
  String get devToolTitle;

  /// No description provided for @devToolCurrentNetwork.
  ///
  /// In zh, this message translates to:
  /// **'当前网络'**
  String get devToolCurrentNetwork;

  /// No description provided for @devToolEnvLine.
  ///
  /// In zh, this message translates to:
  /// **'环境：{env}'**
  String devToolEnvLine(Object env);

  /// No description provided for @devToolMockMasterLine.
  ///
  /// In zh, this message translates to:
  /// **'Mock 总开关：{status}'**
  String devToolMockMasterLine(Object status);

  /// No description provided for @devToolMockOn.
  ///
  /// In zh, this message translates to:
  /// **'开启'**
  String get devToolMockOn;

  /// No description provided for @devToolMockOff.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get devToolMockOff;

  /// No description provided for @devToolMockPrdDisabled.
  ///
  /// In zh, this message translates to:
  /// **'prd 禁用'**
  String get devToolMockPrdDisabled;

  /// No description provided for @devToolMockedApiCountLine.
  ///
  /// In zh, this message translates to:
  /// **'已 Mock 接口：{count} 个'**
  String devToolMockedApiCountLine(Object count);

  /// No description provided for @devToolMockMasterSwitch.
  ///
  /// In zh, this message translates to:
  /// **'接口 Mock 总开关'**
  String get devToolMockMasterSwitch;

  /// No description provided for @devToolMockMasterEnabledHint.
  ///
  /// In zh, this message translates to:
  /// **'开启后，只拦截下方启用的接口'**
  String get devToolMockMasterEnabledHint;

  /// No description provided for @devToolMockMasterPrdHint.
  ///
  /// In zh, this message translates to:
  /// **'prd 环境不允许接口 Mock'**
  String get devToolMockMasterPrdHint;

  /// No description provided for @devToolMockRules.
  ///
  /// In zh, this message translates to:
  /// **'接口 Mock 规则'**
  String get devToolMockRules;

  /// No description provided for @devToolNoMockedApi.
  ///
  /// In zh, this message translates to:
  /// **'当前没有接口被 mock'**
  String get devToolNoMockedApi;

  /// No description provided for @devToolRestoreDefaultRules.
  ///
  /// In zh, this message translates to:
  /// **'恢复默认 Mock 规则'**
  String get devToolRestoreDefaultRules;

  /// No description provided for @devToolViewLogs.
  ///
  /// In zh, this message translates to:
  /// **'查看日志'**
  String get devToolViewLogs;

  /// No description provided for @devToolLogTitle.
  ///
  /// In zh, this message translates to:
  /// **'诊断日志'**
  String get devToolLogTitle;

  /// No description provided for @devToolLogCount.
  ///
  /// In zh, this message translates to:
  /// **'当前 {count} 条'**
  String devToolLogCount(Object count);

  /// No description provided for @devToolClearLogs.
  ///
  /// In zh, this message translates to:
  /// **'清空日志'**
  String get devToolClearLogs;

  /// No description provided for @devToolCurrentUser.
  ///
  /// In zh, this message translates to:
  /// **'当前登录用户'**
  String get devToolCurrentUser;

  /// No description provided for @devToolMockTools.
  ///
  /// In zh, this message translates to:
  /// **'Mock 工具'**
  String get devToolMockTools;

  /// No description provided for @devToolMockToolsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'预留入口：接口错误注入、假数据场景、功能开关'**
  String get devToolMockToolsSubtitle;

  /// No description provided for @mockToolTitle.
  ///
  /// In zh, this message translates to:
  /// **'Mock 管理'**
  String get mockToolTitle;

  /// No description provided for @runtimeErrorTitle.
  ///
  /// In zh, this message translates to:
  /// **'前端错误'**
  String get runtimeErrorTitle;

  /// No description provided for @runtimeErrorDetailTitle.
  ///
  /// In zh, this message translates to:
  /// **'错误详情'**
  String get runtimeErrorDetailTitle;

  /// No description provided for @runtimeErrorCaptured.
  ///
  /// In zh, this message translates to:
  /// **'捕获到前端错误'**
  String get runtimeErrorCaptured;

  /// No description provided for @runtimeErrorEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无前端错误'**
  String get runtimeErrorEmpty;

  /// No description provided for @runtimeErrorCount.
  ///
  /// In zh, this message translates to:
  /// **'当前 {count} 条'**
  String runtimeErrorCount(Object count);

  /// No description provided for @runtimeErrorClear.
  ///
  /// In zh, this message translates to:
  /// **'清空错误'**
  String get runtimeErrorClear;

  /// No description provided for @runtimeErrorCopy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get runtimeErrorCopy;

  /// No description provided for @runtimeErrorCopyAll.
  ///
  /// In zh, this message translates to:
  /// **'复制完整信息'**
  String get runtimeErrorCopyAll;

  /// No description provided for @runtimeErrorCopied.
  ///
  /// In zh, this message translates to:
  /// **'错误信息已复制'**
  String get runtimeErrorCopied;

  /// No description provided for @runtimeErrorViewDetail.
  ///
  /// In zh, this message translates to:
  /// **'查看详情'**
  String get runtimeErrorViewDetail;

  /// No description provided for @runtimeErrorSource.
  ///
  /// In zh, this message translates to:
  /// **'来源'**
  String get runtimeErrorSource;

  /// No description provided for @runtimeErrorTime.
  ///
  /// In zh, this message translates to:
  /// **'时间'**
  String get runtimeErrorTime;

  /// No description provided for @runtimeErrorContext.
  ///
  /// In zh, this message translates to:
  /// **'上下文'**
  String get runtimeErrorContext;

  /// No description provided for @runtimeErrorMessage.
  ///
  /// In zh, this message translates to:
  /// **'错误信息'**
  String get runtimeErrorMessage;

  /// No description provided for @runtimeErrorStack.
  ///
  /// In zh, this message translates to:
  /// **'堆栈信息'**
  String get runtimeErrorStack;

  /// No description provided for @runtimeErrorTriggerTest.
  ///
  /// In zh, this message translates to:
  /// **'触发测试异常'**
  String get runtimeErrorTriggerTest;

  /// No description provided for @runtimeErrorTriggerTestSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'用于验证前端错误捕获、弹框和复制能力'**
  String get runtimeErrorTriggerTestSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
