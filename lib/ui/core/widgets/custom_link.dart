import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/link.dart';

class CustomLink extends StatelessWidget {
  const CustomLink({
    super.key,
    required this.title,
    required this.url,
    this.style,
  });

  final String title;
  final TextStyle? style;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.tryParse(url ?? ''),
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: followLink,
            child: Text(
              title,
              style:
                  style ??
                  Theme.of(context).textTheme.titleMedium
                      ?.copyWith(decoration: TextDecoration.underline),
            ),
          ),
        );
      },
    );
  }
}
