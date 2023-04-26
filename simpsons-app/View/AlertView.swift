//
//  AlertView.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import UIKit

protocol AlertView {
    func alert(error: Error)
}

extension AlertView {
    func alert(error: Error) {
        var title = "Error"
        var message = error.localizedDescription
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel)

        
        if let characterError = error as? appError {
            message = characterError.message
            title = characterError.title
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(cancelAction)
        
        UIApplication.getPresentedVC()?.present(alert, animated: true, completion: nil)
    }
}
