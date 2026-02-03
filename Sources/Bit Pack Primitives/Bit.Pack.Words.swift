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

extension Bit.Pack {
    /// Word-domain metadata for a packing layout.
    public struct Words: Sendable {
        /// The number of words needed to store the bits.
        public let count: Index_Primitives.Index<Word>.Count

        @inlinable
        public init(count: Index_Primitives.Index<Word>.Count) {
            self.count = count
        }
    }
}
