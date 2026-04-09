//
//  PermissionsAuthenticatorProtocol.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

protocol PermissionsAuthenticatorProtocol {
    func requestAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void)
}
