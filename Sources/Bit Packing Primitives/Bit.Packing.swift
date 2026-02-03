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

import Index_Primitives

extension Bit {
    /// Packing requirements for a bit count in word-based storage.
    ///
    /// Computes the number of words needed and unused bits in the last word
    /// for packing a given number of bits into fixed-width integer words.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let count: Bit.Index.Count = 100
    /// let packing = Bit.Packing<UInt>(count: count, bitsPerWord: .bitsPerWord)
    /// let words = ContiguousArray<UInt>(repeating: 0, count: packing.wordCount)
    /// ```
    public struct Packing<Word: FixedWidthInteger & UnsignedInteger & Sendable>: Sendable {
        /// The number of words needed to store the bits.
        public let wordCount: Index_Primitives.Index<Word>.Count

        /// The number of unused bits in the last word (0..<Word.bitWidth).
        public let unusedBits: Bit.Index.Count

        /// Creates packing requirements from a bit count.
        ///
        /// - Parameters:
        ///   - count: The number of bits to pack.
        ///   - bitsPerWord: The ratio of bits per word for the storage type.
        @inlinable
        public init(
            count: Bit.Index.Count,
            bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
        ) {
            let (q, r) = Int(bitPattern: count).quotientAndRemainder(dividingBy: bitsPerWord.factor)
            self.wordCount = Index_Primitives.Index<Word>.Count(Cardinal(UInt(q + r.signum())))
            self.unusedBits = Bit.Index.Count(Cardinal(UInt((bitsPerWord.factor - r) % bitsPerWord.factor)))
        }
    }
}
