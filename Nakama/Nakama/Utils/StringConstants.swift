//
//  StringConstants.swift
//  Nakama
//
//  Created by Yew Joon Wong on 26/08/2022.
//

import Foundation

struct StringConstants {
    
    struct General {
        static let btnNext = "BTN_NEXT"
        static let btnOk = "BTN_OK"
        static let btnLater = "BTN_LATER"
        static let btnDelete = "BTN_DELETE"
        static let btnContinue = "BTN_CONTINUE"
        static let btnCancel = "BTN_CANCEL"
    }
    
    struct Error {
        static let titleGeneral = "ERROR_TITLE_GENERAL"
        static let msgGeneral = "ERROR_MESSAGE_GENERAL"
    }
    
    struct Registration {
        static let lblStep1Title = "REGISTER_LBL_STEP1_TITLE"
        static let lblStep1Desc = "REGISTER_LBL_STEP1_DESC"
        static let lblStep2Title = "REGISTER_LBL_STEP2_TITLE"
        static let lblStep2Desc = "REGISTER_LBL_STEP2_DESC"
        static let lblStep3Title = "REGISTER_LBL_STEP3_TITLE"
        static let lblStep3Desc = "REGISTER_LBL_STEP3_DESC"
        static let lblInvalidEmailError = "LOGIN_LBL_EMAIL_INVALID_ERROR"
        static let lblInvalidPasswordError = "LOGIN_LBL_PASSWORD_INVALID_ERROR"
        static let lblPasswordMismatchError = "LOGIN_LBL_PASSWORD_MISMATCH_ERROR"
        static let txtPlaceholderUsername = "REGISTER_TXT_PLACEHOLDER_USERNAME"
        static let txtPlaceholderEmail = "REGISTER_TXT_PLACEHOLDER_EMAIL"
        static let txtPlaceholderPassword = "REGISTER_TXT_PLACEHOLDER_PASSWORD"
        static let txtPlaceholderConfirmPassword = "REGISTER_TXT_PLACEHOLDER_CONFIRM_PASSWORD"
        static let btnFinish = "REGISTER_BTN_FINISH"
    }
    
    struct Profile {
        static let lblPostsHeader = "PROFILE_LBL_POSTS_HEADER"
        static let alertDeletePostTitle = "PROFILE_ALERT_DELETE_POST_TITLE"
        static let alertDeletePostMsg = "PROFILE_ALERT_DELETE_POST_MESSAGE"
        static let alertDeletePostSuccessTitle = "PROFILE_ALERT_DELETE_POST_SUCCESS_TITLE"
        static let alertDeletePostSuccessMsg = "PROFILE_ALERT_DELETE_POST_SUCCESS_MESSAGE"
        static let btnLogout = "PROFILE_BTN_SIGN_LOGOUT"
    }
    
    struct PostEditor {
        static let txtPlaceholder = "EDITOR_TXT_PLACEHOLDER"
    }
}
