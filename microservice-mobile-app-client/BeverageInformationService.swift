//
//  PriceProvider.swift
//  beverage-maker-mobile-app
//
//  Created by Gerard de Jong on 2017/04/17.
//  Copyright © 2017 IQ Business. All rights reserved.
//

import Foundation

protocol BeverageInformationService {
    func getBeverageInformation(completion: @escaping (_ name: String?, _ description: String?, _ price: Double?, _ error: Error?) -> Void)
}
