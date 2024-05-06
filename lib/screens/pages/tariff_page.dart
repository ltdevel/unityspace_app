import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TariffPageStore extends WStore {
  // TODO: add data here...

  @override
  TariffPage get widget => super.widget as TariffPage;
}

class TariffPage extends WStoreWidget<TariffPageStore> {
  const TariffPage({
    super.key,
  });

  @override
  TariffPageStore createWStore() => TariffPageStore();

  @override
  Widget build(BuildContext context, TariffPageStore store) {
    final localization = AppLocalizations.of(context);
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(localization!.payment_and_tariffs),
      ),
    );
  }
}
