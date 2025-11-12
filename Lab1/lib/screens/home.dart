import 'package:flutter/material.dart';
import 'package:lab1/models/exam_model.dart';
import '../widgets/examGrid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Exam> getSortedExams() {
    final exams = getExams();
    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return exams;
  }
  List<Exam> getExams() => [
    Exam(name: 'Веб Програмирање', dateTime: DateTime(2025,11,21,17), classrooms: ['лаб. 2', 'лаб. 13', '117']),
    Exam(name: 'Дистрибуирани системи', dateTime: DateTime(2025,11,18,8), classrooms: ['117']),
    Exam(name: 'Пресметување во облак', dateTime: DateTime(2025,11,28,15), classrooms: ['117', 'Б 2.2']),
    Exam(name: 'Интернет технологии', dateTime: DateTime(2025,10,29,11,30), classrooms: ['138']),
    Exam(name: 'Математика 1', dateTime: DateTime(2025,12,7,14,30), classrooms: ['лаб. 13', 'лаб. 215', '117']),
    Exam(name: 'Бази на Податоци', dateTime: DateTime(2025,11,13,10), classrooms: ['лаб. 138', 'Б1']),
    Exam(name: 'Дигитизација', dateTime: DateTime(2025,11,9,16), classrooms: ['лаб. 2', 'лаб.13']),
    Exam(name: 'Криптографија', dateTime: DateTime(2025,10,25,9,30), classrooms: ['лаб. 200ц', '117', '138']),
    Exam(name: 'Виртуелизација', dateTime: DateTime(2025,11,24,12,30), classrooms: ['138']),
    Exam(name: 'Компјутерски Мрежи', dateTime: DateTime(2025,11,22,18), classrooms: ['лаб. 3']),
    Exam(name: 'Структурно Програмирање', dateTime: DateTime(2025,11,5,8), classrooms: ['лаб. 12', 'лаб. 200a']),
    Exam(name: 'Оперативни Системи', dateTime: DateTime(2025,11,15,14), classrooms: ['лаб. 12', 'лаб. 215']),
    Exam(name: 'Компјутерски Архитектури', dateTime: DateTime(2025,11,19,15), classrooms: ['АМФ', '315'])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
                child: ExamGrid(exam: getSortedExams())
            ),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.tealAccent.shade700,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Вкупно испити: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
                    child: Text('${getExams().length}', style:  TextStyle(color: Colors.tealAccent[700], fontWeight: FontWeight.bold, fontSize: 16.0)),
                  ),
                ],
              ),
            )
          ],
        ),
      )
        ],
        ),
      )
    );
  }
}