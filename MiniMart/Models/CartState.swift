import Foundation
import Combine

final class CartState: ObservableObject {
    @Published var products: [FetchProductsQuery.Data.Product] = []
}
