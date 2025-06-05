//
//  UIColor.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 5/6/2025.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat,   green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1 )
    }
    
    static func mainColor() -> UIColor {
        return UIColor.rgb(red: 221, green: 94, blue: 86)
    }
}
