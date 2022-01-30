import 'package:dart_date/dart_date.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tep_flutter/models/day_info.dart';
import 'package:tep_flutter/providers/home_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tep_flutter/widgets/tools.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    int year = DateTime.now().year;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                '$year ',
                style: const TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '時間電價日曆',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 64,
          ),
          Expanded(
            // height: 650,
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: MeetingDataSource(_getDataSource()),
              monthCellBuilder: _monthCellBuilder,

              // by default the month appointment display mode set as Indicator, we can
              // change the display mode as appointment using the appointment display
              // mode property
              showNavigationArrow: true,
              allowAppointmentResize: true,

              // allowViewNavigation: true,

              showDatePickerButton: true,
              maxDate: DateTime(year, 12, 31),
              minDate: DateTime(year, 1, 1),
              monthViewSettings: const MonthViewSettings(
                monthCellStyle: MonthCellStyle(),
                dayFormat: 'EEE',
                showTrailingAndLeadingDates: false,
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: true,
                agendaItemHeight: 35,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0F8644),
                ),
              ),
              const Text(' : 表示節日，並非所有節日都是假日離峰時間。'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: 16,
                color: Colors.red.withOpacity(0.5),
              ),
              const Text(' : 表示離峰日，全日24小時均為離峰時間。'),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    ));
  }

  List<Meeting> _getDataSource() {
    final dayInfos = context.read<HomeProvider>().dayInfos;
    List<Meeting> meetings = <Meeting>[];

    meetings = dayInfos
        .map((e) =>
            Meeting(e.name, e.date, e.date, const Color(0xFF0F8644), true))
        .toList();

    return meetings;
  }

  Widget _monthCellBuilder(
      BuildContext buildContext, MonthCellDetails details) {
    final dayInfos = buildContext.read<HomeProvider>().dayInfos;
    final bool isHoliday = checkHoliday(details.date, dayInfos);

    final Color defaultColor =
        Theme.of(buildContext).colorScheme.brightness == Brightness.dark
            ? Colors.white
            : Colors.black54;
    debugPrint(details.toString());
    // final bool isBestPrice = airFare.fare == _kBestPrice;
    // final bool isDisabledDate =
    //     details.date.isBefore(_minDate) && !isSameDate(details.date, _minDate);
    return Container(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.1, color: defaultColor),
            left: BorderSide(width: 0.1, color: defaultColor),
          ),
          color: isHoliday ? Colors.red.withOpacity(0.5) : null),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  details.date.day.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

bool checkHoliday(DateTime date, List<DayInfo> dayInfos) {
  if (date.isSaturday || date.isSunday) {
    return true;
  } else {
    for (var element in dayInfos) {
      if (element.date.isSameDate(date)) {
        // nowInfo.holidayNmae = element.name;
        if (element.tep == 1) {
          return true;
        }
      }
    }
    return false;
  }
}
