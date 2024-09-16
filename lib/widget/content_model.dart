// unboarding_content.dart
class UnboardingContent {
  final String image;
  final String title;
  final String description;

  UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    image: "assets/images/screen1.png",
    title: "Select from our Menu\n   Best Menu",
    description: "Pick your food from our menu\n   More than 35 items",
  ),
  UnboardingContent(
    image: "assets/images/screen2.png",
    title: "Easy and Online Payment",
    description: "You can pay cash on delivery\n   Card payment is also available",
  ),
  UnboardingContent(
    image: "assets/images/screen3.png",
    title: "Quick Delivery at Your Doorstep",
    description: "Get your food delivered right at your\n   doorstep",
  ),
];
