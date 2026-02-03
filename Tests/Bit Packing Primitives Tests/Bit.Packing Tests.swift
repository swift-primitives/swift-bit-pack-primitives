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
import Bit_Packing_Primitives
import Bit_Packing_Primitives_Test_Support

// MARK: - Bit.Packing Tests (Parallel Namespace per [TEST-004])

@Suite("Bit.Packing")
struct BitPackingTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Unit Tests

extension BitPackingTests.Unit {
    @Test
    func `packing for 0 bits`() {
        let count: Bit.Index.Count = 0
        let packing = Bit.Packing<UInt64>(count: count, bitsPerWord: .bitWidth)

        #expect(packing.wordCount == 0)
        #expect(packing.unusedBits == 0)
    }

    @Test
    func `packing for exactly 64 bits`() {
        let count: Bit.Index.Count = 64
        let packing = Bit.Packing<UInt64>(count: count, bitsPerWord: .bitWidth)

        #expect(packing.wordCount == 1)
        #expect(packing.unusedBits == 0)
    }

    @Test
    func `packing for 65 bits`() {
        let count: Bit.Index.Count = 65
        let packing = Bit.Packing<UInt64>(count: count, bitsPerWord: .bitWidth)

        #expect(packing.wordCount == 2)
        #expect(packing.unusedBits == 63)
    }

    @Test
    func `packing for 100 bits`() {
        let count: Bit.Index.Count = 100
        let packing = Bit.Packing<UInt64>(count: count, bitsPerWord: .bitWidth)

        // 100 bits needs 2 words (128 bits capacity), with 28 unused
        #expect(packing.wordCount == 2)
        #expect(packing.unusedBits == 28)
    }

    @Test
    func `packing for UInt8 words`() {
        let count: Bit.Index.Count = 10
        let packing = Bit.Packing<UInt8>(count: count, bitsPerWord: .bitWidth)

        // 10 bits needs 2 bytes (16 bits capacity), with 6 unused
        #expect(packing.wordCount == 2)
        #expect(packing.unusedBits == 6)
    }

    @Test
    func `capacity-based init`() {
        let capacity: Bit.Index.Count = 100
        let packing = Bit.Packing<UInt64>(capacity: capacity, bitsPerWord: .bitWidth)

        #expect(packing.wordCount == 2)
        #expect(packing.unusedBits == 28)
    }
}

// MARK: - Edge Case Tests

extension BitPackingTests.EdgeCase {
    @Test
    func `packing for 1 bit`() {
        let count: Bit.Index.Count = 1
        let packing = Bit.Packing<UInt64>(count: count, bitsPerWord: .bitWidth)

        #expect(packing.wordCount == 1)
        #expect(packing.unusedBits == 63)
    }

    @Test
    func `packing at exact word boundary`() {
        let count: Bit.Index.Count = 128
        let packing = Bit.Packing<UInt64>(count: count, bitsPerWord: .bitWidth)

        #expect(packing.wordCount == 2)
        #expect(packing.unusedBits == 0)
    }
}
