import UIKit

public protocol SwipeLabelViewDelegate: class {
    func leftEvent()
    func rightEvent()
}

class SwipeLabelView: UIView {
    
    public weak var delegate: SwipeLabelViewDelegate?
    var date = Date() {
        willSet(newDate) {
            guard newDate != date
                else { return }
            labels.last!.text = newDate.format(with: .medium)
            print("DayView = \(String(describing: labels.last?.text))")
            let shouldMoveForward = newDate.isLater(than: date)
            animate(shouldMoveForward)
        }
    }
    
    var firstLabel: UILabel {
        return labels.first!
    }
    
    var secondLabel: UILabel {
        return labels.last!
    }
    
    var labels = [UILabel]()
    var btnLeft = UIImageView()
    var btnRight = UIImageView()
    var btnClose = UIImageView()
    
    var style = SwipeLabelStyle()
    
    init(date: Date) {
        self.date = date
        super.init(frame: .zero)
        configure()
        labels.first!.text = date.format(with: .medium)
        
        print("DayView = \(date.format(with: .full))")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        for _ in 0...1 {
            let label = UILabel()
            label.textAlignment = .center
            labels.append(label)
            
            addSubview(label)
        }
//        btnLeft.setTitle("<", for:.normal)
        btnLeft.backgroundColor = UIColor.blue
//        btnRight.setTitle("?", for:.normal)
        btnRight.backgroundColor = UIColor.blue
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let h = self.bounds.height - 14
        btnRight.frame = CGRect(x: screenSize.size.width - 100, y: 7, width: h - 6, height: h)
        btnLeft.frame = CGRect(x: 100 - (h - 6), y: 7, width: h - 6, height: h)
        
        btnClose.frame = CGRect(x: screenSize.size.width - h - 15, y: 7, width: h, height: h)
        
        let gestureLeft = UITapGestureRecognizer.init(target: self, action: #selector(SwipeLabelView.leftClick(_:)))
        self.btnLeft.isUserInteractionEnabled = true
        self.btnLeft.addGestureRecognizer(gestureLeft)
        
        let gestureRight = UITapGestureRecognizer.init(target: self, action: #selector(SwipeLabelView.rightClick(_:)))
        self.btnRight.isUserInteractionEnabled = true
        self.btnRight.addGestureRecognizer(gestureRight)
        
        let gestureClose = UITapGestureRecognizer.init(target: self, action: #selector(SwipeLabelView.closeClick(_:)))
        self.btnClose.isUserInteractionEnabled = true
        self.btnClose.addGestureRecognizer(gestureClose)
        
        
        addSubview(btnLeft)
        addSubview(btnRight)
        addSubview(btnClose)
        updateStyle(style)
    }
    func leftClick(_ sender: Any) {
        delegate?.leftEvent()
    }
    func rightClick(_ sender: Any) {
        delegate?.rightEvent()
    }
    
    func closeClick(_ sender: Any) {
        style.closeHandler?()
    }
    func updateStyle(_ newStyle: SwipeLabelStyle) {
        style = newStyle.copy() as! SwipeLabelStyle
        labels.forEach { label in
            label.textColor = style.textColor
            label.font = style.textFont
        }
        
        if let backIcon = style.backIcon{
//            btnLeft.setTitle("", for: .normal)
            btnLeft.backgroundColor = UIColor.clear
            btnLeft.image = backIcon
        }
        
        if let nextIcon = style.nextIcon{
//            btnRight.setTitle("", for: .normal)
            btnRight.backgroundColor = UIColor.clear
            btnRight.image = nextIcon
        }
        
        if let closeIcon = style.closeIcon{
//            btnClose.setTitle("", for: .normal)
            btnClose.backgroundColor = UIColor.clear
            btnClose.image = closeIcon
        }
        
        let h = self.bounds.height - 14
        
        btnRight.frame = CGRect(x: bounds.size.width - 100 , y: 7, width: h - 6, height: h)
        btnLeft.frame = CGRect(x: 100 - (h - 6), y: 7, width: h - 6, height: h)
        
        btnClose.frame = CGRect(x: bounds.size.width - h - 7, y: 7, width: h, height: h)
        
        
    }
    
    func animate(_ forward: Bool) {
        let multiplier: CGFloat = forward ? -1 : 1
        let shiftRatio: CGFloat = 30/375
        let screenWidth = bounds.width
        
        secondLabel.alpha = 0
        secondLabel.frame = bounds
        secondLabel.frame.origin.x -= CGFloat(shiftRatio * screenWidth * 3) * multiplier
        
        UIView.animate(withDuration: 0.3, animations: { _ in
            self.secondLabel.frame = self.bounds
            self.firstLabel.frame.origin.x += CGFloat(shiftRatio * screenWidth) * multiplier
            self.secondLabel.alpha = 1
            self.firstLabel.alpha = 0
        }, completion: { _ in
            self.labels = self.labels.reversed()
        }) 
    }
    
    override func layoutSubviews() {
        for subview in subviews {
            
            
            if subview is UILabel {
                // obj is a String. Do something with str
                subview.frame = bounds
            }
            else {
                // obj is not a String
            }
        }
    }
}
