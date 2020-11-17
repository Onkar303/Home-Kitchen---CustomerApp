//
//  CustomTextField.swift
//  CustomerApp
//
//  Created by user173285 on 11/17/20.
//

import Foundation
import UIKit

@IBDesignable class CustomTextField:UITextField{
    @IBInspectable var borderWidth:CGFloat = 1
    
    @IBInspectable var borderColor:CGColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    @IBInspectable var cornerRadius:CGFloat = 10
    func transform(){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
}
}
