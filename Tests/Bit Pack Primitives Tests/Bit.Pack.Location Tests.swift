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

import Bit_Pack_Primitives
import Bit_Pack_Primitives_Test_Support
import Testing

// MARK: - Bit.Pack.Location Tests (Parallel Namespace per [TEST-004])

@Suite("Bit.Pack.Location")
struct BitPackLocationTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Unit Tests

extension BitPackLocationTests.Unit {
    @Test
    func `init from word, bit, and mask components`() {
        let word: Index<UInt64> = 5
        let bit: Index<Bit>.Offset = 3
        let mask: UInt64 = 1 << 3

        let location = Bit.Pack<UInt64>.Location(word: word, bit: bit, mask: mask)

        #expect(location.word == 5)
        #expect(location.bit == 3)
        #expect(location.mask == mask)
    }

    @Test
    func `init from word and bit computes mask`() {
        let word: Index<UInt64> = 0
        let bit: Index<Bit>.Offset = 7

        let location = Bit.Pack<UInt64>.Location(word: word, bit: bit)

        #expect(location.word == 0)
        #expect(location.bit == 7)
        #expect(location.mask == UInt64(1) << 7)
    }

    @Test
    func `mask computation for bit 0`() {
        let word: Index<UInt64> = 0
        let bit: Index<Bit>.Offset = 0

        let location = Bit.Pack<UInt64>.Location(word: word, bit: bit)

        #expect(location.mask == 1)
    }

    @Test
    func `mask computation for various bit positions`() {
        for bitPosition in 0..<64 {
            let word: Index<UInt64> = 0
            let bit: Index<Bit>.Offset = Index<Bit>.Offset(Affine.Discrete.Vector(bitPosition))

            let location = Bit.Pack<UInt64>.Location(word: word, bit: bit)

            #expect(location.mask == UInt64(1) << bitPosition)
        }
    }

    @Test
    func `init from typed bit index`() {
        // Bit index 70 with 64 bits per word should be word 1, bit 6
        let bitIndex: Bit.Index = 70
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 1)
        #expect(location.bit == 6)
        #expect(location.mask == UInt64(1) << 6)
    }

    @Test
    func `init from typed bit count`() {
        // Bit count 70 with 64 bits per word should be word 1, bit 6
        let count: Bit.Index.Count = 70
        let location = Bit.Pack<UInt64>.Location(count: count, bitsPerWord: .bitWidth)

        #expect(location.word == 1)
        #expect(location.bit == 6)
        #expect(location.mask == UInt64(1) << 6)
    }

    @Test
    func `location for bit index 0`() {
        let bitIndex: Bit.Index = 0
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 0)
        #expect(location.bit == 0)
        #expect(location.mask == 1)
    }

    @Test
    func `location for bit index 63 (last bit of first word)`() {
        let bitIndex: Bit.Index = 63
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 0)
        #expect(location.bit == 63)
        #expect(location.mask == UInt64(1) << 63)
    }

    @Test
    func `location for bit index 64 (first bit of second word)`() {
        let bitIndex: Bit.Index = 64
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 1)
        #expect(location.bit == 0)
        #expect(location.mask == 1)
    }

    @Test
    func `UInt8 word type - 8 bits per word`() {
        // Bit index 10 with 8 bits per word should be word 1, bit 2
        let bitIndex: Bit.Index = 10
        let location = Bit.Pack<UInt8>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 1)
        #expect(location.bit == 2)
        #expect(location.mask == UInt8(1) << 2)
    }

    @Test
    func `UInt32 word type - 32 bits per word`() {
        // Bit index 35 with 32 bits per word should be word 1, bit 3
        let bitIndex: Bit.Index = 35
        let location = Bit.Pack<UInt32>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 1)
        #expect(location.bit == 3)
        #expect(location.mask == UInt32(1) << 3)
    }

    @Test
    func `location via Bit.Index convenience method`() {
        let bitIndex: Bit.Index = 70
        let location: Bit.Pack<UInt64>.Location = bitIndex.location(bitsPerWord: .bitWidth)

        #expect(location.word == 1)
        #expect(location.bit == 6)
        #expect(location.mask == UInt64(1) << 6)
    }
}

// MARK: - Edge Case Tests

extension BitPackLocationTests.EdgeCase {
    @Test
    func `boundary: bit position 0 in word 0`() {
        let bitIndex: Bit.Index = 0
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 0)
        #expect(location.bit == 0)
        #expect(location.mask == 1)
    }

    @Test
    func `boundary: maximum bit position in UInt8 word`() {
        let bitIndex: Bit.Index = 7
        let location = Bit.Pack<UInt8>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word == 0)
        #expect(location.bit == 7)
        #expect(location.mask == UInt8(1) << 7)
    }

    @Test
    func `boundary: word transition at UInt8 boundary`() {
        // Bit 7 should be in word 0, bit 8 should be in word 1
        let bit7: Bit.Index = 7
        let bit8: Bit.Index = 8

        let loc7 = Bit.Pack<UInt8>.Location(index: bit7, bitsPerWord: .bitWidth)
        let loc8 = Bit.Pack<UInt8>.Location(index: bit8, bitsPerWord: .bitWidth)

        #expect(loc7.word == 0)
        #expect(loc7.bit == 7)

        #expect(loc8.word == 1)
        #expect(loc8.bit == 0)
    }

    @Test
    func `large bit index`() {
        let bitIndex: Bit.Index = 1000
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        // 1000 / 64 = 15, 1000 % 64 = 40
        #expect(location.word == 15)
        #expect(location.bit == 40)
        #expect(location.mask == UInt64(1) << 40)
    }
}
