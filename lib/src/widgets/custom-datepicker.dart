import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  var date;
  var title;
  var dob;
  Function(DateTime) onChanged;

  DatePickerField.withDate(this.date, {this.dob,this.title = "selected date", this.onChanged} );
  DatePickerField({this.dob,this.title = "selected date", this.onChanged}): date = dob==null ? DateTime.now() : dob;

  @override createState() => _DatePickerFieldState();

  static String formattedDate(DateTime date)
    => date.day.toString() + "\t-\t" + ["January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][date.month-1] + "\t-\t" + date.year.toString();
}

class _DatePickerFieldState extends State<DatePickerField> {
  var _textFieldController = TextEditingController();

  @override initState() {
    super.initState();
    _textFieldController.text = DatePickerField.formattedDate(widget.date);
    widget.onChanged(widget.date);
  }

  @override build(context) => Padding(
    padding: EdgeInsets.all(0.0),
    child: Stack(
      children: [
        TextField(
          enabled: false,
          controller: _textFieldController,

          decoration: InputDecoration(
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey)),
              labelText: widget.title,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              )
          ),
        ),

        Align(
          alignment: Alignment(1,-1),
          child: IconButton(
            icon: Icon(Icons.date_range),

            onPressed: () {
              showDatePicker(
                  context: context,
                  lastDate: DateTime(3000),
                  firstDate: DateTime(1950),
                  initialDate: widget.dob==null ? DateTime.now() : widget.dob,

                  builder: (context, child) => Theme(data: ThemeData.dark(), child: child,)
              ).then((date) { if (date != null) this._textFieldController.text = DatePickerField.formattedDate(date); widget.onChanged(date); });
            },
          ),
        ),
      ],
    ),
  );
}