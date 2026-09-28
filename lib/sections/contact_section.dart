import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/app_button.dart';
import 'package:portfolio/widgets/section.dart';

/// Contact form. On a valid submit the form is replaced by a confirmation.
///
/// Note: there is no backend yet, so messages are not delivered anywhere;
/// hook a service (e.g. an email API) into [_submit].
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  String? _sentBy;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sentBy = _name.text.trim());
  }

  void _reset() {
    _name.clear();
    _email.clear();
    _message.clear();
    setState(() => _sentBy = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l10n.contactRequired : null;

    final sentBy = _sentBy;
    return Section(
      title: l10n.contactTitle,
      subtitle: l10n.contactSubtitle,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: sentBy != null
                ? _Confirmation(
                    key: const ValueKey('sent'),
                    message: l10n.contactThanks(sentBy),
                    resetLabel: l10n.contactSendAnother,
                    onReset: _reset,
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: l10n.contactName,
                          ),
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          validator: required,
                        ),
                        const SizedBox(height: AppSpace.md),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: l10n.contactEmail,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: (v) =>
                              required(v) ??
                              (_emailPattern.hasMatch(v!.trim())
                                  ? null
                                  : l10n.contactInvalidEmail),
                        ),
                        const SizedBox(height: AppSpace.md),
                        TextFormField(
                          controller: _message,
                          decoration: InputDecoration(
                            labelText: l10n.contactMessage,
                            alignLabelWithHint: true,
                          ),
                          minLines: 5,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          validator: required,
                        ),
                        const SizedBox(height: AppSpace.lg),
                        AppButton(
                          label: l10n.contactSend,
                          icon: Icons.arrow_forward_rounded,
                          expand: true,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Confirmation extends StatelessWidget {
  const _Confirmation({
    super.key,
    required this.message,
    required this.resetLabel,
    required this.onReset,
  });

  final String message;
  final String resetLabel;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.accent800),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent),
              color: AppColors.accent900,
            ),
            child: const Icon(Icons.check_rounded, size: 18),
          ),
          const SizedBox(height: AppSpace.lg),
          Semantics(liveRegion: true, child: Text(message, style: AppText.h3)),
          const SizedBox(height: AppSpace.lg),
          AppButton(
            label: resetLabel,
            variant: AppButtonVariant.secondary,
            onPressed: onReset,
          ),
        ],
      ),
    );
  }
}
