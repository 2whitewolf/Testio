//
//  Realm + Extension.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
import RealmSwift


extension Object {
  static func build<O: Object>(_ builder: (_ object: O) -> () ) -> O {
    let object = O()
    builder(object)
    return object
  }
}
