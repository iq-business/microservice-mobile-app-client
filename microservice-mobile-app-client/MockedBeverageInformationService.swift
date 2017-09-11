//
//  MockedPriceProvider.swift
//  beverage-maker-mobile-app
//
//  Created by Gerard de Jong on 2017/04/17.
//  Copyright © 2017 IQ Business. All rights reserved.
//

import Foundation

class MockedBeverageInformationService : BeverageInformationService {
    func getBeverageInformation(completion: @escaping (_ name: String?, _ description: String?, _ price: Double?, _ error: Error?) -> Void) {
        usleep(500)
        completion("Mocked", "Mocked description.", Double(10 + arc4random_uniform(20)), nil)
    }
}
