# Bit Pack Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-bit-pack-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-bit-pack-primitives/actions/workflows/ci.yml)

`Bit.Pack<Word>` — a packing-layout witness that answers "how do *N* bits embed into `Word`-sized integers?": the number of words required and the unused trailing bits in the last one.

It owns no storage. `Bit.Pack` is the *law* of a layout — the word count and slack you'd need to back a bit collection — computed from a typed bits-per-word ratio, so the arithmetic (`100 bits ÷ 64-bit words → 2 words, 28 unused`) lives in one type rather than scattered across open-coded `/` and `%`.

---

## Key Features

- **Layout witness, not storage** — `Bit.Pack<Word>` derives the word count and unused-bit count for a given bit count; it holds no buffer, so it's a cheap value you compute and discard.
- **Word-type-parametric** — pack into `UInt8` … `UInt64` (any `FixedWidthInteger & UnsignedInteger`); the layout adapts to the word width via `Affine.Discrete.Ratio<Word, Bit>`.
- **Typed counts** — the `count:` is a `Bit.Index.Count` and the projections (`.words.count`, `.bits.unused`) are typed, not bare `Int`.
- **Word and bit projections** — `.words` is the word-domain view (how many words) and `.bits` is the bit-domain view (e.g. `.unused` trailing bits) of the same layout.

---

## Quick Start

```swift
import Bit_Pack_Primitives

// How do 100 bits pack into UInt64 words?
let pack = Bit.Pack<UInt64>(count: 100, bitsPerWord: .bitWidth)
pack.words.count    // 2  — needs two 64-bit words
pack.bits.unused    // 28 — unused trailing bits in the last word

// The layout adapts to the word type:
Bit.Pack<UInt8>(count: 10, bitsPerWord: .bitWidth).words.count   // 2  (16-bit capacity, 6 unused)
```

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-bit-pack-primitives.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Bit Pack Primitives", package: "swift-bit-pack-primitives")
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

| Product | Contents | When to import |
|---------|----------|----------------|
| `Bit Pack Primitives` | `Bit.Pack<Word>` layout witness with its `.words` and `.bits` projections | Consumers |
| `Bit Pack Primitives Test Support` | Re-exports for downstream test targets | Test target only |

---

## Platform Support

| Platform         | CI  | Status       |
|------------------|-----|--------------|
| macOS 26         | Yes | Full support |
| Linux            | Yes | Full support |
| Windows          | Yes | Full support |
| iOS/tvOS/watchOS | —   | Supported    |
| Swift Embedded   | —   | Supported    |

---

## Related Packages

- [`swift-bit-index-primitives`](https://github.com/swift-primitives/swift-bit-index-primitives) — `Bit.Index.Count`, the bit-count type the layout is computed from.
- [`swift-bit-primitives`](https://github.com/swift-primitives/swift-bit-primitives) — `Bit`, the unit being packed.
- [`swift-affine-primitives`](https://github.com/swift-primitives/swift-affine-primitives) — `Affine.Discrete.Ratio<Word, Bit>`, the typed bits-per-word ratio.

---

## Community

<!-- BEGIN: discussion -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
