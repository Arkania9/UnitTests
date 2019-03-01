//
//	ForgotPasswordWorker.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit

class ForgotPasswordWorker {
    
    struct SendRequest {
        let email: String
    }
    
    func send(request: SendRequest, onSuccess: @escaping () -> Void, onError: @escaping (AppError) -> Void) {
        BackendManager.ForgotPasswordRequest(email: request.email).execute(onSuccess: { _ in
            onSuccess()
        }, onError: { error in
            onError(AppError(error: error))
        })
    }
    
}
