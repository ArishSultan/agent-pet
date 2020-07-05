String getFormattedDate(String date) {
  var d = DateTime.parse(date);
  return   [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ][d.month - 1] +
      " " +   d.day.toString() +
      "," +
      d.year.toString();
}

