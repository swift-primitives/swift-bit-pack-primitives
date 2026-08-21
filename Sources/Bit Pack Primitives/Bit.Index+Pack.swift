public import Affine_Primitives
import Index_Primitives

extension Bit.Index {

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
