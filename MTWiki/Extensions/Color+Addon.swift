//
//  Color+Addon.swift
//  MTWiki
//
//  Created by Rahul Sharma on 23/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import Foundation

extension UIColor {
        static func superDarkBlueColor() -> UIColor{
            return UIColor.init(red: 0.0/255.0, green: 37.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }

        static func darkBlueColor() -> UIColor{
            return UIColor.init(red: 25.0/255.0, green: 121.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        }

        static func lightBlueColor() -> UIColor{
            return UIColor.init(red: 45.0/255.0, green: 172.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        }


        static func primaryColor() -> UIColor{
            return UIColor.white
        }

        static func secondaryColor() -> UIColor{
            return UIColor.blue

        }
}
