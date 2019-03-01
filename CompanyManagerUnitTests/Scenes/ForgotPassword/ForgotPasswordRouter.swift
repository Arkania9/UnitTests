//
//	ForgotPasswordRouter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

@objc protocol ForgotPasswordRoutingLogic {}

protocol ForgotPasswordDataPassing {
    var dataStore: ForgotPasswordDataStore? { get }
}

class ForgotPasswordRouter: NSObject, ForgotPasswordRoutingLogic, ForgotPasswordDataPassing {
    
    // MARK: - Properties
    
    weak var viewController: ForgotPasswordViewController?
    var dataStore: ForgotPasswordDataStore?
    
    // MARK: - Routing
    
}
