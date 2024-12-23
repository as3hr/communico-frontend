class Station {
  String title;
  String id;

  Station({
    required this.id,
    required this.title,
  });

  copyWith({
    String? title,
    String? id,
  }) {
    return Station(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  static final stations = [
    Station(id: "jfKfPfyJRdk", title: "lofi radio"),
    Station(id: "Uy1XHMEkKGA", title: "summurai"),
    Station(id: "7NOSDKb0HlU", title: "chillhop music"),
    Station(id: "5yx6BWlEVcY", title: "nujabes style radio"),
    Station(id: "5Qe16QYs9bE", title: "maxim"),
    Station(id: "ldPf3yqq3-8", title: "piano solo radio"),
    Station(id: "KPhqU--Mq1A", title: "rocky"),
    Station(id: "sgEJ4sOwboM", title: "summer tropical radio"),
    Station(id: "f02mOEt11OQ", title: "code-fi"),
    Station(id: "OxNeZiOr_zs", title: "@shuraa"),
    Station(id: "GedLli_YXEI", title: "weekend-fi"),
    Station(id: "J6kDgywJi_4", title: "beast"),
    Station(id: "Dx5qFachd3A", title: "cafe music"),
    Station(id: "DSGyEsJ17cI", title: "jazzy & coffee music"),
  ];
}
