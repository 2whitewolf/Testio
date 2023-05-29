//
//  TestModel.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
struct TestModel {
    var id: UUID
    var test: Test
    var opened: Bool
    var passed: Bool
}


extension TestModel: Equatable{
    static func == (lhs: TestModel, rhs: TestModel) -> Bool {
      if let statusLHS = lhs as? TestModel,
         let statusRHS = rhs as? TestModel {
       
          return statusLHS.id == statusRHS.id
          
      }
        
        return false
    }
}
