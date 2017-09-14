
import XCTest

class xJSON_Tests: XCTestCase, TemporaryFileWriteable {

    func test_can_get_serialized_data() {
        let data = xJSON.data(from: ["occupation":"retired", "number":11])
        XCTAssertNotNil(data)

        let verify = xJSON.parse(data: data!) as? [AnyHashable:Any]
        XCTAssertNotNil(verify)
        XCTAssertEqual((verify!["occupation"] as! String), "retired")
        XCTAssertEqual((verify!["number"] as! Int), 11)
    }

    func test_can_parse_file_from_dictionary() {
        let file = Bundle(for: type(of: self)).path(forResource:"test-dictionary", ofType: "json")
        let dict = xJSON.parse(file: file) as? [AnyHashable:Any]
        XCTAssertNotNil(dict)
        XCTAssertEqual (dict!["name"] as? String, "Devon")
        XCTAssertEqual (dict!["important"] as? Bool, false)
    }

    func test_can_parse_file_conforming_to_array_from_dictionary_array() {
        let file = Bundle(for: type(of: self)).path(forResource:"test-dictionary-array", ofType: "json")
        let arr = xJSON.parseArray(file: file) as? [[AnyHashable:Any]]
        XCTAssertNotNil(arr)
        XCTAssertEqual (arr!.count, 2)
        XCTAssertTrue  (arr![0]["important"] as! Bool)
        XCTAssertFalse (arr![1]["important"] as! Bool)
    }
    
    func test_can_parse_file_conforming_to_array_from_dictionary() {
        let file = Bundle(for: type(of: self)).path(forResource:"test-dictionary", ofType: "json")
        let arr = xJSON.parseArray(file: file) as? [[AnyHashable:Any]]
        XCTAssertNotNil(arr)
        XCTAssertEqual (arr![0]["name"] as? String, "Devon")
        XCTAssertEqual (arr![0]["important"] as? Bool, false)
    }

    func test_can_parse_file_conforming_to_array_from_array() {
        let file = Bundle(for: type(of: self)).path(forResource:"test-array", ofType: "json")
        let arr = xJSON.parseArray(file: file) as? [String]
        XCTAssertNotNil(arr)
        XCTAssertEqual (arr!.count, 6)
        XCTAssertEqual (arr![0], "Boober")
        XCTAssertEqual (arr![2], "Gobo")
        XCTAssertEqual (arr![5], "Wembly")
    }

    func test_when_conforming_to_array_malformed_input_returns_nil() {
        let data = "Hi-ho, hi-ho, this ought not work, hi-ho!".data(using: .utf8)!
        let arr = xJSON.parseArray(data: data)
        XCTAssertNil(arr)
    }

    func test_attempt_to_read_from_nonexistent_file_returns_nil() {
        let file = "nonexistent.json"
        let arr = xJSON.parseArray(file: file)
        XCTAssertNil(arr)
    }

    func test_attempt_to_output_data_from_invalid_source_results_nil() {
        struct Junk { let flotsam = 1 }
        let json = xJSON.data(from: Junk())
        XCTAssertNil(json)
    }

    func test_write_to_file_from_array_returns_true() {
        let array = [1, 2, 3, 4]
        let file = getTemporaryFileURL()
        XCTAssertTrue(xJSON.write(array, toFile: file.path))
        removeFile(file)
    }

    func test_write_to_file_from_dictonary_returns_true() {
        let dictionary = ["A":1, "B":2, "C":3, "D":4]
        let file = getTemporaryFileURL()
        XCTAssertTrue(xJSON.write(dictionary, toFile: file.path))
        removeFile(file)
    }

    func test_write_to_file_from_array_of_dictionaries_returns_true() {
        let dictionaryArray = [["E":5, "F":6], ["G":7, "H":8]]
        let file = getTemporaryFileURL()
        XCTAssertTrue(xJSON.write(dictionaryArray, toFile: file.path))
        removeFile(file)
    }

    func test_write_to_file_from_invalid_object_returns_false() {
        struct Pickle { let brine = true }
        let file = getTemporaryFileURL()
        XCTAssertFalse(xJSON.write(Pickle(), toFile: file.path))
        removeFile(file)
    }

    func test_write_to_file_with_invalid_path_returns_false() {
        let array = [77, 88, 99]
        let file = URL(fileURLWithPath: "/dev/Massachusetts/Canada")
        XCTAssertFalse(xJSON.write(array, toFile: file.path))
        removeFile(file)
    }
}
