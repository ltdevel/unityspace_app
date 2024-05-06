import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MembersPageStore extends WStore {
  // TODO: add data here...

  @override
  MembersPage get widget => super.widget as MembersPage;
}

class MembersPage extends WStoreWidget<MembersPageStore> {
  const MembersPage({
    super.key,
  });

  @override
  MembersPageStore createWStore() => MembersPageStore();

  @override
  Widget build(BuildContext context, MembersPageStore store) {
    final localization = AppLocalizations.of(context);
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(localization!.members_of_the_organization),
      ),
    );
  }
}
