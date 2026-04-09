//
//  PermissionsAutheticator.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

enum PermissionsAutheticator: PermissionsAuthenticatorProtocol {
    case locationPermission
    
    private var permissionType: PermissionTypeContract {
        switch self {
        case .locationPermission:
            return LocationPermission()
        }
    }
    
    func requestAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void) {
        permissionType.checkAuthorizationStatus { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                completion(.authorized)
            case .denied:
                completion(.denied)
            case .notDetermined:
                requestPermission(completion: completion)
            }
        }
    }
    
    private func requestPermission(completion: @escaping (AuthorizationStatus) -> Void) {
         permissionType.requestPermission { authorizationStatus in
             completion(authorizationStatus)
         }
     }
}
