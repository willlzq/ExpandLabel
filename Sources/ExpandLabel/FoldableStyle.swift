//
//  File.swift
//  ExpandLabel
//
//  Created by files Share on 2025/10/13.
//

import UIKit
public enum FoldableStyle {
    case text(title:String,font: UIFont,foregroundColor:UIColor) //纯文本
    case image(icon:UIImage,size:CGSize,refrenceFont: UIFont = .boldSystemFont(ofSize: 15)) //图片
    func toAttributedString() -> NSAttributedString{
        switch self {
        case .text(title: let title , font: let font , foregroundColor: let foregroundColor):
        return NSAttributedString(
                string: title,
                attributes: [.foregroundColor: foregroundColor,.font : font ]
            )
        case .image(icon:  let image, size: let size,refrenceFont: let font):
                return  NSAttributedString(attachment: createCenteredImageAttachment(image: image, displaySize: size,refrenceFont: font))
        }
    }
}


/// 创建一个可以在行中居中显示的图片NSTextAttachment
/// - Parameters:
///   - image: 要显示的图片
///   - displaySize: 图片的显示尺寸
///   - baselineOffsetRatio: 基线偏移比例，默认0.25表示居中
/// - Returns: 配置好的NSTextAttachment实例
private func createCenteredImageAttachment(
    image: UIImage,
    displaySize: CGSize,
    refrenceFont: UIFont = .boldSystemFont(ofSize: 15),
    baselineOffsetRatio: CGFloat = 0.25
) -> NSTextAttachment {
    // 创建自定义的NSTextAttachment子类
    class _innerCenteredImageAttachment: NSTextAttachment {
        private let baselineOffsetRatio: CGFloat
        private let customDisplaySize: CGSize
        private let refrenceFont: UIFont

        init(image: UIImage, displaySize: CGSize, refrenceFont: UIFont, baselineOffsetRatio: CGFloat) {
            self.baselineOffsetRatio = baselineOffsetRatio
            self.customDisplaySize = displaySize
            self.refrenceFont = refrenceFont
            super.init(data: nil, ofType: nil)
            self.image = image
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // 重写attachmentBounds方法来实现图片居中
        override func attachmentBounds(for textContainer: NSTextContainer?,
                                    proposedLineFragment lineFrag: CGRect,
                                    glyphPosition position: CGPoint,
                                    characterIndex charIndex: Int) -> CGRect {
            // 获取文本的字体大小（特别是ascender值）
            let fontAscent: CGFloat = self.refrenceFont.ascender // 默认字体大小
            
            // 使用指定的显示尺寸
            let scaledWidth = customDisplaySize.width
            let scaledHeight = customDisplaySize.height
            
            // 计算垂直偏移量，使图片居中
            let yOffset = (fontAscent - scaledHeight) * baselineOffsetRatio
            
            // 返回调整后的bounds，包含垂直偏移
            return CGRect(x: 0, y: yOffset, width: scaledWidth, height: scaledHeight)
        }
    }
    
    // 创建并返回自定义的居中图片附件
    return _innerCenteredImageAttachment(
        image: image,
        displaySize: displaySize,
        refrenceFont: refrenceFont,
        baselineOffsetRatio: baselineOffsetRatio
    )
}
