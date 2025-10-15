import XCTest
import UIKit
@testable import ExpandLabel

final class ExpandLabelTests: XCTestCase {
    func testExample() throws {
        // 这里添加ExpandLabel的基本使用示例
        let label = ExpandLabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        
        // 设置最大行数
        label.maxnumberOfLines = 3
        
        // 设置背景色和边框
        label.backgroundColor = .clear
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.orange.cgColor
        label.layer.borderWidth = 0.5
        
        // 设置文本内容
        let testText = "Core Text是iOS 系统文本排版核心框架，TextKit和WebKit都是封装在CoreText上的，TextKit是iOS7引入的，在iOS7之前几乎所有的文本都是 WebKit 来处理的，包括UILable、UITextFileld等，TextKit是从Cocoa文本系统移植到iOS系统的。文本渲染过程中Core Text只负责排版，具体的绘制操作是通过Core Graphics框架完成的。如果需要精细的排版控制可以使用Core Text，否则可以直接使用Text Kit。"
        
        let attributedText = NSAttributedString(string: testText, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.gray
        ])
        label.attributedText = attributedText
        
        // 设置展开和收起的样式
        label.openToken = [
            .text(title: " ... 展开 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)
        ]
        
        label.closeToken = [
            .text(title: " 收起 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)
        ]
        
        // 调用reload来应用设置
        label.reload()
        
     
    }
    
    // 快速使用示例：几行代码即可集成
    func testQuickUsageExample() throws {
        // 方法1：直接创建
        let simpleLabel = ExpandLabel()
        simpleLabel.maxnumberOfLines = 2
        simpleLabel.attributedText = NSAttributedString(string: "这是一段可能会被截断的长文本内容，点击可以展开查看全部内容。")
        simpleLabel.reload()
        
        // 方法2：使用便捷构造器（我在扩展中提供的）
        let quickLabel = ExpandLabel.create(
            text: "这是使用便捷构造器创建的可展开文本示例，配置更加简洁。",
            maxLines: 3
        )
        
        // 方法3：自定义样式
        let customLabel = ExpandLabel.create(
            text: "这是自定义样式的可展开文本，包括自定义颜色和字体。",
            font: .systemFont(ofSize: 16),
            textColor: .darkGray,
            maxLines: 2
        )
        
        // 额外自定义展开/收起样式
        customLabel.openToken = [
            .text(title: " [点击展开] ", font: .boldSystemFont(ofSize: 14), foregroundColor: .systemBlue)
        ]
        customLabel.closeToken = [
            .text(title: " [点击收起] ", font: .boldSystemFont(ofSize: 14), foregroundColor: .systemBlue)
        ]
        customLabel.reload()
    }
    
    // 演示如何使用状态变化事件通知
    func testExpandStateChangedNotification() throws {
        // 创建ExpandLabel实例
        let label = ExpandLabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        label.maxnumberOfLines = 2
        
        // 设置足够长的文本内容，确保会显示展开/收起按钮
        let longText = "这是一段很长的文本内容，用于测试ExpandLabel的展开和收起功能。当文本内容超过设置的最大行数时，会显示展开按钮；点击后文本会完全展开，并显示收起按钮。"
        label.attributedText = NSAttributedString(string: longText)
        
        // 应用设置
        label.reload()
        
        // 用于存储状态变化的标志
        var stateChangedFlag = false
        var currentState = false
        
        // 添加状态变化事件监听器
        label.addTarget(self, action: #selector(expandStateChanged(_:)), for: .expandStateChanged)
    }
    // 定义事件处理方法
    @objc func expandStateChanged(_ sender: ExpandLabel) {

    }
}

// 以下是一个更完整的使用示例，可以放在实际项目中直接使用
// 这个示例演示了如何在UIViewController中使用ExpandLabel
class ExpandLabelExampleViewController: UIViewController {
    // 创建ExpandLabel实例
    private lazy var expandLabel: ExpandLabel = {
        let view = ExpandLabel()
        
        // 基本配置
        view.maxnumberOfLines = 3
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 0.5
        
    
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景色
        view.backgroundColor = .white
        
        // 添加ExpandLabel到视图
        view.addSubview(expandLabel)
        
        // 设置约束
        setupConstraints()
        
        // 设置文本内容
        setupTextContent()
        
        // 设置展开/收起样式
        setupExpandCollapseStyles()
        
        // 应用设置
        expandLabel.reload()
    }
    
    private func setupConstraints() {
        // 使用Auto Layout设置约束
        expandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            expandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            expandLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            expandLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupTextContent() {
        // 创建并设置富文本
        let text = "CTFramesetter是Core Text中最上层的类，CTFramesetter持有attributed string并创建CTTypesetter，实际排版由CTTypesetter完成。CTFrame类似于书本中的「页」，CTLine类似「行」，CTRun是一行中具有相同属性的连续字形。CTFrame、CTLine、CTRun都有对应的Draw方法绘制文本，其中CTRun支持最精细的控制。baseline：字符基线，baseline是虚拟的线，baseline让尽可能多的字形在baseline上面，CTFrameGetLineOrigins获取的Origins就是每一行第一个CTRun的Origin!"
        
        let attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray
        ])
        
        expandLabel.attributedText = attributedText
    }
    
    private func setupExpandCollapseStyles() {
        // 设置展开样式（纯文本）
        expandLabel.openToken = [
            .text(title: " ... 展开 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)
        ]
        
        // 设置收起样式（纯文本）
        expandLabel.closeToken = [
            .text(title: " 收起 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)
        ]
        
        /*
        // 如果项目中有可用的图片资源，也可以使用带图片的样式
        // 注意：需要确保图片资源存在于项目中
        if let expandImage = UIImage(named: "expand_icon"), 
           let collapseImage = UIImage(named: "collapse_icon") {
            
            expandLabel.openToken = [
                .text(title: " 展开 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue),
                .image(icon: expandImage, size: CGSize(width: 16, height: 16), refrenceFont: .boldSystemFont(ofSize: 15))
            ]
            
            expandLabel.closeToken = [
                .text(title: " 收起 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue),
                .image(icon: collapseImage, size: CGSize(width: 16, height: 16), refrenceFont: .boldSystemFont(ofSize: 15))
            ]
        }
        */
    }
 
    
    // 展开/收起状态变化事件处理
    @objc private func expandStateChanged(_ sender: ExpandLabel) {
        // 处理展开/收起状态变化
        let stateText = sender.isExpanded ? "已展开" : "已收起"
        print("文本\(stateText)")
        
        // 这里可以添加更多的业务逻辑，例如：
        // 1. 更新相关UI元素
        // 2. 记录用户行为
        // 3. 触发其他操作
    }
 
}

// 下面是一个更简洁的ExpandLabel扩展，提供便捷的初始化和配置方法
extension ExpandLabel {
    /// 创建一个配置好的ExpandLabel实例
    /// - Parameters:
    ///   - frame: 标签的frame
    ///   - text: 文本内容
    ///   - font: 字体
    ///   - textColor: 文本颜色
    ///   - maxLines: 最大显示行数
    /// - Returns: 配置好的ExpandLabel实例
    static func create(
        frame: CGRect = .zero,
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 15),
        textColor: UIColor = .darkGray,
        maxLines: Int = 3
    ) -> ExpandLabel {
        let label = ExpandLabel(frame: frame)
        
        // 基本配置
        label.maxnumberOfLines = maxLines
        label.backgroundColor = .clear
        
        // 设置文本
        if let text = text {
            label.attributedText = NSAttributedString(string: text, attributes: [
                .font: font,
                .foregroundColor: textColor
            ])
        }
        
        // 设置默认的展开/收起样式
        label.openToken = [
            .text(title: " ... 展开 ", font: .boldSystemFont(ofSize: font.pointSize), foregroundColor: .blue)
        ]
        
        label.closeToken = [
            .text(title: " 收起 ", font: .boldSystemFont(ofSize: font.pointSize), foregroundColor: .blue)
        ]
        
        // 应用设置
        label.reload()
        
        return label
    }
}
