import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/storage/app_database.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import '../pro/pro_screen.dart';
import '../pro/vendor_limits.dart';
import 'vendor_repository.dart';
import 'vendor_type.dart';

final allVendorsProvider = StreamProvider<List<Vendor>>((ref) =>
  ref.watch(vendorRepositoryProvider).watchAll());

class ManageVendorsScreen extends ConsumerStatefulWidget {
  const ManageVendorsScreen({super.key});
  @override
  ConsumerState<ManageVendorsScreen> createState() => _ManageVendorsScreenState();
}
class _ManageVendorsScreenState extends ConsumerState<ManageVendorsScreen> {
  bool _busy = false;
  Future<void> _archive(Vendor vendor) async {
    if (_busy) return;
    final strings = AppLocalizations.of(context)!;
    if (!vendor.archived) {
      final confirmed = await showDialog<bool>(context: context, builder: (context) =>
        AlertDialog(title: Text(strings.archiveVendor), content: Text(strings.archiveExplanation),
          actions: [
            TextButton(style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
              onPressed: () => Navigator.of(context).pop(false), child: Text(strings.cancel)),
            TextButton(style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
              onPressed: () => Navigator.of(context).pop(true), child: Text(strings.archiveVendor)),
          ]));
      if (!mounted || confirmed != true) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(vendorRepositoryProvider).setArchived(vendor.id, !vendor.archived);
    } on VendorLimitException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(strings.vendorLimitReached(error.limit.toString())),
        action: SnackBarAction(label: strings.proTitle, onPressed: () => Navigator.of(context)
          .push<void>(MaterialPageRoute(builder: (_) => const ProScreen())))));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.saveError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final vendors = ref.watch(allVendorsProvider);
    return NotebookBackground(child: Scaffold(body: SafeArea(child: vendors.when(
      loading: () => Center(child: Semantics(label: strings.loading,
        child: const CircularProgressIndicator())),
      error: (_, _) => Center(child: DiaryButton(label: strings.retry,
        onPressed: () => ref.invalidate(allVendorsProvider))),
      data: (rows) => ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
        Row(children: [
          const BackButton(color: DiaryColors.ink),
          Expanded(child: DiaryScreenHeader(title: strings.manageVendors)),
        ]),
        const SizedBox(height: 18),
        Text(strings.archiveExplanation, style: Theme.of(context).textTheme.bodyLarge),
        if (rows.isEmpty) Text(strings.noVendorsCalendar,
          style: Theme.of(context).textTheme.bodyLarge),
        for (final vendor in rows) Container(margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(14), decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: DiaryColors.ink, width: 2)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(vendor.name.isEmpty ? vendorTypeLabel(strings, vendor.type) : vendor.name,
              style: Theme.of(context).textTheme.titleLarge),
            Text(vendor.archived ? strings.vendorArchived : strings.vendorActive,
              style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            DiaryButton(label: vendor.archived ? strings.activateVendor : strings.archiveVendor,
              color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink,
              onPressed: _busy ? null : () => _archive(vendor)),
          ])),
      ]),
    ))));
  }
}
