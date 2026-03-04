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
import Index_Primitives

extension Bit.Index {

    /// Computes the location of this bit index within word-based storage.
    ///
    /// - Parameter bitsPerWord: The ratio of bits per word for the storage type.
    /// - Returns: The word index, bit offset, and mask for this bit position.
    @inlinable
    public func location<Word: FixedWidthInteger & UnsignedInteger>(
        bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
    ) -> Bit.Pack<Word>.Location {
        Bit.Pack<Word>.Location(
            index: self,
            bitsPerWord: bitsPerWord
        )
    }
}
