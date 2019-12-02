class POSProfileModel {
  final String invoiceString;
  final String logo;
  final String logoLocalPath;
  final bool uploadInProgress;
  final double cancellationTimeoutValue;

  POSProfileModel(this.invoiceString, this.logo,
      {this.logoLocalPath,
      this.uploadInProgress = false,
      this.cancellationTimeoutValue});

  POSProfileModel.empty()
      : invoiceString = null,
        logo = null,
        logoLocalPath = null,
        uploadInProgress = false,
        cancellationTimeoutValue = 90.0;

  POSProfileModel copyWith(
      {String invoiceString,
      String logo,
      String logoLocalPath,
      uploadInProgress,
      double cancellationTimeoutValue}) {
    return POSProfileModel(
        invoiceString ?? this.invoiceString, logo ?? this.logo,
        logoLocalPath: logoLocalPath ?? this.logoLocalPath,
        uploadInProgress: uploadInProgress ?? this.uploadInProgress,
        cancellationTimeoutValue:
            cancellationTimeoutValue ?? this.cancellationTimeoutValue);
  }

  POSProfileModel.fromJson(Map<String, dynamic> json)
      : invoiceString = json['invoiceString'],
        logo = json['logo'],
        logoLocalPath = json['logoLocalPath'],
        uploadInProgress = false,
        cancellationTimeoutValue = json['cancellationTimeoutValue'] == null
            ? 90.0
            : json['cancellationTimeoutValue'];

  Map<String, dynamic> toJson() => {
        'invoiceString': invoiceString,
        'logo': logo,
        'logoLocalPath': logoLocalPath,
        'cancellationTimeoutValue': cancellationTimeoutValue
      };
}
