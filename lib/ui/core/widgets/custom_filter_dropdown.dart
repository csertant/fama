import 'package:material_ui/material_ui.dart';

import '../themes/dimensions.dart';
import 'widgets.dart';

class CustomFilterDropdown extends StatelessWidget {
  const CustomFilterDropdown({
    super.key,
    required this.label,
    required this.selected,
    required this.options,
    required this.onOptionSelected,
  });

  final String label;
  final List<String> selected;
  final List<String> options;
  final void Function(String) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return options;
        }
        return options.where((opt) => opt.toLowerCase().contains(query));
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        final theme = Theme.of(context);
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
            prefixIcon: const CustomIcon(
              iconPath: CustomIcons.search,
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
            ),
            suffixIcon: selected.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: AppDimensions.paddingSmall,
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Badge.count(count: selected.length),
                    ),
                  )
                : const CustomIcon(
                    iconPath: CustomIcons.arrowDown,
                    padding: EdgeInsets.all(AppDimensions.paddingSmall),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium,
              ),
            ),
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, filteredOptions) {
        final theme = Theme.of(context);
        final list = filteredOptions.toList();
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.paddingExtraSmall),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusMedium,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: AppDimensions.dropdownOptionsMaxHeight,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final option = list[index];
                  final isChecked = selected.contains(option);
                  return CheckboxListTile(
                    dense: true,
                    value: isChecked,
                    title: Text(option, style: theme.textTheme.labelMedium),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (_) => onOptionSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
