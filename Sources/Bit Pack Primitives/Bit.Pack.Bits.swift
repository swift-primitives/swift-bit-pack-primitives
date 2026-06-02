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

extension Bit.Pack {
    /// Bit-domain metadata for a packing layout.
    public struct Bits: Sendable {
        /// The number of unused bits in the last word.
        ///
        /// Lies in `0..<Word.bitWidth`.
        public let unused: Bit.Index.Count

        /// Creates bit-domain metadata with the given count of unused bits.
        @inlinable
        public init(unused: Bit.Index.Count) {
            self.unused = unused
        }
    }
}
