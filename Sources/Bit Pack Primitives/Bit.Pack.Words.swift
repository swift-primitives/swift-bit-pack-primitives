import Index_Primitives

extension Bit.Pack {

    public struct Words: Sendable {

        public let count: Index_Primitives.Index<Word>.Count

        @inlinable
        public init(count: Index_Primitives.Index<Word>.Count) {
            self.count = count
        }
    }
}
