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
    /// A packing layout witness for bit storage in fixed-width integer words.
    ///
    /// `Pack` encodes the law "these bits are embedded into these words
    /// with this slack convention". It provides derived facts about the
    /// layout without owning any storage.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let count: Bit.Index.Count = 100
    /// let pack = Bit.Pack<UInt>(count: count, bitsPerWord: .bitsPerWord)
    /// let words = ContiguousArray<UInt>(repeating: 0, count: pack.words.count)
    /// ```
    public struct Pack<Word: FixedWidthInteger & UnsignedInteger & Sendable>: Sendable {
        /// Word-domain projection of this layout.
        public let words: Words

        /// Bit-domain projection of this layout.
        public let bits: Bits

        /// Creates a packing layout from a bit count.
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
            self.words = Words(count: Index_Primitives.Index<Word>.Count(Cardinal(UInt(q + r.signum()))))
            self.bits = Bits(unused: Bit.Index.Count(Cardinal(UInt((bitsPerWord.factor - r) % bitsPerWord.factor))))
        }
    }
}
