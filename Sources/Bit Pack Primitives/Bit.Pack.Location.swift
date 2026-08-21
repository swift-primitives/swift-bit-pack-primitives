public import Affine_Primitives
public import Index_Primitives

extension Bit.Pack {

    public struct Location: Sendable {

        public let word: Index<Word>

        public let bit: Index<Bit>.Offset

        public let mask: Word

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

        @inlinable
        public init(
            word: Index<Word>,
            bit: Index<Bit>.Offset
        ) {
            self.word = word
            self.bit = bit
            self.mask = Word(1) << bit.magnitude
        }

        @inlinable
        public init(
            index: Bit.Index,
            bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
        ) {

            let (wordIndex, bitOffset) = try! bitsPerWord.quotientAndRemainder(dividing: index)
            self.word = wordIndex
            self.bit = bitOffset
            self.mask = Word(1) << bitOffset.magnitude
        }

        @inlinable
        public init(
            count: Bit.Index.Count,
            bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
        ) {
            self.init(
                index: count.map(Ordinal.init),
                bitsPerWord: bitsPerWord
            )
        }
    }
}

extension Bit.Pack.Location {

    @inlinable
    public func index(
        bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
    ) -> Bit.Index {
        (word.map(Cardinal.init) * bitsPerWord).map(Ordinal.init) + bit.magnitude
    }
}
