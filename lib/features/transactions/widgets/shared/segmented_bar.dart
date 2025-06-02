import '../../../../utils/utils.dart';


class Segment {
  final Color color;
  final double fraction; // between 0.0 and 1.0
  Segment({required this.color, required this.fraction});
}

class PercentageSegmentBar extends StatelessWidget {
  final List<Segment> segments;
  final double height;
  final Widget separator;

  const PercentageSegmentBar({
    super.key,
    required this.segments,
    this.height = 20,
    this.separator = const SizedBox(width: 2),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(height /4),
        child: Container(
          color: AppColors.neutral100,
          padding: EdgeInsets.all(2),
          child: Row(
            children: [
              for (var i = 0; i < segments.length; i++) ...[
                // each Container width = totalWidth * fraction
                Container(
                  width: constraints.maxWidth * segments[i].fraction,
                  margin: EdgeInsets.only(left: i == segments.length  ? 0 : 2),
                  decoration: BoxDecoration(
                    color: segments[i].color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  height: height,
                ),
                if (i < segments.length - 1) separator,
              ],
            ],
          ),
        ),
      );
    });
  }
}
