//
//  CMFloatLabelTextView.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import UIKit

@IBDesignable class CMFloatLabelTextView: FloatLabelTextView {
    
    // MARK: - Properties
    
    private var backgroundView: UIView?
    
    // MARK: - Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createBackgroundView()
        setup()
    }
    
    // MARK: - Functions
    
    internal override func setup() {
        contentInset = UIEdgeInsets(top: 6, left: 24, bottom: 6, right: 24)
        textContainerInset = .zero//UIEdgeInsets(top: 6, left: 24, bottom: 6, right: 24)
        textContainer.lineFragmentPadding = 0
        super.setup()
        backgroundColor = .clear
    }
    
    private func createBackgroundView() {
        guard let superview = superview else { return }
        backgroundView = UIView()
        superview.insertSubview(backgroundView!, belowSubview: self)
        backgroundView?.frame = frame
        backgroundView?.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: frame.origin.x).isActive = true
        backgroundView?.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: frame.maxX).isActive = true
        backgroundView?.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: frame.maxY).isActive = true
        backgroundView?.topAnchor.constraint(equalTo: superview.topAnchor, constant: frame.origin.y).isActive = true
        backgroundView?.setupShadowedCorner(radius: 12)
        layoutIfNeeded()
        backgroundView?.layer.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 251/255, alpha: 1.0).cgColor
    }
    
}
