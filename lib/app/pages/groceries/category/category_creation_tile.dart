import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryCreationTextProvider = StateProvider<String>((ref) => '');

class CategoryCreationTile extends ConsumerWidget {
  final void Function(String) addCategory;
  CategoryCreationTile({super.key, required this.addCategory});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        trailing: IconButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              addCategory(controller.text);
              controller.clear();
            }
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
        title: SizedBox(
          height: 36,
          child: TextField(
            controller: controller,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              contentPadding: const EdgeInsets.only(left: 16.0),
              hintText: 'Nouvelle catégorie :',
            ),
            onChanged: (newCategoryName) {
              ref.read(categoryCreationTextProvider.notifier).state =
                  newCategoryName;
            },
          ),
        ),
      ),
    );
  }
}
