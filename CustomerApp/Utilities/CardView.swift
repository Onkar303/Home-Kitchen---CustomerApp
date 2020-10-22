//
//  CardView.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit

// Retrived from URL:https://www.youtube.com/watch?v=y-Tk7biMlOM&t=478s&ab_channel=MayankGupta


@IBDesignable class CardView:UIView{
    
    @IBInspectable var cornerRadius:CGFloat = CGFloat(Constants.CORNER_RADIUS)
    
    @IBInspectable var shadowOffSetWidth:CGFloat = 0
    
    @IBInspectable var shadowOffSetHeight:CGFloat = 5
    
    @IBInspectable var shadowColor:UIColor = UIColor.black
    
    @IBInspectable var shadowOpacity:CGFloat = 0.5
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize.zero
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        layer.backgroundColor = UIColor(named: "CustomColor")?.cgColor
    }
    
}
