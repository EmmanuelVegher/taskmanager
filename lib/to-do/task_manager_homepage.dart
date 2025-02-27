import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../AllWidgets/button.dart';
import '../AllWidgets/task_tile.dart';
import '../controllers/task_controller.dart';
import '../model/task.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';
import '../theme.dart';
import 'add_task_bar.dart';

class TaskManagerHomePage extends StatefulWidget {
  const TaskManagerHomePage({Key? key}) : super(key: key);

  @override
  State<TaskManagerHomePage> createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper; // Changed to late initialization
  double screenHeight = 0;
  double screenWidth = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper(); // Initialize here
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks(); // Load tasks in initState
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _appBar(), // Extracted AppBar to a separate method
      backgroundColor: context.theme.colorScheme.surface,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() { // Extracted AppBar method for better readability
    return AppBar(
      backgroundColor: context.theme.colorScheme.surface,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode ? "Activated Light Theme" : "Activated Dark Theme");
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
        ),
      ),
      title: Text(
        "Task Manager",
        style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.grey[600],
            fontFamily: "NexaBold"),
      ),
      elevation: 0.5,
      iconTheme: IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black87),
      actions: [
        Container(
          margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
          child: Image.asset("assets/image/taskManager2.jpg"), // Simplified Image Widget
        )
      ],
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            // Schedule notification only if task is not completed and repeat is daily or date matches
            if (task.isCompleted == 0) {
              if (task.repeat == "Daily") {
                _scheduleDailyNotification(task); // Separate method for daily scheduling
              } else if (task.date == DateFormat.yMd().format(_selectedDate)) {
                _scheduleNotificationForDate(task); // Separate method for date-specific scheduling
              }
            }

            if (task.repeat == "Daily" || task.date == DateFormat.yMd().format(_selectedDate)) { // Show tasks for daily or selected date
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(); // Return empty container if task doesn't match criteria
            }
          },
        );
      }),
    );
  }

  _scheduleDailyNotification(Task task) {
    String? startTime = task.startTime;
    DateTime? date;
    if (startTime != null) {
      try {
        date = DateFormat.jm().parse(startTime.trim());
      } catch (e) {
        print("Error parsing time for task ${task.id}: ${task.startTime}, error: $e");
        return; // Exit if time parsing fails, avoid scheduling
      }
    }

    if (date != null) {
      var myTime = DateFormat("HH:mm").format(date);
      notifyHelper.scheduledNotification(
          int.parse(myTime.split(":")[0]),
          int.parse(myTime.split(":")[1]),
          task);
    }
  }

  _scheduleNotificationForDate(Task task) {
    String? startTime = task.startTime;
    DateTime? date;
    if (startTime != null) {
      try {
        date = DateFormat.jm().parse(startTime.trim());
      } catch (e) {
        print("Error parsing time for task ${task.id}: ${task.startTime}, error: $e");
        return; // Exit if time parsing fails, avoid scheduling
      }
    }

    if (date != null) {
      var myTime = DateFormat("HH:mm").format(date);
      // Schedule notification for the specific date and time
      DateTime scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(myTime.split(":")[0]),
        int.parse(myTime.split(":")[1]),
      );

      notifyHelper.scheduleNotificationAtDateTime( // Use new method in NotifyHelper
        scheduledDateTime,
        task,
      );
    }
  }


  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            if (task.isCompleted != 1) // Use if condition for better readability
              _bottomSheetButton(
                label: "Task Completed",
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: Colors.red,
                context: context,
              ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.blue,
              context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.blue,
              isClose: true,
              context: context,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? TextStyle(
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontFamily: "NexaBold")
                : const TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: "NexaBold"),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.red,
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
            fontSize: 20, fontFamily: "NexaBold", color: Colors.grey),
        dayTextStyle: const TextStyle(
            fontSize: 15, fontFamily: "NexaLight", color: Colors.grey),
        monthTextStyle: const TextStyle(
            fontSize: 14, fontFamily: "NexaBold", color: Colors.grey),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: DateTime.now().day.toString(),
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth / 18,
                      fontFamily: "NexaBold"),
                  children: [
                    TextSpan(
                      text: DateFormat(" MMMM, yyyy").format(DateTime.now()),
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: screenWidth / 20,
                          fontFamily: "NexaBold"),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks(); // Refresh tasks after adding
            },
          )
        ],
      ),
    );
  }
}