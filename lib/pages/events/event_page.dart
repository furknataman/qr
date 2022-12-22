import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/global_veriable/user_info.dart';

import 'widgets/location_widget.dart';

class Eventspage extends ConsumerStatefulWidget {
  final ClassModelEvents? event;
  const Eventspage(this.event, {Key? key}) : super(key: key);

  @override
  ConsumerState<Eventspage> createState() => _Eventspage(event: event);
}

class _Eventspage extends ConsumerState<Eventspage> {
  ClassModelEvents? event;
  _Eventspage({@required this.event});
  String? timeData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userInfo = ref.watch<UserInfo>(userInfoConfig);
    ClassTime time = classConverter(event!.dateTime!, event!.duration!);
    return Scaffold(
      /*floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.arrow_circle_left_outlined,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: const Color(0xff485FFF),
            pinned: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event!.name.toString(),
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              background: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.75), BlendMode.dstATop),
                      image: NetworkImage(
                        event!.imageUrl!,
                      ),
                      fit: BoxFit.fitHeight),
                  color: Colors.black,
                  /* borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))*/
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 17, right: 17),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*Text(
                        event!.name.toString(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),*/
                      RegisterButton(userInfo: userInfo, event: event),
                    ],
                  ),
                  textContainer(
                      "Date of Event", Theme.of(context).textTheme.displayMedium),
                  textContainer(
                      "${time.month.toString()} ${time.day.toString()}th ${time.clock.toString()}   ",
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Speakers", Theme.of(context).textTheme.displayMedium),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        context;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: textContainer(event!.speakers![index].toString(),
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 10),
                        );
                      },
                      itemCount: event!.speakers!.length,
                    ),
                  ),
                  textContainer("Description", Theme.of(context).textTheme.displayMedium),
                  textContainer(event!.description!.toString(),
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Description", Theme.of(context).textTheme.displayMedium),
                  textContainer(event!.description!.toString(),
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Where is ${event!.eventsLocation}?",
                      Theme.of(context).textTheme.displayMedium,
                      bottomPadding: 10),
                  LocationWidget(event: event),
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }

  Container textContainer(String? text, TextStyle? textStyle, {double bottomPadding = 5}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        text!,
        style: textStyle,
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.userInfo,
    required this.event,
  });

  final UserInfo userInfo;
  final ClassModelEvents? event;

  @override
  Widget build(BuildContext context) {
    if (userInfo.user!.registeredEvents!.contains(event!.id) == false) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff485FFF),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () {
            userInfo.writeUser(registeredEvents: event!.id);
          },
          child: Row(
            children: const [
              Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ));
    } else if (1 == 1) {
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
                "Past",
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
    } else {
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
                "Registered",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                LucideIcons.calendarCheck,
                size: 20,
              )
            ],
          ));
    }
  }
}
