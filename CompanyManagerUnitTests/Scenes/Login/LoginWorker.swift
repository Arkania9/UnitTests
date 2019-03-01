//
//	LoginWorker.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

class LoginWorker {
    
    struct LoginRequest {
        let email: String
        let password: String
    }
    
    func login(request: LoginRequest, onSuccess: @escaping (Token) -> Void, onError: @escaping (AppError) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.appFullDateFormatter)
        BackendManager.LoginRequest(email: request.email, password: request.password).execute(with: decoder,
                                                                                              onSuccess: { token in
                                                                                                onSuccess(token)
        }, onError: { error in
            onError(AppError(error: error))
        })
    }
    
}

