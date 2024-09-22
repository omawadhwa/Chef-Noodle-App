import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class SelectionBox extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueNotifier<Set<String>> selectedOptionsNotifier;

  SelectionBox({
    required this.title,
    required this.options,
    required this.selectedOptionsNotifier,
  });

  @override
  _SelectionBoxState createState() => _SelectionBoxState();
}

class _SelectionBoxState extends State<SelectionBox> {
  @override
  void initState() {
    super.initState();
    widget.selectedOptionsNotifier.addListener(_onOptionsChanged);
  }

  @override
  void dispose() {
    widget.selectedOptionsNotifier.removeListener(_onOptionsChanged);
    super.dispose();
  }

  void _onOptionsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedOptions = widget.selectedOptionsNotifier.value;

    return Container(
      decoration: BoxDecoration(
        color: TColors.secondary,
        border: Border.all(
          color: const Color.fromARGB(76, 0, 0, 0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(255, 150, 148, 145),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedOptions.add(option);
                    } else {
                      selectedOptions.remove(option);
                    }
                  });
                },
                selectedColor: TColors.success,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

