//
//  UIApplication.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import UIKit

extension UIApplication {
    class func getPresentedVC() -> UIViewController? {
        let presentedVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        return presentedVC?.rootViewController
    }
}

