//
//  main.swift
//  ExtDomainModel
//
//  Created by Matt Bond on 10/18/16.
//  Copyright © 2016 Matt Bond. All rights reserved.
//


import Foundation

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

protocol CustomStringConvertible {
    var description: String {
        get
    }
}

protocol Mathematics {
    func add(other: Money) -> Money
    func subtract(other: Money) -> Money
}

extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var CAN: Money {
        return Money(amount: Int(self), currency: "CAN")
    }
    var YEN: Money {
        return Money(amount: Int(self), currency: "YEN")
    }
}

func +(left: Money, right: Money) -> Money {
    return left.add(other: right)
}

func -(left: Money, right: Money) -> Money {
    return left.subtract(other: right)
}


struct Money: CustomStringConvertible, Mathematics {
    
    var amount : Int = 0
    var currency : String = ""
    var description: String
    
    init(amount : Int, currency : String) {
        self.amount = amount
        self.currency = currency
        self.description = "\(self.currency)\(self.amount).0"
    }
    
    func convert (_ toCurr : String) -> Money {
        if toCurr == "GBP" {
            if self.currency == "USD" {
                return Money(amount: self.amount / 2, currency : toCurr)
            } else if self.currency == "EUR" {
                return Money(amount: self.amount * 3, currency : toCurr)
            } else if self.currency == "CAN" {
                return Money(amount: self.amount * 5 / 2, currency : toCurr)
            } else if self.currency == "GBP" {
                return Money(amount: self.amount, currency : toCurr)
            }
        } else if toCurr == "EUR" {
            if self.currency == "USD" {
                return Money(amount: self.amount * 3 / 2, currency : toCurr)
            } else if self.currency == "GBP" {
                return Money(amount: self.amount / 3, currency : toCurr)
            } else if self.currency == "CAN" {
                return Money(amount: self.amount * 5 / 6, currency : toCurr)
            } else if self.currency == "EUR" {
                return Money(amount: self.amount, currency : toCurr)
            }
        } else if toCurr == "CAN" {
            if self.currency == "USD" {
                return Money(amount: self.amount * 5 / 4, currency : toCurr)
            } else if self.currency == "EUR" {
                return Money(amount: self.amount * 2 / 5, currency : toCurr)
            } else if self.currency == "GBP" {
                return Money(amount: self.amount * 6 / 5, currency : toCurr)
            } else if self.currency == "CAN" {
                return Money(amount: self.amount, currency : toCurr)
            }
        } else if toCurr == "USD"{
            if self.currency == "GBP" {
                return Money(amount: self.amount * 2, currency : toCurr)
            } else if self.currency == "EUR" {
                return Money(amount: self.amount * 2 / 3, currency: toCurr)
            } else if self.currency == "CAN" {
                return Money(amount: self.amount * 4 / 5, currency: toCurr)
            } else if self.currency == "USD" {
                return Money(amount: self.amount, currency: toCurr)
            }
        }
        return Money(amount: 0, currency: toCurr)
    }
    
    func add (other : Money) -> Money {
        let newSelf = self.convert(other.currency)
        return Money(amount: newSelf.amount + other.amount, currency: other.currency)
    }
    
    func subtract (other : Money) -> Money {
        let newSelf = self.convert(other.currency)
        return Money(amount: newSelf.amount - other.amount, currency: other.currency)
    }
}

class Job {
    var title: String
    var type: JobType
    var description: String
    
    enum JobType {
        case Salary(Int)
        case Hourly(Double)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
        self.description = "\(self.title), \(self.type)"
    }
    
    func calculateIncome (_ hours: Int) -> Int {
        switch type {
        case .Salary(let perYear):
            return perYear
        case .Hourly(let perHour):
            return Int(perHour) * hours
        }
    }
    
    func raise (_ amount: Double) {
        switch type {
        case .Salary(let perYear):
            self.type = .Salary(perYear + Int(amount))
        case .Hourly(let perHour):
            self.type = .Hourly(perHour + amount)
        }
    }
}

class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var description: String
    var job: Job? {
        set (newJob){
            if self.age > 15 {
                self.job = newJob
            }
        }
        get {
            return self.job
        }
    }
    var spouse: Person? {
        set (newSpouse){
            if self.age > 17 {
                self.spouse = newSpouse
            }
        }
        get {
            return self.spouse
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.description = "\(self.firstName) \(self.lastName), \(self.age)"
        if age < 16 {
            self.job = nil
        }
        if age < 18 {
            self.spouse = nil
        }
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title) spouse:\(spouse)]"
    }
}


class Family {
    var family: [Person] = []
    var description: String
    
    init(spouse1: Person, spouse2: Person) {
        family.append(spouse1)
        family.append(spouse2)
        if spouse1.age >= 21 || spouse2.age >= 20 {
            if spouse1.spouse == nil && spouse2.spouse == nil  {
                spouse1.spouse = spouse2
                spouse2.spouse = spouse1
            }
        }
        self.description = "\(spouse1.description), \(spouse2.description)"
    }
    
    func householdIncome () -> Int {
        var totalIncome: Int = 0;
        if family.count > 0 {
            for index in 0...family.count - 1 {
                let person = family[index]
                totalIncome += (person.job?.calculateIncome(1))!
            }
        }
        return totalIncome
    }
    
    func haveChild (_ child: Person) -> Bool {
        if (family.count > 2) {
            return false;
        } else {
            family.append(child)
            return true;
        }
    }
}


