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

public import Affine_Primitives
public import Index_Primitives

extension Bit.Pack {
    /// A bit's location within word-based storage.
    ///
    /// When bits are packed into fixed-width integer words, `Location` provides
    /// the computed word index, bit offset, and mask needed for read/write operations.
    ///
    /// The type is generic over the word type, allowing use with any storage:
    /// - `Location<UInt>` for standard word-sized storage
    /// - `Location<UInt8>` for byte-packed storage
    /// - `Location<UInt32>` for 32-bit word storage
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let index: Bit.Index = 42
    /// let loc = Bit.Pack<UInt>.Location(index: index, bitsPerWord: .bitsPerWord)
    /// let bit = (words[loc.word] & loc.mask) != 0
    /// ```
    public struct Location: Sendable {
        /// The word index in the storage array.
        public let word: Index<Word>

        /// The bit offset within the word (0..<Word.bitWidth).
        public let bit: Index<Bit>.Offset

        /// The bitmask for this bit position: `1 << bit`.
        public let mask: Word

        /// Creates a location from precomputed values.
        @inlinable
        public init(
            word: Index<Word>,
            bit: Index<Bit>.Offset,
            mask: Word
        ) {
            self.word = word
            self.bit = bit
            self.mask = mask
        }

        /// Creates a location from precomputed word and bit indices.
        @inlinable
        public init(
            word: Index<Word>,
            bit: Index<Bit>.Offset
        ) {
            self.word = word
            self.bit = bit
            self.mask = Word(1) << bit.rawValue.rawValue
        }

        /// Creates a location from a typed bit index.
        ///
        /// - Parameters:
        ///   - index: The bit index to locate.
        ///   - bitsPerWord: The ratio of bits per word for the storage type.
        @inlinable
        public init(
            index: Bit.Index,
            bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
        ) {
            let (q, r) = Int(bitPattern: index).quotientAndRemainder(dividingBy: bitsPerWord.factor)
            self.word = Index<Word>(Ordinal(UInt(q)))
            self.bit = Index<Bit>.Offset(Affine.Discrete.Vector(r))
            self.mask = Word(1) << r
        }

        /// Creates a location from a typed bit count.
        ///
        /// Use this when computing the location for append/remove operations
        /// where you have the count rather than an index.
        ///
        /// - Parameters:
        ///   - count: The bit count (used as position).
        ///   - bitsPerWord: The ratio of bits per word for the storage type.
        @inlinable
        public init(
            count: Bit.Index.Count,
            bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
        ) {
            self.init(index: Bit.Index(count), bitsPerWord: bitsPerWord)
        }
    }
}
