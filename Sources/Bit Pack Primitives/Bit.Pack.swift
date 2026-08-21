public import Affine_Primitives
import Index_Primitives

extension Bit {

    public struct Pack<Word: FixedWidthInteger & UnsignedInteger & Sendable>: Sendable {

        public let words: Words

        public let bits: Bits

        @inlinable
        public init(
            count: Bit.Index.Count,
            bitsPerWord: Affine.Discrete.Ratio<Word, Bit>
        ) {

            let (wordCount, remainingBits) = try! bitsPerWord.quotientAndRemainder(dividing: count)
            let hasPartialWord = remainingBits > .zero
            self.words = Words(count: hasPartialWord ? wordCount + .one : wordCount)
            let bitsPerWordCount = Index_Primitives.Index<Word>.Count.one * bitsPerWord
            self.bits = Bits(
                unused: hasPartialWord
                    ? bitsPerWordCount.subtract.saturating(remainingBits)
                    : .zero
            )
        }
    }
}

extension Bit.Pack {

    @inlinable
    public static var bitWidth: Bit.Index.Count {
        Index_Primitives.Index<Word>.Count.one * .bitWidth
    }
}
