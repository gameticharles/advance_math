import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Geometry Enhancements', () {
    group('Circle Components Bounding Box', () {
      test('Sector Bounding Box (90 degrees)', () {
        var sector = Sector(10, Angle(deg: 90));
        // Sector from 0 to 90 degrees.
        // Center (0,0), Radius 10.
        // Points: (0,0), (10,0), (0,10).
        // Arc contains (0, 10) which is max Y.
        // Bounding box should be [0,0] to [10,10].
        var bbox = sector.boundingBox();
        // bbox returns [minX, maxX, maxX, minX] points?
        // No, it returns [min, min], [max, min], [max, max], [min, max]

        expect(bbox[0].x, closeTo(0, 1e-10));
        expect(bbox[0].y, closeTo(0, 1e-10));
        expect(bbox[2].x, closeTo(10, 1e-10));
        expect(bbox[2].y, closeTo(10, 1e-10));
      });

      test('Arc Bounding Box (Semicircle)', () {
        var arc = Arc(10, Angle(deg: 180));
        // Semicircle from 0 to 180.
        // Points: (10,0) to (-10,0) via (0,10).
        // MinX: -10, MaxX: 10.
        // MinY: 0, MaxY: 10.
        var bbox = arc.boundingBox();

        expect(bbox[0].x, closeTo(-10, 1e-10)); // Min X
        expect(bbox[0].y, closeTo(0, 1e-10)); // Min Y
        expect(bbox[2].x, closeTo(10, 1e-10)); // Max X
        expect(bbox[2].y, closeTo(10, 1e-10)); // Max Y
      });
    });

    group('Triangle Centers', () {
      test('Right Triangle (3-4-5)', () {
        var t = Triangle(A: Point(0, 0), B: Point(3, 0), C: Point(0, 4));

        // Centroid: average of coords
        expect(t.centroid.x, closeTo(1.0, 1e-10));
        expect(t.centroid.y, closeTo(4 / 3, 1e-10));

        // Orthocenter: (0,0) for right triangle at origin
        expect(t.orthocenter.x, closeTo(0, 1e-10));
        expect(t.orthocenter.y, closeTo(0, 1e-10));

        // Circumcenter: Midpoint of hypotenuse
        // Hypotenuse is BC (from (3,0) to (0,4)). Midpoint: (1.5, 2)
        expect(t.circumCenter.x, closeTo(1.5, 1e-10));
        expect(t.circumCenter.y, closeTo(2.0, 1e-10));

        // Incenter: (r, r) where r = 1
        expect(t.inCenter.x, closeTo(1.0, 1e-10));
        expect(t.inCenter.y, closeTo(1.0, 1e-10));
      });
    });

    group('Polygon Features', () {
      test('Hexagon Properties', () {
        var hex = Hexagon(10);

        // Apothem = inRadius = side * sqrt(3)/2
        expect(hex.apothem, closeTo(10 * sqrt(3) / 2, 1e-10));

        // Sum interior angles = 720
        expect(hex.sumInteriorAngles, equals(720));
      });

      test('Pentagon Properties', () {
        var pent = Pentagon(10);

        // Sum interior angles = 540
        expect(pent.sumInteriorAngles, equals(540));

        // Short diagonal
        // side * 2 * cos(36)
        expect(pent.shortDiagonal, closeTo(20 * cos(pi / 5), 1e-10));
      });
    });
  });
}
