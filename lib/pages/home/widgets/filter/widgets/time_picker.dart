import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/pages/home/widgets/filter/filter_provider.dart';

class DatePicker extends ConsumerWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();
    DateTime mindate = DateTime(now.year, now.month, now.day - 2);
    DateTime maxdate = DateTime(now.year, now.month, now.day);
    final filterProvider = ref.watch<FilterPage>(alertPageConfig);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // Display a CupertinoDatePicker in time picker mode.
      onPressed: () => filterProvider.showDialog(
        context,
        CupertinoDatePicker(
          initialDateTime: mindate,
          mode: CupertinoDatePickerMode.dateAndTime,
          maximumDate: maxdate,
          minimumDate: mindate,

          use24hFormat: true,
          // This is called when the user changes the time.
          onDateTimeChanged: (DateTime newTime) {
            print(newTime);
            filterProvider.changeListTime(newTime);
          },
        ),
      ),

      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: Row(
          children: [
            Text(
                filterProvider.time == null
                    ? filterProvider.defaultText
                    : '${filterProvider.time!.hour}:${filterProvider.time!.minute}',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              width: 6,
            ),
            Icon(
              LucideIcons.chevronsUpDown,
              color: Theme.of(context).secondaryHeaderColor,
            )
          ],
        ),
      ),
    );
  }
}
