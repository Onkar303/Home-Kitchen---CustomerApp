//
//  ResponseDelegate.swift
//  CustomerApp
//
//  Created by user173285 on 11/17/20.
//

import Foundation


protocol ResponseDelegate:AnyObject {
    
    func onUpdateResponse(status:Bool,updateField:String?)
    
}
