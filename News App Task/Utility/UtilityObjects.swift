//
//  UtilityObjects.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import UIKit

class UtilityObject {
    
    static  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let managedContext = appDelegate.persistentContainer.viewContext
    
}
