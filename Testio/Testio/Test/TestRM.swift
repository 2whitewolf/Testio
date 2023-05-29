//
//  TestRM.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
import RealmSwift

class TestRM: Object {
    @Persisted (primaryKey: true) var id: UUID
    @Persisted var test: Test.RawValue
    @Persisted var opened: Bool
    @Persisted var passed: Bool
    
}


extension TestRM {
    func toMain() -> TestModel {
        let test = Test(rawValue: test)
        return TestModel(
            id: id,
            test: test ?? .GPS,
            opened: opened,
            passed: passed
        )
    }
}


extension TestModel {
    func toRealm() -> TestRM {
        return TestRM.build { object in
            object.id = id
            object.test = test.rawValue
            object.opened = opened
            object.passed = passed
        }
    }
}
