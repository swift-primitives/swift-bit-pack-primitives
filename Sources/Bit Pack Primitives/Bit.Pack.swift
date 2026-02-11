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
            let (wordCount, remainingBits) = bitsPerWord.quotientAndRemainder(dividing: count)
            let hasPartialWord = remainingBits > .zero
            self.words = Words(count: hasPartialWord ? wordCount + .one : wordCount)
            let bitsPerWordCount = Index_Primitives.Index<Word>.Count.one * bitsPerWord
            self.bits = Bits(unused: hasPartialWord
                ? bitsPerWordCount.subtract.saturating(remainingBits)
                : .zero
            )
        }
    }
}

extension Bit.Pack {
    /// The number of bits per word as a typed bit count.
    ///
    /// Derived from the `Ratio<Word, Bit>.bitWidth` morphism applied to
    /// one word, centralizing the domain bound as a typed constant.
    @inlinable
    public static var bitWidth: Bit.Index.Count {
        Index_Primitives.Index<Word>.Count.one * Affine.Discrete.Ratio<Word, Bit>.bitWidth
    }
}
