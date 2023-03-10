//
//  File.swift
//  
//
//  Created by Dmitry Bespalov on 03.01.22.
//

import Foundation
import Solidity
import XCTest

class ArrayEncodingTests: XCTestCase {
    func testEncodeStaticElements() {
        // bytes3[] = [0xaabbcc, 0x112233] = encoded as uint256(2) bytes3[2](...) = uint256(2) (bytes3, bytes3) = uint256(2) bytes3 bytes3
        let value = Sol.Array(elements: [
            Sol.Bytes3(storage: Data([0xaa, 0xbb, 0xcc])),
            Sol.Bytes3(storage: Data([0x11, 0x22, 0x33]))
        ])
        let expected = Data([
            // uint256(2)
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 16 bytes
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, // 32 bytes
            // bytes3 0xaabbcc
            0xaa, 0xbb, 0xcc, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 16 bytes
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 32 bytes
            // bytes3 0x112233
            0x11, 0x22, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 16 bytes
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 32 bytes
        ])
        let data = value.encode()
        XCTAssertEqual(Array(data), Array(expected))
    }

    func testDecodeStaticElements() throws {
        let data = Data([
            // uint256(2)
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 16 bytes
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, // 32 bytes
            // bytes3 0xaabbcc
            0xaa, 0xbb, 0xcc, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 16 bytes
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 32 bytes
            // bytes3 0x112233
            0x11, 0x22, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 16 bytes
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 32 bytes
        ])
        var value = Sol.Array<Sol.Bytes3>()
        var offset = 0
        try value.decode(from: data, offset: &offset)
        continueAfterFailure = false
        XCTAssertEqual(value.elements.count, 2)
        XCTAssertEqual(Array(value.elements[0].storage), [0xaa, 0xbb, 0xcc])
        XCTAssertEqual(Array(value.elements[1].storage), [0x11, 0x22, 0x33])
        XCTAssertEqual(offset, 96)
    }
}
