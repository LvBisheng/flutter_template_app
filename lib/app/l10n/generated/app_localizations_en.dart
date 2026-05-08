// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Enterprise Starter';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonNoData => 'No data';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirmTitle => 'Please confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navDemos => 'Demos';

  @override
  String get navSettings => 'Settings';

  @override
  String get demoHubTitle => 'Feature Demos';

  @override
  String get demoCustomerTitle => 'Customer Profile Management';

  @override
  String get demoCustomerSubtitle =>
      'Business pages, routing, network mock, complex forms, and identity update flow';

  @override
  String get demoBusinessLogTitle => 'Business Log Upload';

  @override
  String get demoBusinessLogSubtitle =>
      'Demonstrates silent upload for a single business log';

  @override
  String get demoBusinessLogDescription =>
      'Use this for lightweight cases such as API failures, SDK failures, or file download failures. Recording and upload are best-effort, and upload failure will not interrupt the user flow.';

  @override
  String get demoBusinessLogUploadPdfFailure =>
      'Upload mock PDF download failure log';

  @override
  String get demoBusinessLogUploadSuccess => 'Log uploaded successfully';

  @override
  String get demoBusinessLogUploadSkipped => 'Log upload skipped';

  @override
  String get demoBusinessLogUploadFailed => 'Log upload failed silently';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginEmptyCredentials => 'Please enter username and password';

  @override
  String get customerListTitle => 'Customer Profiles';

  @override
  String get customerListEmpty => 'No customer profiles';

  @override
  String customerDetailTitle(Object customerId) {
    return 'Customer Detail $customerId';
  }

  @override
  String get customerEmail => 'Email';

  @override
  String get customerMobile => 'Mobile';

  @override
  String get customerVerificationStatus => 'Verification status';

  @override
  String get customerIndustryProfession => 'Industry / Profession';

  @override
  String get customerLastUpdated => 'Last updated';

  @override
  String get customerEditProfile => 'Edit profile';

  @override
  String get customerUpdateIdentity => 'Update identity';

  @override
  String get customerUpdateTitle => 'Edit Profile';

  @override
  String get customerName => 'Name';

  @override
  String get customerIndustry => 'Industry';

  @override
  String get customerChooseIndustry => 'Choose industry';

  @override
  String get customerProfession => 'Profession';

  @override
  String get customerChooseProfession => 'Choose profession';

  @override
  String get customerChooseIndustryFirst => 'Choose industry first';

  @override
  String customerBirthdayValue(Object value) {
    return 'Birthday: $value';
  }

  @override
  String get customerAcceptedTerms =>
      'I confirm this customer profile is valid';

  @override
  String get customerContactMethod => 'Preferred contact channel';

  @override
  String get customerContactEmail => 'Email';

  @override
  String get customerContactMobile => 'Mobile';

  @override
  String get customerSubmitEdit => 'Submit changes';

  @override
  String get customerUpdateSuccessTitle => 'Customer profile updated';

  @override
  String get customerUpdateSuccessMessage =>
      'The customer update flow finished through the mock API.';

  @override
  String get validationRequiredName => 'Please enter a name';

  @override
  String get validationRequiredEmail => 'Please enter an email';

  @override
  String get validationInvalidEmail =>
      'Email format is invalid, for example demo@example.com';

  @override
  String get validationRequiredMobile => 'Please enter a mobile number';

  @override
  String get validationInvalidMobile => 'Mobile number must be 11 digits';

  @override
  String get validationRequiredIndustry => 'Please choose an industry';

  @override
  String get validationRequiredProfession => 'Please choose a profession';

  @override
  String get validationAcceptedTermsRequired =>
      'Please accept the profile validity statement';

  @override
  String get industryTech =>
      'Technology / Internet / Software and Information Services';

  @override
  String get industryFinance =>
      'Finance / Insurance / Securities and Wealth Management';

  @override
  String get industryService =>
      'Professional Services / Consulting / Customer Operations';

  @override
  String get professionEngineer =>
      'Senior Software Engineer / Solution Architect';

  @override
  String get professionDesigner =>
      'Product Designer / User Experience Specialist';

  @override
  String get professionAnalyst => 'Risk Analyst / Investment Research Analyst';

  @override
  String get professionAdvisor =>
      'Private Client Advisor / Financial Planning Consultant';

  @override
  String get professionOperator =>
      'Customer Operations Manager / Service Delivery Lead';

  @override
  String get professionConsultant =>
      'Business Consultant / Implementation Specialist';

  @override
  String get identityUpdateTitle => 'Identity Update';

  @override
  String get identityFlowDescription =>
      'OCR -> Liveness check -> Soft Token signature -> Submit API';

  @override
  String get identityStartOcr => 'Start OCR';

  @override
  String get identityRescanOcr => 'Scan again';

  @override
  String get identityName => 'Legal name';

  @override
  String get identityNumber => 'Identity number';

  @override
  String get identityBirthday => 'Date of birth';

  @override
  String get identityExpiryDate => 'Identity expiry date';

  @override
  String get identitySubmitNext => 'Continue and submit';

  @override
  String get identityResultTitle => 'Identity information updated';

  @override
  String get identityResultMessage =>
      'The OCR, liveness, and Soft Token mock flow is complete.';

  @override
  String get identityStepWaitingOcr => 'Waiting for OCR';

  @override
  String get identityStepScanning => 'Scanning with OCR';

  @override
  String get identityStepOcrCompleted => 'OCR completed';

  @override
  String get identityStepSigning => 'Running liveness check and signing';

  @override
  String get identityStepCompleted => 'Identity update completed';

  @override
  String get identityScanRequired => 'Please complete OCR first';

  @override
  String get identityFaceVerifyFailed => 'Liveness verification failed';

  @override
  String get resultTitle => 'Result';

  @override
  String get resultDefaultTitle => 'Submitted successfully';

  @override
  String get resultDefaultMessage => 'The business flow is complete.';

  @override
  String get resultBackCustomers => 'Back to customers';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsLoginStatus => 'Login status';

  @override
  String settingsLoggedInUser(Object userName) {
    return 'Signed in: $userName';
  }

  @override
  String get settingsNotLoggedIn => 'Not signed in';

  @override
  String get settingsClearToken => 'Clear Token';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get settingsLogoutConfirm => 'Sign out of the current account?';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageChinese => 'Simplified Chinese';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppInfo => 'App Info';

  @override
  String get settingsCurrentEnv => 'Current environment';

  @override
  String get settingsBaseUrl => 'Base URL';

  @override
  String get settingsDiagnosticsTool => 'Diagnostics';

  @override
  String get settingsFloatingButton => 'Floating button';

  @override
  String get settingsProductionDisabled => 'Disabled in production';

  @override
  String get devToolTitle => 'Dev Tools';

  @override
  String get devToolCurrentNetwork => 'Current network';

  @override
  String devToolEnvLine(Object env) {
    return 'Env: $env';
  }

  @override
  String devToolMockMasterLine(Object status) {
    return 'Mock master switch: $status';
  }

  @override
  String get devToolMockOn => 'On';

  @override
  String get devToolMockOff => 'Off';

  @override
  String get devToolMockPrdDisabled => 'Disabled in prd';

  @override
  String devToolMockedApiCountLine(Object count) {
    return 'Mocked APIs: $count';
  }

  @override
  String get devToolMockMasterSwitch => 'API mock master switch';

  @override
  String get devToolMockMasterEnabledHint =>
      'Only enabled rules below will be intercepted';

  @override
  String get devToolMockMasterPrdHint => 'API mock is not allowed in prd';

  @override
  String get devToolMockRules => 'API mock rules';

  @override
  String get devToolNoMockedApi => 'No API is currently mocked';

  @override
  String get devToolRestoreDefaultRules => 'Restore default mock rules';

  @override
  String get devToolViewLogs => 'View logs';

  @override
  String get devToolLogTitle => 'Diagnostics Logs';

  @override
  String devToolLogCount(Object count) {
    return '$count records';
  }

  @override
  String get devToolClearLogs => 'Clear logs';

  @override
  String get devToolCurrentUser => 'Current user';

  @override
  String get devToolMockTools => 'Mock Tools';

  @override
  String get devToolMockToolsSubtitle =>
      'Reserved for API error injection, fake data scenarios, and feature flags';

  @override
  String get mockToolTitle => 'Mock Management';

  @override
  String get runtimeErrorTitle => 'Frontend Errors';

  @override
  String get runtimeErrorDetailTitle => 'Error Detail';

  @override
  String get runtimeErrorCaptured => 'Frontend error captured';

  @override
  String get runtimeErrorEmpty => 'No frontend errors';

  @override
  String runtimeErrorCount(Object count) {
    return '$count records';
  }

  @override
  String get runtimeErrorClear => 'Clear errors';

  @override
  String get runtimeErrorCopy => 'Copy';

  @override
  String get runtimeErrorCopyAll => 'Copy full details';

  @override
  String get runtimeErrorCopied => 'Error details copied';

  @override
  String get runtimeErrorViewDetail => 'View detail';

  @override
  String get runtimeErrorSource => 'Source';

  @override
  String get runtimeErrorTime => 'Time';

  @override
  String get runtimeErrorContext => 'Context';

  @override
  String get runtimeErrorMessage => 'Error message';

  @override
  String get runtimeErrorStack => 'Stack trace';

  @override
  String get runtimeErrorTriggerTest => 'Trigger test error';

  @override
  String get runtimeErrorTriggerTestSubtitle =>
      'Use this to verify error capture, popup, and copy behavior';
}
