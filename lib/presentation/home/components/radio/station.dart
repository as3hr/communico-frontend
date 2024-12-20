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
    // Lofi hip hop
    Station(id: "jfKfPfyJRdk", title: "Lofi Girl"),
    Station(id: "7NOSDKb0HlU", title: "Chillhop Music"),
    // Station(id: "lP26UCnoH9s", title: "STEEZYASFUCK"),
    // Station(id: "HBPtQVzRZUY", title: "the bootleg boy 2"),
    // Jazz
    Station(id: "Dx5qFachd3A", title: "Cafe Music BGM"),
    // Station(id: "JJq34sWY4GY", title: "Cozy Coffee Shop"),
    // Station(id: "xl0NMRAnqbA", title: "Piano Jazz Music"),
    // Synthwave
    // Station(id: "4xDzrJKXOOY", title: "Synthwave-lofi"),
    // Station(id: "q-I_K2YQLy8", title: "The Prime Thanatos"),
    // House
    // Station(id: "UedTcufyrHc", title: "Deep House Radio"),
    // Station(id: "hIf_x11fRxE", title: "Tropical House Radio"),
    // Station(id: "wBgSH-CGPzg", title: "Tomorrowland Radio"),
    // Station(id: "JOXRElW1LCA", title: "Toolroom Live"),
  ];
}
