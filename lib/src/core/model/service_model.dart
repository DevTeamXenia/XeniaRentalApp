class ServiceModel {
  final int serviceID;
  final String serviceName;
  final String servicePhoneNumber;
  final String serviceWhatappNumber;
  final int serviceCompanyID;
  final int servicePropertyID;
  final String serviceType;
  final bool serviceStatus;

  ServiceModel({
    required this.serviceID,
    required this.serviceName,
    required this.servicePhoneNumber,
    required this.serviceWhatappNumber,
    required this.serviceCompanyID,
    required this.servicePropertyID,
    required this.serviceType,
    required this.serviceStatus,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceID: json['serviceID'],
      serviceName: json['serviceName'],
      servicePhoneNumber: json['servicePhoneNumber'],
      serviceWhatappNumber: json['serviceWhatappNumber'],
      serviceCompanyID: json['serviceCompanyID'],
      servicePropertyID: json['servicePropertyID'],
      serviceType: json['serviceType'],
      serviceStatus: json['ServiceStatus'] ?? true,
    );
  }
}
