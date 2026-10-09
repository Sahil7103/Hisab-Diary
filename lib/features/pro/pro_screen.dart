import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import 'pro_purchase_service.dart';
import 'vendor_limits.dart';

class ProScreen extends ConsumerStatefulWidget {
  const ProScreen({super.key});
  @override
  ConsumerState<ProScreen> createState() => _ProScreenState();
}
class _ProScreenState extends ConsumerState<ProScreen> {
  @override
  void initState() {
    super.initState();
    // Store queries happen only when the user opens the purchase screen.
    if (proPurchasesEnabled) ref.read(proPurchaseServiceProvider).load();
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    if (!proPurchasesEnabled) {
      return NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
        padding: const EdgeInsets.all(18), children: [
          const Align(alignment: Alignment.centerLeft, child: BackButton()),
          const SizedBox(height: 24),
          const Icon(Icons.lock_outline, size: 48, color: DiaryColors.pen),
          const SizedBox(height: 16),
          Text(strings.proComingSoon, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(strings.allFeaturesFree, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          DiaryButton(label: strings.proContinue, onPressed: () => Navigator.of(context).pop()),
        ]))));
    }
    final pro = ref.watch(settingsProvider).asData?.value[proEntitlementKey] == 'true';
    final service = ref.read(proPurchaseServiceProvider);
    final theme = Theme.of(context).textTheme;
    return ListenableBuilder(listenable: service, builder: (context, _) {
      final waiting = service.status == ProStoreStatus.loading || service.status == ProStoreStatus.pending;
      final message = switch (service.status) {
        ProStoreStatus.unavailable => strings.storeUnavailable,
        ProStoreStatus.failed => strings.purchaseError,
        ProStoreStatus.canceled => strings.purchaseCanceled,
        ProStoreStatus.restored => pro ? strings.proActive : strings.noProPurchase,
        _ => null,
      };
      return NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 24), children: [
          Row(children: [
            const BackButton(color: DiaryColors.ink),
            Expanded(child: Text(strings.proTitle, style: theme.titleLarge)),
          ]),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [DiaryColors.haldiSoft, DiaryColors.haldi]),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: DiaryColors.ink, width: 2)),
            child: Column(children: [
              Container(padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(color: DiaryColors.ink, shape: BoxShape.circle),
                child: const Icon(Icons.workspace_premium_rounded, color: DiaryColors.haldi, size: 48)),
              const SizedBox(height: 16),
              Text(pro ? strings.proActive : strings.proUpgradeTitle,
                textAlign: TextAlign.center, style: theme.headlineLarge),
              const SizedBox(height: 8),
              Text(strings.proDescription, textAlign: TextAlign.center, style: theme.bodyLarge),
            ])),
          const SizedBox(height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _PlanCard(title: strings.proFree, limit: freeVendorLimit,
              caption: strings.proVendorCaption, premium: false)),
            const SizedBox(width: 12),
            Expanded(child: _PlanCard(title: strings.proPremium, limit: proVendorLimit,
              caption: strings.proVendorCaption, premium: true)),
          ]),
          const SizedBox(height: 24),
          _Benefit(icon: Icons.people_alt_outlined, text: strings.proCapacity),
          const SizedBox(height: 16),
          _Benefit(icon: Icons.verified_outlined, text: strings.proOneTime),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          Text(strings.proEverydayHeading, style: theme.titleLarge),
          const SizedBox(height: 16),
          _Benefit(icon: Icons.touch_app_outlined, text: strings.proDailyHook),
          const SizedBox(height: 16),
          _Benefit(icon: Icons.fact_check_outlined, text: strings.proRecordsHook),
          const SizedBox(height: 16),
          _Benefit(icon: Icons.chat_bubble_outline_rounded, text: strings.proShareHook),
          const SizedBox(height: 16),
          _Benefit(icon: Icons.wifi_off_rounded, text: strings.proOfflineHook),
          const SizedBox(height: 16),
          Text(strings.proLocalDiary, style: theme.bodyMedium),
          const SizedBox(height: 24),
          Card(margin: EdgeInsets.zero, child: Padding(padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(pro ? strings.proActive : strings.proTitle,
                textAlign: TextAlign.center, style: theme.titleLarge),
              if (!pro && service.product != null) ...[
                const SizedBox(height: 8),
                Text(service.product!.price, textAlign: TextAlign.center, style: theme.displaySmall),
                Text(strings.proOneTime, textAlign: TextAlign.center, style: theme.bodyMedium),
                const SizedBox(height: 18),
                DiaryButton(label: strings.buyPro(service.product!.price),
                  color: DiaryColors.haldi, foreground: DiaryColors.ink, edge: DiaryColors.ink,
                  onPressed: service.busy ? null : service.buy),
              ],
              if (waiting) ...[
                const SizedBox(height: 18),
                Semantics(label: strings.purchasePending, liveRegion: true,
                  child: Column(children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(strings.purchasePending, textAlign: TextAlign.center, style: theme.bodyMedium),
                  ])),
              ],
              if (message != null) ...[
                const SizedBox(height: 18),
                Semantics(liveRegion: true, child: Text(message,
                  textAlign: TextAlign.center, style: theme.bodyMedium)),
              ],
              if (service.status == ProStoreStatus.unavailable || service.status == ProStoreStatus.failed) ...[
                const SizedBox(height: 12),
                DiaryButton(label: strings.retry, color: Colors.white,
                  foreground: DiaryColors.ink, edge: DiaryColors.ink,
                  onPressed: service.busy ? null : service.load),
              ],
            ]))),
          const SizedBox(height: 12),
          TextButton(onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.proContinue, textAlign: TextAlign.center)),
          TextButton(onPressed: service.busy ? null : service.restore,
            child: Text(strings.restorePurchases, textAlign: TextAlign.center)),
        ]))));
    });
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.limit,
    required this.caption, required this.premium});
  final String title;
  final int limit;
  final String caption;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = premium ? Colors.white : DiaryColors.ink;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(color: premium ? DiaryColors.ink : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DiaryColors.ink, width: 2)),
      child: Column(children: [
        Text(title, textAlign: TextAlign.center, style: theme.titleLarge!.copyWith(color: color)),
        Text('$limit', style: theme.displaySmall!.copyWith(color: premium ? DiaryColors.haldi : color)),
        Text(caption, textAlign: TextAlign.center, style: theme.bodyMedium!.copyWith(color: color)),
      ]));
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: DiaryColors.haldiSoft, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: DiaryColors.ink)),
    const SizedBox(width: 14),
    Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
  ]);
}
