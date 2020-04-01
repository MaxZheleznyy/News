//
//  UserDefaultsExtension.swift
//  News
//
//  Created by Maxim Zheleznyy on 4/1/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case countryToUse
}

extension UserDefaults {
    
    func setCountry(id: String) {
        set(id, forKey: UserDefaultsKeys.countryToUse.rawValue)
        //synchronize()
    }

    func getCountry() -> String {
        return string(forKey: UserDefaultsKeys.countryToUse.rawValue) ?? "us"
    }
}
