//
//	LoginRouter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

@objc protocol LoginRoutingLogic {}

protocol LoginDataPassing {
	var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {

	// MARK: - Properties

	weak var viewController: LoginViewController?
	var dataStore: LoginDataStore?
	
	// MARK: - Routing
	
}
