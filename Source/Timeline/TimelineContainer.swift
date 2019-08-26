import UIKit

class TimelineContainer: UIScrollView, ReusableView {

  var timeline: TimelineView!

  override func layoutSubviews() {
    timeline.frame = CGRect(x: 0, y: 0, width: frame.width, height: timeline.fullHeight)
    contentSize.height = timeline.frame.height
  }

  func prepareForReuse() {
    timeline.prepareForReuse()
  }

  func scrollToFirstEvent() {
    let yToScroll = timeline.firstEventYPosition ?? 0
    setContentOffset(CGPoint(x: contentOffset.x, y: yToScroll), animated: true)
  }
  
  func scrollTo(hour24: Float) {
    let percentToScroll = CGFloat(hour24 / Float(timeline.times.count))
    let yToScroll = contentSize.height * percentToScroll
    let padding: CGFloat = 8
    setContentOffset(CGPoint(x: contentOffset.x, y: yToScroll - padding), animated: true)
  }
}
