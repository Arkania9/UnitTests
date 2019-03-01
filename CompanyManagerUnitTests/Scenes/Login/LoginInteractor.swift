//
//	LoginInteractor.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

protocol LoginBusinessLogic {}

protocol LoginDataStore {}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {

	// MARK: - Properties

	var presenter: LoginPresentationLogic?
	var worker: LoginWorker?
	
	// MARK: - Business Logic
	
}
