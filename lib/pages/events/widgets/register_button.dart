import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../db/db_model/db_model_events.dart';
import '../../../global/global_veriable/events_info.dart';
import '../../../global/global_veriable/user_info.dart';

class RegisterButton extends ConsumerWidget {
  const RegisterButton({
    super.key,
    required this.userInfo,
    required this.event,
  });

  final UserInfo userInfo;
  final ClassModelEvents? event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAction = ref.watch<EventsInfo>(eventsInfoConfig);

    if (event!.capacity! - event!.participantsNumber! == 0) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff485FFF),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: null,
          child: Row(
            children: [
              Text(
                "No Seat",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                LucideIcons.calendarX,
                size: 20,
              )
            ],
          ));
    } else if (userInfo.user!.registeredEvents!.contains(event!.id) == false) {
      if (userInfo.user!.dateTimeList!.contains(event!.timestamp) == true) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff485FFF),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder()),
            onPressed: null,
            child: Row(
              children: const [
                Text(
                  "No Seat",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ));
      } else {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff485FFF),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder()),
            onPressed: () {
              userInfo.writeUser(registeredEvents: event!.id, eventTime: event!.timestamp);
              eventAction.writeEvents(event: event);
            },
            child: Row(
              children: const [
                Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ));
      }
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffEB5757),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () {
            userInfo.removeEvent(registeredEvents: event!.id, eventTime: event!.timestamp);
            eventAction.removeEventUser(event: event);
          },
          child: Row(
            children: const [
              Text(
                "Unregister",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                LucideIcons.calendarCheck,
                size: 19,
              )
            ],
          ));
    }
  }
}
