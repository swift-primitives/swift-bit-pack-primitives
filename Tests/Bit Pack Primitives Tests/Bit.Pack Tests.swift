// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing
import Bit_Pack_Primitives
import Bit_Pack_Primitives_Test_Support

// MARK: - Bit.Pack Tests (Parallel Namespace per [TEST-004])

@Suite("Bit.Pack")
struct BitPackTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Unit Tests

extension BitPackTests.Unit {
    @Test
    func `pack for 0 bits`() {
        let pack = Bit.Pack<UInt64>(count: 0, bitsPerWord: .bitWidth)

        #expect(pack.words.count == 0)
        #expect(pack.bits.unused == 0)
    }

    @Test
    func `pack for exactly 64 bits`() {
        let pack = Bit.Pack<UInt64>(count: 64, bitsPerWord: .bitWidth)

        #expect(pack.words.count == 1)
        #expect(pack.bits.unused == 0)
    }

    @Test
    func `pack for 65 bits`() {
        let pack = Bit.Pack<UInt64>(count: 65, bitsPerWord: .bitWidth)

        #expect(pack.words.count == 2)
        #expect(pack.bits.unused == 63)
    }

    @Test
    func `pack for 100 bits`() {
        let pack = Bit.Pack<UInt64>(count: 100, bitsPerWord: .bitWidth)

        // 100 bits needs 2 words (128 bits capacity), with 28 unused
        #expect(pack.words.count == 2)
        #expect(pack.bits.unused == 28)
    }

    @Test
    func `pack for UInt8 words`() {
        let pack = Bit.Pack<UInt8>(count: 10, bitsPerWord: .bitWidth)

        // 10 bits needs 2 bytes (16 bits capacity), with 6 unused
        #expect(pack.words.count == 2)
        #expect(pack.bits.unused == 6)
    }

    @Test
    func `capacity-based init`() {
        let pack = Bit.Pack<UInt64>(count: 100, bitsPerWord: .bitWidth)

        #expect(pack.words.count == 2)
        #expect(pack.bits.unused == 28)
    }
}

// MARK: - Edge Case Tests

extension BitPackTests.EdgeCase {
    @Test
    func `pack for 1 bit`() {
        let pack = Bit.Pack<UInt64>(count: 1, bitsPerWord: .bitWidth)

        #expect(pack.words.count == 1)
        #expect(pack.bits.unused == 63)
    }

    @Test
    func `pack at exact word boundary`() {
        let pack = Bit.Pack<UInt64>(count: 128, bitsPerWord: .bitWidth)

        #expect(pack.words.count == 2)
        #expect(pack.bits.unused == 0)
    }
}
