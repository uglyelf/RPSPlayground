import UIKit

public final class ShapeView: UIView {
    override public class var layerClass: Swift.AnyClass { return CAShapeLayer.self }
    public lazy var shapeLayer: CAShapeLayer = { self.layer as! CAShapeLayer }()
}
