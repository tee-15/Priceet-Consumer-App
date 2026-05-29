import 'package:flutter/material.dart';
import '../models/country.dart';
import '../theme/app_colors.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final Country selected;
  final ValueChanged<Country> onSelect;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = kCountries
        .where((c) =>
            c.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.dial.contains(_query))
        .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Country',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.brandBlue,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search country...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: AppColors.lightText,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.lightText,
                  ),
                  filled: true,
                  fillColor: AppColors.fieldBg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.brandBlue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 280,
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  final isSelected =
                      c.dial == widget.selected.dial && c.name == widget.selected.name;
                  return ListTile(
                    leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                    title: Text(
                      c.name,
                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15),
                    ),
                    trailing: Text(
                      c.dial,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: AppColors.greyText,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: const Color(0xFFF0F4FF),
                    onTap: () => widget.onSelect(c),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
