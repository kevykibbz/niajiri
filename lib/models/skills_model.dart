class SkillsModel {
  final String employeeId;
  final DateTime date;
  final bool? isSelected;
  final bool? employee;

  SkillsModel({
    required this.employeeId,
    this.employee=false,
    required this.date,
    this.isSelected = false,
  });

  toJson() {
    return {
      "EmployeeIdId": employeeId,
      "employee": employee,
      "Date": date,
      "IsSelected": isSelected,
    };
  }
}
