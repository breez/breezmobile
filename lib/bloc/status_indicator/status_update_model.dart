enum StatusUpdatePriority { LOW, HIGH }

class StatusUpdateModel {
  final String message;
  final StatusUpdatePriority priority;

  StatusUpdateModel(this.message, {this.priority = StatusUpdatePriority.LOW});
}
