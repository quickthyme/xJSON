
import XCTest

class CompanionTests: XCTestCase, TemporaryFileWriteable {

    func test_create_companion_from_dictionary() {
        let dictionary: [String:Any] = [
            "name":"Mintaka",
            "age":2,
            "type": "feline",
            "important": true,
            "available": true
        ]
        let companion = Companion(fromLocal: dictionary)
        XCTAssertEqual (companion.name, "Mintaka")
        XCTAssertEqual (companion.age, 2)
        XCTAssertEqual (companion.species, .cat)
        XCTAssertTrue  (companion.isFavorite)
        XCTAssertTrue  (companion.isAvailable)
    }

    func test_create_dictionary_from_companion() {
        let companion = Companion(
            name: "Meissa",
            age: 1,
            species: .cat,
            isFavorite: true,
            isAvailable: true
        )
        let output = companion.toLocal() as! [String:Any]
        XCTAssertEqual (output["name"] as! String, "Meissa")
        XCTAssertEqual (output["age"] as! Int, 1)
        XCTAssertEqual (output["type"] as! String, "feline")
        XCTAssertTrue  (output["important"] as! Bool)
        XCTAssertTrue  (output["available"] as! Bool)
    }

    func test_create_companion_from_file() {
        let file = Bundle(for: type(of: self)).path(forResource:"test-dictionary", ofType: "json")
        let result = xJSON.parse(file: file)!
        let companion = Companion(fromLocal: result)
        XCTAssertEqual (companion.name, "Devon")
        XCTAssertEqual (companion.age, 31)
        XCTAssertEqual (companion.species, .human)
        XCTAssertFalse (companion.isFavorite)
        XCTAssertTrue  (companion.isAvailable)
    }

    func test_write_companion_to_file() {
        let companion = Companion(
            name: "Bilbo",
            age: 111,
            species: .other,
            isFavorite: true,
            isAvailable: true)
        
        let file = getTemporaryFileURL()
        XCTAssertTrue(xJSON.write(companion.toLocal(), toFile: file.path))

        // verify file
        let result = xJSON.parse(file: file.path)!
        let verify = Companion(fromLocal: result)
        XCTAssertEqual (verify.name, "Bilbo")
        XCTAssertEqual (verify.age, 111)
        XCTAssertEqual (verify.species, .other)
        XCTAssertTrue  (verify.isFavorite)
        XCTAssertTrue  (verify.isAvailable)
        removeFile(file)
    }

    func test_create_companion_list_from_local_file() {
        let file = Bundle(for: type(of: self)).path(forResource:"test-dictionary-array", ofType: "json")
        let result = xJSON.parse(file: file) as? [Any] ?? []
        let companions: [Companion] = result.map { Companion(fromLocal: $0) }
        XCTAssertEqual (companions.count, 2)
        XCTAssertEqual (companions[0].name, "Tabitha")
        XCTAssertEqual (companions[1].name, "Muffin")
    }

    func test_write_companion_list_to_file() {
        let companions = [
            Companion(
                name: "Frodo",
                age: 33,
                species: .other,
                isFavorite: true,
                isAvailable: false),
            Companion(
                name: "Sam",
                age: 45,
                species: .other,
                isFavorite: true,
                isAvailable: false),
        ]

        let file = getTemporaryFileURL()
        let list: [Any] = companions.map { $0.toLocal() }
        XCTAssertTrue(xJSON.write(list, toFile: file.path))

        // verify file
        let result = xJSON.parse(file: file.path) as? [Any] ?? []
        let verify: [Companion] = result.map { Companion(fromLocal: $0) }
        XCTAssertEqual (verify.count, 2)
        XCTAssertEqual (verify[0].name, "Frodo")
        XCTAssertEqual (verify[1].name, "Sam")
        removeFile(file)
    }
}
