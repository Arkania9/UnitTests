//
//  UIViewExtensions.swift
//  CompanyManagerUnitTests
//
//  Created by Kamil on 01/03/2019.
//  Copyright © 2019 Kamil Zając. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupShadowedCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.shadowColor = UIColor(red: 69/255, green: 91/255, blue: 99/255, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.08
    }
    
}

