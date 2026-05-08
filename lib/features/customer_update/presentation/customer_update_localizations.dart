import '../../../app/l10n/generated/app_localizations.dart';
import '../../../shared/ui/widgets/app_picker_field.dart';
import '../domain/customer_update_field_error.dart';
import '../domain/customer_update_policy.dart';

extension CustomerUpdateFieldErrorL10n on CustomerUpdateFieldError {
  String localize(AppLocalizations l10n) => switch (this) {
    CustomerUpdateFieldError.requiredName => l10n.validationRequiredName,
    CustomerUpdateFieldError.requiredEmail => l10n.validationRequiredEmail,
    CustomerUpdateFieldError.invalidEmail => l10n.validationInvalidEmail,
    CustomerUpdateFieldError.requiredMobile => l10n.validationRequiredMobile,
    CustomerUpdateFieldError.invalidMobile => l10n.validationInvalidMobile,
    CustomerUpdateFieldError.requiredIndustry =>
      l10n.validationRequiredIndustry,
    CustomerUpdateFieldError.requiredProfession =>
      l10n.validationRequiredProfession,
    CustomerUpdateFieldError.acceptedTermsRequired =>
      l10n.validationAcceptedTermsRequired,
  };
}

List<PickerOption> localizedIndustries(AppLocalizations l10n) =>
    CustomerUpdatePolicy.industries
        .map(
          (option) =>
              PickerOption(option.value, _industryLabel(option.value, l10n)),
        )
        .toList();

List<PickerOption> localizedProfessions(
  String? industry,
  AppLocalizations l10n,
) => CustomerUpdatePolicy.professions(industry)
    .map(
      (option) =>
          PickerOption(option.value, _professionLabel(option.value, l10n)),
    )
    .toList();

String _industryLabel(String value, AppLocalizations l10n) => switch (value) {
  'tech' => l10n.industryTech,
  'finance' => l10n.industryFinance,
  'service' => l10n.industryService,
  _ => value,
};

String _professionLabel(String value, AppLocalizations l10n) => switch (value) {
  'engineer' => l10n.professionEngineer,
  'designer' => l10n.professionDesigner,
  'analyst' => l10n.professionAnalyst,
  'advisor' => l10n.professionAdvisor,
  'operator' => l10n.professionOperator,
  'consultant' => l10n.professionConsultant,
  _ => value,
};
