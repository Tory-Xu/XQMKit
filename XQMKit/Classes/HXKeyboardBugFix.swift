//
//  HXKeyboardBugFix.swift
//  ShadowTest
//
//  Created by Tory on 2020/12/8.
//

import UIKit

@objc class HXKeyboardBugFix: NSObject {
    
    static let share = HXKeyboardBugFix()
    
    private static let keyboardLevel: CGFloat = 10000001
    
    private var isFixFirstResponseLongPressBug = false
    
    @objc func enableFixFirstResponseLongPressBug() {
        if isFixFirstResponseLongPressBug {
            return
        }
        
        isFixFirstResponseLongPressBug = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrameNoti(noti:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func disableFixFirstResponseLongPressBug() {
        if isFixFirstResponseLongPressBug {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func keyboardWillChangeFrameNoti(noti: NSNotification) {
        let keyboardWindow = UIApplication.shared.windows.first { (window) -> Bool in
            if window.windowLevel.rawValue == HXKeyboardBugFix.keyboardLevel {
                return true
            }
            return false
        }
        guard let keyboard = keyboardWindow else {
            return
        }
        
        let keyWindow = UIApplication.shared.windows.first { (window) -> Bool in
            return window.isKeyWindow
        }
        
        let inputText = keyWindow?.perform(Selector(("firstResponder")))?.takeUnretainedValue() as? UITextInput
        var inputAccessoryView: UIView?
        if let textField = inputText as? UITextField {
            inputAccessoryView = textField.inputAccessoryView
        } else if let textView = inputText as? UITextView {
            inputAccessoryView = textView.inputAccessoryView
        }

        let beginFrame = (noti.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if beginFrame.minY == UIScreen.main.bounds.height { // 显示
            if endFrame.height < 200 || beginFrame.minY != endFrame.minY + endFrame.height { // 只显示部分键盘 -- 长按输入框时
                keyboard.layer.opacity = 0
                inputAccessoryView?.isHidden = true
            }
        } else {
            keyboard.layer.opacity = 1
            inputAccessoryView?.isHidden = false
        }
    }
}
