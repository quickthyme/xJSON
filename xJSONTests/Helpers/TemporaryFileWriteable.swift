
import Foundation
import XCTest

protocol TemporaryFileWriteable {
    func getTemporaryFileURL() -> URL
    func removeFile(_ url: URL)
}

extension TemporaryFileWriteable where Self: XCTestCase {
    func getTemporaryFileURL() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
    }

    func removeFile(_ url: URL) {
        let fm = FileManager.default
        guard fm.fileExists(atPath: url.path) else { return }
        do {
            try fm.removeItem(at: url)
            XCTAssertFalse(fm.fileExists(atPath: url.path))
        } catch {
            XCTFail("Error while deleting file: \(error)")
        }
    }
}
