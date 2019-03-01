//
//	RegisterRouter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

@objc protocol RegisterRoutingLogic {}

protocol RegisterDataPassing {
	var dataStore: RegisterDataStore? { get }
}

class RegisterRouter: NSObject, RegisterRoutingLogic, RegisterDataPassing {

	// MARK: - Properties

	weak var viewController: RegisterViewController?
	var dataStore: RegisterDataStore?
	
	// MARK: - Routing
	
}
