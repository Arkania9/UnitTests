//
//	RegisterWorker.swift
//	CompanyManagerUnitTests
//
//	Created by Kamil on 01/03/2019.
//	Copyright (c) 2019 Kamil Zając. All rights reserved.
//

import UIKit
import Unicorns

class RegisterWorker {
    
    struct RegisterReqeust {
        let firstName: String
        let lastName: String
        let email: String
        let password: String
        let confirmPassword: String
        let referalCode: String?
    }
    
    func register(request: RegisterReqeust, onSuccess: @escaping (Token) -> Void, onError: @escaping (AppError) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.appFullDateFormatter)
        BackendManager.RegisterRequest(firstName: request.firstName,
                                       lastName: request.lastName,
                                       email: request.email,
                                       password: request.password,
                                       confirmPassword: request.confirmPassword,
                                       referalCode: request.referalCode).execute(with: decoder,
                                                                                 onSuccess: { token in
                                                                                    onSuccess(token)
                                       }, onError: { error in
                                        onError(AppError(error: error))
                                       })
    }
    
}
