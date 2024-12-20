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
    Station(id: "jfKfPfyJRdk", title: "Lofi Music"),
    Station(id: "7NOSDKb0HlU", title: "Chillhop Music"),
    Station(id: "5yx6BWlEVcY", title: "Nujabes Style Radio"),
    Station(id: "ldPf3yqq3-8", title: "Piano Solo Radio"),
    Station(id: "rUxyKA_-grg", title: "Coffee Shop Radio"),

    // Jazz & Chill
    Station(id: "Dx5qFachd3A", title: "Cafe Music BGM"),
    Station(id: "DSGyEsJ17cI", title: "Jazzy & Coffee Music"),
    Station(id: "MCLmZh6z1mw", title: "Peaceful Piano Radio"),
    Station(id: "gwDoRPcPxtc", title: "Jazz Cafe Radio"),

    // Ambient & Study
    Station(id: "-5KAN9_CzSA", title: "ChilledCow Study Music"),
    Station(id: "MVPTGNGiI-4", title: "Ambient Study Music"),
    Station(id: "lP6-qyqv8Tg", title: "Relaxing Music Radio"),
    Station(id: "21qNxnCS8WU", title: "ChillHop YT Radio"),

    // Nature & Meditation
    Station(id: "5qap5aO4i9A", title: "Relaxing Nature Sounds"),
    Station(id: "y7e-GC6oGhg", title: "Calm Piano Music"),
    Station(id: "WWTJ3mUmep0", title: "Meditation Music"),

    // Classical & Piano
    Station(id: "M1yxRGTvlD8", title: "Classical Music Radio"),
  ];
}
