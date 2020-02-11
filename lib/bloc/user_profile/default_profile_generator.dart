import "dart:math";

final List<String> colors = [
  "Salmon",
  "Blue",
  "Turquoise",
  "Orchid",
  "Purple",
  "Tomato",
  "Cyan",
  "Crimson",
  "Orange",
  "Lime",
  "Pink",
  "Green",
  "Red",
  "Yellow",
  "Azure",
  "Silver",
  "Magenta",
  "Olive",
  "Violet",
  "Rose",
  "Wine",
  "Mint",
  "Indigo",
  "Jade",
  "Coral",
];

// In alphabetical order
final List<String> animals = [
  "Bat",
  "Bear",
  "Boar",
  "Cat",
  "Chick",
  "Cow",
  "Deer",
  "Dog",
  "Eagle",
  "Elephant",
  "Fox",
  "Frog",
  "Hippo",
  "Hummingbird",
  "Koala",
  "Lion",
  "Monkey",
  "Mouse",
  "Owl",
  "Ox",
  "Panda",
  "Pig",
  "Rabbit",
  "Seagull",
  "Sheep",
  "Snake"
];

List generateDefaultProfile() {
  var random = Random();
  var randomColor = colors.elementAt(random.nextInt(colors.length));
  var randomAnimal = animals.elementAt(random.nextInt(animals.length));

  return [randomColor, randomAnimal];
}
