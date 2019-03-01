//
//	LoginRouter.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

protocol LoginRoutingLogic {
    func routeToHome(segue: UIStoryboardSegue?)
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {
    
    // MARK: - Properties
    
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    // MARK: - Routing
    
    func routeToHome(segue: UIStoryboardSegue?) {
        if let _ = segue {} else {
            if let destinationVC = UIStoryboard(name: "TabBarStoryboard", bundle: nil).instantiateInitialViewController(),
                let viewController = viewController {
                navigateToHome(source: viewController, destination: destinationVC)
            }
        }
    }
    
    // MARK: - Navigation
    
    private func navigateToHome(source: UIViewController, destination: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = destination
    }
    
}
