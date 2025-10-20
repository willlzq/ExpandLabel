// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
public class ExpandLabel : UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        // 设置约束
         NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
         ])
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 
    
    //展开
    public  var openToken : [FoldableStyle] = [.text(title: " ... 展开", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)]
    private lazy var openAttributedString : NSAttributedString = {
        return truncationToken(true)
    }()
    //收起
    public  var closeToken : [FoldableStyle] = [.text(title: "收起", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)]
    private lazy var closeAttributedString : NSAttributedString = {
        return truncationToken(false)
    }()
    
    //是否展开
    public var isExpanded = false
    public var attributedText: NSAttributedString?
    public var maxnumberOfLines: Int = 2
    // 是否启用展开/收起动画
    public var haveAnimate = false
    // 动画持续时间，默认0.3秒
    public var animationDuration: TimeInterval = 0.3

 }
//显示
extension ExpandLabel {
    public  func reload() {
        guard let attributedText = attributedText else { return }
        setNeedsLayout()
        layoutIfNeeded()
        let lines = framelines(attributedText)
        guard maxnumberOfLines > 0, lines.count >= maxnumberOfLines else {
            textLabel.attributedText = attributedText
            return
        }
        let length = lines.prefix(maxnumberOfLines).reduce(0) { x,line in
            return x +  CTLineGetStringRange(line).length
        }
        let  truncationAttributedString = isExpanded ? closeAttributedString : openAttributedString
        let truncationTokenWidth = truncationAttributedString.size().width
        //可显示长度
        let showLength: Int = isExpanded ? attributedText.length : min(CTLineGetStringIndexForPosition(lines[maxnumberOfLines - 1], CGPoint(x: textLabel.bounds.width - truncationTokenWidth, y: 0)), length) - 1
      
        let range = NSRange(location: 0, length: max(0, showLength))
        let displayAttributedText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: range))
        displayAttributedText.append(truncationAttributedString)
        textLabel.attributedText = displayAttributedText
    }
}

// 自定义事件通知
 extension UIControl.Event {
     public  static let expandStateChanged = UIControl.Event(rawValue: 1 << 24)
}

//click
extension ExpandLabel {
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch  =  touches.first  {  
            let point : CGPoint = touch.location(in: self.textLabel)
            if point.y >=  0  &&  point.y <= self.bounds.size.height {
                // 切换展开状态
                isExpanded.toggle()
                if haveAnimate {
                    // 执行高度变化动画
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: { [self] in
                        reload()
                        self.layoutIfNeeded()
                    }, completion: nil)
                } else {
                    // 无动画时直接刷新
                    reload()
                }
                // 发送状态变化通知
                sendActions(for: .expandStateChanged)
            }
        }
    }
}

extension ExpandLabel {
    private   func  truncationToken(_ tonkenType : Bool) ->  NSAttributedString {
        let styles : [FoldableStyle] = tonkenType ? openToken : closeToken
        let attributedStrings : NSMutableAttributedString =  NSMutableAttributedString()
        for style in styles {
            attributedStrings.append(style.toAttributedString())
        }
        return attributedStrings
    }
    
}
/// ctLines array
extension ExpandLabel {
    private   func framelines(_ AttriString: NSAttributedString) -> [CTLine] {
        let framesetter = CTFramesetterCreateWithAttributedString(AttriString)
        let path = CGMutablePath(rect: CGRect(x: 0, y: 0, width: textLabel.bounds.width, height: .greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as? [CTLine] ?? []
        return lines
    }
}
