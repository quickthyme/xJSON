//
// Companion+JSLocal
//
// Adds support to `Companion` for JSLocal serialization
//

import Foundation

extension Companion: JSLocal {
    init(fromLocal: Any) {
        let local = fromLocal as? [String:Any] ?? [:]
        self.name = local["name"] as? String ?? ""
        self.age  = local["age"]  as? Int ?? 0
        self.isFavorite = local["important"] as? Bool ?? false
        self.isAvailable = local["available"] as? Bool ?? false
        self.species = Species(fromLocal: local["type"] ?? "")
    }

    func toLocal() -> Any {
        return [
            "name" : name,
            "age"  : age,
            "important" : isFavorite,
            "available" : isAvailable,
            "type" : species.toLocal()
        ]
    }
}

extension Companion.Species: JSLocal {
    init(fromLocal: Any) {
        let local = fromLocal as? String ?? ""
        switch(local) {
        case "human": self = .human
        case "feline":  self = .cat
        case "canine":  self = .dog
        case "equine": self = .horse
        default: self = Companion.Species(rawValue: local) ?? .other
        }
    }

    func toLocal() -> Any {
        switch(self) {
        case .human: return "human"
        case .cat:   return "feline"
        case .dog:   return "canine"
        case .horse: return "equine"
        default: return "other"
        }
    }
}
