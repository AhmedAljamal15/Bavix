class CreateCustomerRequest {
  final String customerName;
  final String customerType;
  final String emailId;

  const CreateCustomerRequest({
    required this.customerName,
    required this.customerType,
    required this.emailId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_type': customerType,
      'email_id': emailId,
    };
  }
}
