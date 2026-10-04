enum RequestStatus {
  pending,
  inProgress,
  completed,
}

class RequestPreview {
  const RequestPreview({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
  });

  final String id;
  final String title;
  final RequestStatus status;
  final String date;
}
