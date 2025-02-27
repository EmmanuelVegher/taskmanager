import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../AllWidgets/button.dart';
import '../AllWidgets/input_field.dart';
import '../controllers/task_controller.dart';
import '../model/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.find(); // Use Get.find() to get the existing controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now());
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(context), // Extracted AppBar to a separate method
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 15,
                ),
              ),
              MyInputField(
                title: "Title",
                hint: "Enter title here",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton<String>( // Specify DropdownButton type
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      fontSize: screenWidth / 25,
                      fontFamily: "NexaBold"),
                  underline: Container(height: 0),
                  value: _selectedRemind.toString(), // Set value to _selectedRemind.toString()
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton<String>( // Specify DropdownButton type
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      fontSize: screenWidth / 25,
                      fontFamily: "NexaBold"),
                  underline: Container(height: 0),
                  value: _selectedRepeat, // Set value to _selectedRepeat
                  items: repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: screenWidth / 25,
                            fontFamily: "NexaBold"),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: screenWidth / 21,
                            fontFamily: "NexaBold"),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List<Widget>.generate(3, (int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: index == 0
                                    ? Colors.red
                                    : index == 1
                                    ? Colors.blue
                                    : Colors.yellow,
                                child: _selectedColor == index
                                    ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 16,
                                )
                                    : Container(),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  MyButton(label: "Create Task", onTap: _validateData), // Corrected method name
                ],
              ),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) { // Extracted AppBar method
    return AppBar(
      backgroundColor: context.theme.colorScheme.surface,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      elevation: 0.5,
      iconTheme: IconThemeData(
          color: Get.isDarkMode ? Colors.white : Colors.black87),
      actions: [
        Container(
          margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
          child: Image.asset("assets/image/taskManager2.jpg"), // Simplified Image Widget
        )
      ],
    );
  }


  _validateData() { // Corrected method name to _validateData (lowercase 'v')
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required !",
          colorText: Get.isDarkMode ? Colors.black : Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ));
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("My task id is " + "$value");
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2090),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await _showTimePicker();

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);

      if (isStartTime) {
        setState(() {
          _startTime = formattedTime;
        });
      } else {
        setState(() {
          _endTime = formattedTime;
        });
      }
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: _parseTimeOfDay(_startTime) ?? TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });
  }

  TimeOfDay? _parseTimeOfDay(String timeString) {
    try {
      return TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(timeString));
    } catch (e) {
      print("Error parsing time string: $e");
      return null;
    }
  }
}