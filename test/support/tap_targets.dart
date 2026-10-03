import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every tappable semantics node smaller than [min] x [min] logical pixels.
///
/// flutter_test's androidTapTargetGuideline silently skips any node whose
/// rect starts at its parent's origin (it mistakes it for "touching the
/// screen edge"), so small controls laid out first in a row or dialog slip
/// through. This walks the tree with full transforms instead.
List<String> smallTapTargets(WidgetTester tester, {double min = 48}) {
  // ignore: deprecated_member_use
  final root = tester.binding.pipelineOwner.semanticsOwner?.rootSemanticsNode;
  if (root == null) {
    return ['no semantics tree (call tester.ensureSemantics())'];
  }
  final problems = <String>[];
  final ratio = tester.view.devicePixelRatio;

  void visit(SemanticsNode node, Matrix4 parent) {
    final transform = node.transform == null
        ? parent
        : parent.multiplied(node.transform!);
    node.visitChildren((child) {
      visit(child, transform);
      return true;
    });
    if (node.isMergedIntoParent || node.isInvisible) {
      return;
    }
    final data = node.getSemanticsData();
    final flags = data.flagsCollection;
    if (flags.isHidden || flags.isTextField || flags.isLink) {
      return;
    }
    if (!data.hasAction(SemanticsAction.tap) &&
        !data.hasAction(SemanticsAction.longPress)) {
      return;
    }
    final size = MatrixUtils.transformRect(transform, node.rect).size / ratio;
    if (size.width < min - 0.5 || size.height < min - 0.5) {
      final name = data.label.isNotEmpty
          ? data.label
          : (data.tooltip.isNotEmpty ? data.tooltip : '(unlabeled)');
      problems.add('"$name" is ${size.width.round()}x${size.height.round()}');
    }
  }

  visit(root, Matrix4.identity());
  return problems;
}
