//
//  circleButton.swift
//  RealTimeCarSharing
//
//  Created by pop on 2/19/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

@IBDesignable
class circleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
   
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
