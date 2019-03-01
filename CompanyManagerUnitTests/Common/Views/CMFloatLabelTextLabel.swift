//
//  CMFloatLabelTextLabel.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

@IBDesignable open class CMFloatLabelTextField: FloatTextField {
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 52)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return superRect.insetBy(dx: contentInsets.left, dy: 0)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return superRect.insetBy(dx: contentInsets.left, dy: 0)
    }
    
    override open func setup() {
        contentInsets = UIEdgeInsets(top: 2, left: 24, bottom: 2, right: 24)
        super.setup()
        setupShadowedCorner(radius: 12)
        layer.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 251/255, alpha: 1.0).cgColor
    }
    
}

