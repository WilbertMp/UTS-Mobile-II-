class Utility {
  static String strFormattedDate(String str) {
    DateTime dateTime = DateTime.parse(str);
    String formattedDateTime =
        "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return formattedDateTime;
  }

  static String truncateDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    } else {
      int lastSpaceIndex = description.lastIndexOf(' ', maxLength);
      return description.substring(0, lastSpaceIndex);
    }
  }
}
