//
// Companion
//
// An example entity
//

import Foundation

struct Companion {
    var name: String
    var age: Int
    var species: Species
    var isFavorite: Bool
    var isAvailable: Bool

    enum Species: String {
        case human, cat, dog, horse, other
    }
}
