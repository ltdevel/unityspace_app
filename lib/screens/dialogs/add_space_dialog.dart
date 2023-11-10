import 'package:flutter/material.dart';
import 'package:unityspace/plugins/wstore_plugin.dart';
import 'package:unityspace/store/spaces_store.dart';
import 'package:unityspace/widgets/color_button_widget.dart';
import 'package:wstore/wstore.dart';

Future<int?> showAddSpaceDialog(BuildContext context) async {
  return showDialog<int?>(
    context: context,
    builder: (context) {
      return const AddSpaceDialog();
    },
  );
}

class AddSpaceDialogStore extends WStore {
  final TextEditingController textEditingController = TextEditingController();
  WStoreStatus status = WStoreStatus.init;
  String addError = '';
  int newSpaceId = 0;

  void addSpace() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      newSpaceId = 0;
      addError = '';
      status = WStoreStatus.loading;
    });
    //
    final String title = textEditingController.text.trim();
    if (title.isEmpty) {
      setStore(() {
        status = WStoreStatus.error;
        addError = 'Название пространства не может быть пустым';
      });
      return;
    }
    //
    subscribe(
      future: SpacesStore().createSpace(title),
      subscriptionId: 1,
      onData: (id) {
        setStore(() {
          newSpaceId = id;
          status = WStoreStatus.loaded;
        });
      },
      onError: (error, __) {
        String errorText =
            'При создании пространства возникла проблема, пожалуйста, попробуйте ещё раз';
        setStore(() {
          status = WStoreStatus.error;
          addError = errorText;
        });
      },
    );
  }

  @override
  AddSpaceDialog get widget => super.widget as AddSpaceDialog;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

class AddSpaceDialog extends WStoreWidget<AddSpaceDialogStore> {
  const AddSpaceDialog({
    super.key,
  });

  @override
  AddSpaceDialogStore createWStore() => AddSpaceDialogStore();

  @override
  Widget build(BuildContext context, AddSpaceDialogStore store) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Color(0xFF212022), width: 2),
      ),
      title: const Text('Добавить пространство'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Создайте пространство и добавьте в него ваших коллег, чтобы организовать совместную работу над задачами',
          ),
          const SizedBox(height: 12),
          const Text(
            'Название:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            controller: store.textEditingController,
            onEditingComplete: () {
              store.addSpace();
            },
          ),
          WStoreValueBuilder(
            store: store,
            watch: (store) => store.addError,
            builder: (context, error) {
              if (error.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error,
                  style: const TextStyle(
                    color: Color(0xFFBE4500),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          WStoreStatusBuilder(
            store: store,
            watch: (store) => store.status,
            builder: (context) {
              final loading = store.status == WStoreStatus.loading;
              return ColorButtonWidget(
                width: double.infinity,
                onPressed: () {
                  store.addSpace();
                },
                text: 'Добавить пространство',
                loading: loading,
                colorBackground: const Color(0xFF111012),
                colorText: Colors.white,
              );
            },
            onStatusLoaded: (context) {
              Navigator.of(context).pop(store.newSpaceId);
            },
          ),
        ],
      ),
    );
  }
}
