# ExpandLabel

An expandable/collapsible UILabel for iOS that supports text and images with no quantity limit. 
iOS 一个可展开/收起的UILabel，支持文字和图片，不限数量。
### 自定义展开，图文任意结合
![自定义展开，图文任意结合](1.png)

### 自定义收起，图文任意结合
![自定义收起，图文任意结合](2.png)

### 自定义展开/收起
![自定义展开/收起](3.png)
## 功能特点

- 📝 支持多行文本自动截断和展开/收起功能
- 🎨 自定义展开/收起按钮的样式，支持文字和图片
- 🎬 支持展开/收起动画效果
- 🔄 支持点击事件处理
- 📱 兼容iOS 13+和macOS 10.15+
- 🎯 简单易用的API接口

## 安装

### Swift Package Manager

在Xcode中，选择 `File > Add Packages...`，然后粘贴以下URL：

```
https://github.com/willlzq/ExpandLabel.git
```

点击 `Add Package` 按钮完成安装。

## 使用示例

### 基本用法

```swift
import UIKit
import ExpandLabel

class ViewController: UIViewController {
    // 创建ExpandLabel实例
    private lazy var expandLabel: ExpandLabel = {
        let view = ExpandLabel()
        
        // 基本配置
        view.maxnumberOfLines = 3
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 0.5
        
        // 设置文本内容
        let text = "Core Text是iOS 系统文本排版核心框架，TextKit和WebKit都是封装在CoreText上的，TextKit是iOS7引入的，在iOS7之前几乎所有的文本都是 WebKit 来处理的，包括UILable、UITextFileld等，TextKit是从Cocoa文本系统移植到iOS系统的。文本渲染过程中Core Text只负责排版，具体的绘制操作是通过Core Graphics框架完成的。如果需要精细的排版控制可以使用Core Text，否则可以直接使用Text Kit。"
        
        let attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.gray
        ])
        view.attributedText = attributedText
        
        // 设置展开和收起的样式
        view.openToken = [
            .text(title: " ... 展开 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)
        ]
        
        view.closeToken = [
            .text(title: " 收起 ", font: .boldSystemFont(ofSize: 15), foregroundColor: .blue)
        ]
        
        // 启用展开/收起动画效果
        view.haveAnimate = true
        // 可选：自定义动画持续时间（默认0.3秒）
        // view.animationDuration = 0.5
        
        // 应用设置
    view.reload()
    
    // 启用展开/收起动画
    view.haveAnimate = true
    // 可选：设置动画持续时间
    // view.animationDuration = 0.4
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加ExpandLabel到视图
        view.addSubview(expandLabel)
        
        // 设置约束
        expandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            expandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            expandLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            expandLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}
```

### 快速使用

库提供了便捷的初始化方法，可以快速创建配置好的ExpandLabel实例：

```swift
// 方法1：直接创建
let simpleLabel = ExpandLabel()
simpleLabel.maxnumberOfLines = 2
simpleLabel.attributedText = NSAttributedString(string: "这是一段可能会被截断的长文本内容，点击可以展开查看全部内容。")
simpleLabel.reload()

// 添加状态变化事件监听器
simpleLabel.addTarget(self, action: #selector(expandStateChanged(_:)), for: .expandStateChanged)

// 定义事件处理方法
 @objc func expandStateChanged(_ sender: ExpandLabel) {
   
}
```

### 自定义展开/收起样式

支持自定义展开和收起按钮的样式，可以是文字、图片或两者的组合：

```swift
// 纯文本样式
expandLabel.openToken = [
    .text(title: " [点击展开] ", font: .boldSystemFont(ofSize: 14), foregroundColor: .systemBlue)
]
expandLabel.closeToken = [
    .text(title: " [点击收起] ", font: .boldSystemFont(ofSize: 14), foregroundColor: .systemBlue)
]

// 如果项目中有可用的图片资源，也可以使用带图片的样式
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
```
## 关于内存释放
在Swift中使用Core Text等C API创建的对象（如framesetter，path，frame）不需要像Objective-C那样手动release。

Swift的自动引用计数(ARC)机制 ：
- Swift会自动为Core Foundation对象管理内存，当对象超出作用域时自动释放
- 编译器会在适当的时机插入内存管理代码

Core Foundation内存管理桥接 ：

- Swift为Core Foundation对象提供了自动内存管理桥接
- 大多数以 Create 、 Copy 等前缀创建的Core Foundation对象，在Swift中都会被自动管理

内存所有权转移 ：

- 在Swift与Core Foundation交互时，Swift编译器会理解并尊重Core Foundation的内存管理规则
- 当使用从Core Foundation创建的对象时，Swift会接管其内存管理

与Objective-C的区别 ：

- Objective-C中需要手动调用 CFRelease() 释放对象
- Swift通过编译器优化，自动处理了这些底层内存管理操作

## 注意事项

1. 务必在设置完所有属性后调用 `reload()` 方法，以应用设置。
2. 如果文本内容较短，未达到最大行数限制，则不会显示展开/收起按钮。
3. 在使用图片样式时，确保图片资源已正确添加到项目中。
4. 如需监听展开/收起事件，可以通过添加点击事件处理来实现。

## 参考：
- [Apple Developer Documentation - Core Text](https://developer.apple.com/documentation/coretext)
- [NSAttributedString - Apple Developer Documentation](https://developer.apple.com/documentation/foundation/nsattributedstring)
- [UIFont - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uifont)
- [UIColor - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uicolor)
- [iOS_UIFont的Attributes解析](https://cloud.tencent.com/developer/article/2052942)



## 许可证

本项目采用MIT许可证
