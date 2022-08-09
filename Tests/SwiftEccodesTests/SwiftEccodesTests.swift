import XCTest
import SwiftEccodes

final class SwiftEccodesTests: XCTestCase {
    override func setUp() {
        let projectHome = String(#file[...#file.range(of: "/Tests/")!.lowerBound])
        FileManager.default.changeCurrentDirectoryPath(projectHome)
    }
    
    func testExample() throws {
        let file = try GribFile(file: "Tests/test.grib")
        for message in file.messages {
            message.iterate(namespace: .ls).forEach({
                print($0)
            })
            print(message.get(attribute: "name")!)
            let data = try message.getDouble()
            print(data[0..<10])
        }
    }
    
    func testExample2() throws {
        // Multi part grib files are the result of using range downloads via CURL
        let data = try Data(contentsOf: URL(fileURLWithPath: "/Users/patrick/Downloads/multipart2.grib"))
        try data.withUnsafeBytes { ptr in
            let file = GribMemory(ptr: ptr)
            for message in file.messages {
                message.iterate(namespace: .ls).forEach({
                    print($0)
                })
                message.iterate(namespace: .geography).forEach({
                    print($0)
                })
                print(message.get(attribute: "name")!)
                let data = try message.getDouble()
                print(data.count)
                print(data[0..<10])
            }
        }
    }
}
