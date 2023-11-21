import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

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
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Участники организации'),
      ),
    );
  }
}
