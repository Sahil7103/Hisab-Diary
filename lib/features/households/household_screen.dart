import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/v3_strings.dart';
import 'household_controller.dart';

class HouseholdScreen extends ConsumerStatefulWidget {
  const HouseholdScreen({super.key});
  @override
  ConsumerState<HouseholdScreen> createState() => _HouseholdScreenState();
}
class _HouseholdScreenState extends ConsumerState<HouseholdScreen> {
  bool _busy = false;
  Future<void> _perform(Future<void> Function() action, {bool close = false}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && close) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v3Text(context,'householdSaveError'))));
    } finally { if (mounted) setState(() => _busy = false); }
  }
  Future<void> _name([Household? household]) async {
    final controller = TextEditingController(text: household?.name ?? '');
    final key = GlobalKey<FormState>();
    final value = await showDialog<String>(context: context, builder: (context) => AlertDialog(
      title: Text(v3Text(context,household == null ? 'householdAdd' : 'householdRename')),
      content: Form(key:key,child: TextFormField(controller:controller,autofocus:true,maxLength:50,
        decoration:InputDecoration(labelText:v3Text(context,'householdName')),
        validator:(value) => value == null || value.trim().isEmpty ? v3Text(context,'householdEmptyName') : null)),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),child:Text(v3Text(context,'cancel'))),
        TextButton(onPressed:(){if(key.currentState!.validate()) Navigator.pop(context,controller.text.trim());},
          child:Text(v3Text(context,'save')))]));
    // Wait until the dialog route has released its field before disposing it.
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    if (!mounted || value == null) return;
    final notifier = ref.read(householdControllerProvider.notifier);
    await _perform(() => household == null
      ? notifier.add(value,preferences: ref.read(settingsProvider).asData?.value ?? {})
      : notifier.rename(household.id,value), close: household == null);
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(householdControllerProvider);
    return NotebookBackground(child:Scaffold(backgroundColor:Colors.transparent,
      body:SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
        Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back)),
          Expanded(child:DiaryScreenHeader(title:v3Text(context,'householdsTitle')))]),
        Text(v3Text(context,'householdSwitchInfo'),style:Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height:16),
        for(final row in state.households) Card(child:ListTile(
          leading:Icon(row.id == state.selectedId ? Icons.home_rounded : Icons.home_outlined,color:DiaryColors.pen),
          title:Text(row.name),subtitle:row.id == state.selectedId ? Text(v3Text(context,'householdCurrent')) : null,
          onTap:_busy || row.id == state.selectedId ? null : ()=>_perform(
            ()=>ref.read(householdControllerProvider.notifier).select(row.id),close:true),
          trailing:IconButton(tooltip:v3Text(context,'householdRename'),onPressed:_busy ? null : ()=>_name(row),icon:const Icon(Icons.edit_outlined)))),
        const SizedBox(height:16),
        DiaryButton(label:v3Text(context,'householdAdd'),onPressed:_busy ? null : ()=>_name()),
        const SizedBox(height:12),Text(v3Text(context,'householdBackupInfo')),
        if(_busy) const Center(child:CircularProgressIndicator()),
      ]))));
  }
}
