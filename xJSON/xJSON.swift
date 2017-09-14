
import Foundation

internal class xJSON {

    typealias ReadingOptions = JSONSerialization.ReadingOptions
    typealias WritingOptions = JSONSerialization.WritingOptions

    static let defaultReadingOptions: ReadingOptions = [.mutableContainers, .mutableLeaves, .allowFragments]
    static let defaultWritingOptions: WritingOptions = []
    static let defaultFileWritingOptions: WritingOptions = [.prettyPrinted]
}

// MARK: - Standard Operation
extension xJSON {
    static func parse(data:Data, options: ReadingOptions? = nil) -> Any? {
        let options : ReadingOptions = options ?? defaultReadingOptions
        return (try? JSONSerialization.jsonObject(with: data, options: options))
    }

    static func parse(file:String?) -> Any? {
        guard let file = file, let data = self.read(file: file) else { return nil }
        return self.parse(data: data)
    }

    static func data(from object: Any, options: WritingOptions? = nil) -> Data? {
        guard (JSONSerialization.isValidJSONObject(object)) else { return nil }
        return try? JSONSerialization.data(withJSONObject: object,
                                           options: options ?? defaultWritingOptions)
    }

    @discardableResult
    static func write(_ object:Any, toFile file:String, options: WritingOptions? = nil) -> Bool {
        guard let data = data(from: object, options: options ?? defaultFileWritingOptions)
            else { return false }
        let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        do { try str?.write(toFile: file, atomically: true, encoding: String.Encoding.utf8.rawValue) }
        catch _ { return false }
        return true
    }
}

// MARK: - Array Conformance
extension xJSON {
    static func parseArray(data:Data) -> [Any]? {
        let json = self.parse(data:data)
        return self.conformToArray(json)
    }

    static func parseArray(file:String?) -> [Any]? {
        let json = self.parse(file:file)
        return self.conformToArray(json)
    }
}

// MARK: -
fileprivate extension xJSON {
    static func read(file:String) -> Data? {
        guard (FileManager.default.fileExists(atPath: file)) else { return nil }
        return (try? Data(contentsOf: URL(fileURLWithPath: file), options: .uncached))
    }

    static func conformToArray(_ json:Any?) -> [Any]? {
        switch (json) {
        case is [[AnyHashable:Any]]:    return (json as! [[AnyHashable:Any]])
        case is [AnyHashable:Any]:      return [(json as! [AnyHashable:Any])]
        case is [AnyHashable]:          return (json as! [AnyHashable])
        default:                        return nil
        }
    }
}
