//
//  PermissionFactoryContract.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation
import SwiftUI

enum AuthorizationStatus {
    case authorized
    case denied
    case notDetermined
}

protocol PermissionTypeContract {
    func requestPermission(completionHandler: @escaping (_ authorizationStatus: AuthorizationStatus) -> Void)
    func checkAuthorizationStatus(completionHandler: @escaping (_ authorizationStatus: AuthorizationStatus) -> Void)
}

extension PermissionTypeContract {
    func settingsURL() -> String {
        return UIApplication.openSettingsURLString
    }
}
