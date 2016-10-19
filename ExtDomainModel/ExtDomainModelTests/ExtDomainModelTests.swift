//
//  ExtDomainModelTests.swift
//  ExtDomainModelTests
//
//  Created by Matt Bond on 10/18/16.
//  Copyright © 2016 Matt Bond. All rights reserved.
//

import XCTest

import ExtDomainModel

class ExtDomainModelTests: XCTestCase {
    
    func testMoneyDescription() {
        let money = Money(amount: 12, currency: "EUR")
        print(money.description)
        XCTAssert(money.description == "EUR12.0")
    }
    
    func testAddMoney() {
        let money1 = Money(amount: 13, currency: "USD")
        let money2 = Money(amount: 11, currency: "USD")
        let sum = money1.add(other: money2)
        XCTAssert(sum.amount == 24)
    }
    
    func testSubtractMoney() {
        let money1 = Money(amount: 13, currency: "USD")
        let money2 = Money(amount: 11, currency: "USD")
        let difference = money1.subtract(other: money2)
        XCTAssert(difference.amount == 2)
    }
    
    func testDoubleExpression() {
        let test = Money.init(amount: 12, currency: "GBP")
        XCTAssert(test.description == "GBP12.0")
    }
}
