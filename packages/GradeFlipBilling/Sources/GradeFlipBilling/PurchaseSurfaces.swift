public struct GradeFlipPurchaseSurface: Hashable, Sendable {
    public var title: String
    public var message: String
    public var recommendedProducts: [GradeFlipStoreProduct]

    public init(
        title: String,
        message: String,
        recommendedProducts: [GradeFlipStoreProduct]
    ) {
        self.title = title
        self.message = message
        self.recommendedProducts = recommendedProducts
    }
}
