//
//  UIViewControllerExtensions.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func setupTitle(with title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title.localized.uppercased()
        guard let titleText = titleLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: titleText)
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: CGFloat(1.25),
                                      range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor.gray
        navigationItem.titleView = titleLabel
    }
    
}
