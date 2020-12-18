import UIKit

open class StackPagerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var svButtons: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var underLine: UIView!
    var tabButtons: Array<UIButton> = []
    var currentIndex = 0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    private func setupScrollView() {
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        for (index, item) in svButtons.subviews.enumerated() {
            if let x = item as? UIButton {
                tabButtons.append(x)
                x.tag = index
                x.setTitle(getMenuTitle(index: index), for: .normal)
                x.addTarget(self, action: #selector(pressMenuButton), for: .touchUpInside)
            }
        }
        
        scrollToPage(page: 1, animated: true)
//        updateX(x: 1)
//        updateButtonSelect(index: 1)
    }
    
    @objc func pressMenuButton(btn: UIButton) {
        scrollToPage(page: btn.tag, animated: true)
        updateButtonSelect(index: btn.tag)
    }
    
    private func getMenuTitle(index: Int) -> String {
        switch index {
        case 0:
            return "Menu 1"
        case 1:
            return "Menu 2"
        case 2:
            return "Menu 3"
        default:
            return ""
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateX(x: scrollView.contentOffset.x)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateButtonSelect(index: currentIndex)
        print(currentIndex)
    }
    
    private func updateX(x: CGFloat) {
        let offsetX = x
        let screenWidth = CGFloat(UIScreen.main.bounds.width)
        let index = Int(offsetX / screenWidth)
        if currentIndex != index { currentIndex = index }
        let margin = screenWidth - svButtons.frame.width
        let halfMargin = margin / 2
        let barWidth = screenWidth - margin
        let underLineWidth = barWidth / CGFloat(tabButtons.count)
        let offsetRatio = underLineWidth / (barWidth + margin)
        let x = offsetX * offsetRatio + halfMargin
        underLine.frame = CGRect(x: x, y: underLine.frame.origin.y, width: underLineWidth, height: 4)
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    func updateButtonSelect(index:Int) {
        for i in tabButtons {
            i.isSelected = false
            i.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        tabButtons[index].isSelected = true
        tabButtons[index].titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
}
