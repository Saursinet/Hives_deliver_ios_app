//
//  ConcatTextField.swift
//  DeliverApp
//
//  Created by Florian Saurs on 03/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

open class ConcatTextField: UITextField {
    
    /// Constant part of the text. Defaults to "".
    @IBInspectable open var concatText: String {
        get {
            return _concatText
        }
        set {
            guard var text = text else {
                return
            }
            if !text.isEmpty {
                let typed = text[text.startIndex..<text.index(text.endIndex, offsetBy: -self.concatText.count)]
                text = typed + newValue
                
                prevText =  text
                _concatText = newValue
                
                textChanged(self)
            } else {
                _concatText = newValue
            }
            
            // Force update placeholder to get the new value of parkedText
            placeholder = placeholderText + concatText
        }
    }
    var _concatText = ""
    
    /// Variable part of the text. Defaults to "".
    @IBInspectable open var typedText: String {
        get {
            guard let text = text else {
                return ""
            }
            if text.hasSuffix(concatText) {
                return String(text[text.startIndex..<text.index(text.endIndex, offsetBy: -concatText.count)])
            } else {
                return text
            }
        }
        set {
            text = newValue + concatText
            textChanged(self)
        }
    }
    
    /// Placeholder before parkedText. Defaults to "".
    @IBInspectable open var placeholderText: String = "" {
        didSet {
            placeholder = placeholderText + concatText
        }
    }
    
    
    /// Constant part of the text. Defaults to the text field's font.
    @objc open var concatTextFont: UIFont! {
        didSet {
            concatText += ""
        }
    }
    
    /// Constant part of the text. Defaults to the text field's textColor.
    @IBInspectable open var concatTextColor: UIColor! {
        didSet {
            concatText += ""
        }
    }
    
    /// Attributes wrapper for font and color of parkedText
    var concatTextAttributes: [NSAttributedStringKey: NSObject] {
        return [
            NSAttributedStringKey.font: concatTextFont,
            NSAttributedStringKey.foregroundColor: concatTextColor ?? textColor!
        ]
    }
    
    open override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                let attributedString = NSMutableAttributedString(string: placeholder)
                let parkedTextRange = NSMakeRange(placeholderText.count, concatText.count)
                if placeholder.hasSuffix(concatText) {
                    attributedString.addAttributes(concatTextAttributes, range: parkedTextRange)
                    attributedPlaceholder = attributedString
                }
            }
        }
    }
    
    enum TypingState {
        case start, typed
    }
    var typingState = TypingState.start
    
    var beginningOfParkedText: UITextPosition? {
        get {
            return position(from: endOfDocument, offset: -concatText.count)
        }
    }
    
    var prevText = ""
    
    
    // MARK: Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
//        if let boldFont = font {
//            concatTextFont = bold(boldFont)
//        } else {
            concatTextFont = font
//        }
        
        concatTextColor = UIColor(red: 199, green: 199, blue: 205, alpha: 1)
        
        addTarget(self, action: #selector(ConcatTextField.textChanged(_:)), for: .editingChanged)
        
        text = ""
        prevText = text!
        
        typingState = .start
    }
    
    
    // MARK: EditingChanged handler
    
    @objc func textChanged(_ sender: UITextField) {
        switch typingState {
        case .start where text!.count > 0:
            text = typedText + concatText
            updateAttributedTextWith(text!)
            prevText = text!
            goToBeginningOfParkedText()
            
            typingState = .typed
            
        case .typed:
            if text == concatText {
                typingState = .start
                text = ""
                return
            }
            
            // If the parkedText has changed, don't update prevText.
            if text!.hasSuffix(concatText) {
                prevText = text!
            }
            updateAttributedTextWith(prevText)
            goToBeginningOfParkedText()
            
        default:
            break
            
        }
    }
    
    // MARK: Utilites
    func updateAttributedTextWith(_ text: String) {
        if let parkedTextRange = text.range(of: concatText, options: NSString.CompareOptions.backwards, range: nil, locale: nil) {
            let nsRange = text.nsRange(from: parkedTextRange)
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(concatTextAttributes, range: nsRange)
            
            attributedText = attributedString
        }
    }
    
    func goToBeginningOfParkedText() {
        if let position = beginningOfParkedText {
            goToTextPosition(position)
        }
    }
    
    func goToTextPosition(_ textPosition: UITextPosition!) {
        selectedTextRange = textRange(from: textPosition, to: textPosition)
    }
    
    func bold(_ font: UIFont) -> UIFont {
        let descriptor = font.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits.traitBold)
        return UIFont(descriptor: descriptor!, size: 0)
    }
}

// https://stackoverflow.com/a/30404532/805882
fileprivate extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) else {
                return NSRange(location: NSNotFound, length: 0)
        }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
}
