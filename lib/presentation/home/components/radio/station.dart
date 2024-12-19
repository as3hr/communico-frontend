class Station {
  String title;
  String id;
  bool isPlaying;
  bool isMuted;

  Station({
    required this.id,
    required this.title,
    this.isPlaying = false,
    this.isMuted = false,
  });

  copyWith({
    String? title,
    String? id,
    bool? isPlaying,
    bool? isMuted,
  }) {
    return Station(
      id: id ?? this.id,
      title: title ?? this.title,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  static final stations = [
    // Lofi hip hop
    Station(id: "jfKfPfyJRdk", title: "Lofi Girl"),
    Station(id: "7NOSDKb0HlU", title: "Chillhop Music"),
    Station(id: "lP26UCnoH9s", title: "STEEZYASFUCK"),
    Station(id: "HBPtQVzRZUY", title: "the bootleg boy 2"),
    // Jazz
    Station(id: "Dx5qFachd3A", title: "Cafe Music BGM"),
    Station(id: "JJq34sWY4GY", title: "Cozy Coffee Shop"),
    Station(id: "xl0NMRAnqbA", title: "Piano Jazz Music"),
    // Synthwave
    Station(id: "4xDzrJKXOOY", title: "Synthwave-lofi"),
    Station(id: "q-I_K2YQLy8", title: "The Prime Thanatos"),
    // House
    Station(id: "UedTcufyrHc", title: "Deep House Radio"),
    Station(id: "hIf_x11fRxE", title: "Tropical House Radio"),
    Station(id: "wBgSH-CGPzg", title: "Tomorrowland Radio"),
    Station(id: "JOXRElW1LCA", title: "Toolroom Live"),
  ];

  static final playListIds = [
    "jfKfPfyJRdk",
    "7NOSDKb0HlU",
    "lP26UCnoH9s",
    "HBPtQVzRZUY",
    "Dx5qFachd3A",
    "JJq34sWY4GY",
    "xl0NMRAnqbA",
    "4xDzrJKXOOY",
    "q-I_K2YQLy8",
    "UedTcufyrHc",
    "hIf_x11fRxE",
    "wBgSH-CGPzg",
    "JOXRElW1LCA",
  ];
}
