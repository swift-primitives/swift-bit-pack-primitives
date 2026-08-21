extension Bit.Pack {

    public struct Bits: Sendable {

        public let unused: Bit.Index.Count

        @inlinable
        public init(unused: Bit.Index.Count) {
            self.unused = unused
        }
    }
}
