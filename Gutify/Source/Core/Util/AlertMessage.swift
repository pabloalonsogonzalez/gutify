//
//  AlertMessage.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 14/9/24.
//

import Foundation
import SwiftUI

struct AlertMessage {

    typealias AlertAction = () -> Void

    var title: LocalizedStringKey
    var message: String
    var isShowing = true
    var actionText: LocalizedStringKey
    var action: AlertAction?
    var secondActionText: LocalizedStringKey?
    var secondAction: AlertAction?
}

extension AlertMessage {

    init(error: Error) {
        title = "AlertMessageErrorTitle"
        message = error.localizedDescription
        actionText = "AlertMessageOkButton"
    }

    init() {
        title = ""
        message = ""
        actionText = ""
        isShowing = false
    }
    
    init(retryAction: @escaping AlertAction, cancelAction: AlertAction?) {
        title = "AlertMessageErrorTitle"
        message = String(localized: "AlertMessageErrorMessage")
        actionText = "AlertMessageRetryButton"
        action = retryAction
        secondActionText = "AlertMessageCancelButton"
        secondAction = cancelAction
    }

}
