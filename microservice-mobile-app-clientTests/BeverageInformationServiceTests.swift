//
//  beverage_maker_mobile_appTests.swift
//  beverage-maker-mobile-appTests
//
//  Created by Gerard de Jong on 2017/04/12.
//  Copyright © 2017 IQ Business. All rights reserved.
//

import XCTest
@testable import microservice_mobile_app_client

class BeverageInformationServiceTests: XCTestCase {
    
    var service: BeverageInformationService?
    
    override func setUp() {
        super.setUp()
        //service = MockedBeverageInformationService()
        service = NetworkBeverageInformationService(endPoint: "http://localhost/~gerarddejong/beverage-maker/coffee.json")
        //service = NetworkBeverageInformationService(endPoint: "http://45.32.233.9:9191/api/beverage?type=tea")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPriceProvider() {
        let priceProviderExpectation = expectation(description: "ServiceExpectation")

        service!.getBeverageInformation() { name, description, price, error in
            XCTAssert(error == nil)
            
            XCTAssert(name != nil, "Name: \(name!)")
            XCTAssert(description != nil, "Description: \(description!)")
            XCTAssert(price != nil, "Price: \(price!)")
            
            priceProviderExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("Error: \(error)")
            }
        }
    }
}
