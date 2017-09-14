//
// JSLocal
//
// An example interface for local JSON conversion.
// Entities implement this to support serialization.
// 
// You can define any number of these to allow entities
// to support a variety of input/output formats.
//

import Foundation

protocol JSLocal {
    init (fromLocal: Any)
    func toLocal() -> Any
}
