import Foundation

public class EventResizeHandleView: UIView {
  public lazy var panGestureRecognizer = UIPanGestureRecognizer()
  public var borderColor: UIColor? {
    get {
      guard let cgColor = layer.borderColor else {return nil}
      return UIColor(cgColor: cgColor)
    }
    set(value) {
      layer.borderColor = value?.cgColor
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    clipsToBounds = true
    backgroundColor = .white
    layer.borderWidth = 1
    addGestureRecognizer(panGestureRecognizer)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }
}
