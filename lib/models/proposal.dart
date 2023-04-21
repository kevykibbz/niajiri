class ProposalModel {
  final String employeeId;
  final String employerId;
  final String jobDescription;
  final String proposedPayment;
  final bool isRead;
  final bool isRejected;
  final bool isAccepted;
  final DateTime date;

  ProposalModel({
    required this.employeeId,
    required this.employerId,
    this.isRead=false,
    this.isAccepted=false,
    this.isRejected=false,
    required this.date,
    required this.jobDescription,
    required this.proposedPayment,
  });

  toJson() {
    return {
      "EmployerId": employerId,
      "EmployeeId": employeeId,
      "JobDescription": jobDescription,
      "ProposedPayment": proposedPayment,
      "IsRead": isRead,
      "IsAccepted": isAccepted,
      "IsRejected": isRejected,
    };
  }
}
