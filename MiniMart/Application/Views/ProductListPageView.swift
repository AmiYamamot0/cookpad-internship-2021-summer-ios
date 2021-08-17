import SwiftUI

struct ProductListPageView: View {
    @State var products: [FetchProductsQuery.Data.Product] = []
    @State var isCartViewPresented: Bool = false
    @EnvironmentObject var cartState: CartState
    
    var body: some View {
        List(products, id: \.id) { product in
            NavigationLink(destination: ProductDetailPageView(product: product)) {
                HStack(alignment: .top) {
                    RemoteImage(urlString: product.imageUrl)
                        .frame(width: 100, height: 100)
                    VStack(alignment: .leading) {
                        Text(product.name)
                        Spacer()
                            .frame(height: 8)
                        Text(product.summary)
                        Spacer()
                        Text("\(product.price)円")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            Network.shared.apollo.fetch(query: FetchProductsQuery()) { result in
                switch result {
                case let .success(graphqlResult):
                    self.products = graphqlResult.data?.products ?? []
                case .failure:
                    break
                }
            }
        }
        .navigationTitle("MiniMart")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    self.isCartViewPresented = true
                }) {
                    VStack() {
                        Image(systemName: "folder")
                        Text("\(cartState.products.count)")
                    }
                }
            }
        }
        .sheet(isPresented: $isCartViewPresented) {
            NavigationView {
                CartPageView()
            }
        }
    }
}

struct ProductListPageView_Previews: PreviewProvider {
    static let products = [
        FetchProductsQuery.Data.Product(
            id: UUID().uuidString,
            name: "商品 \(1)",
            price: 100,
            summary: "おいしい食材 \(1)",
            imageUrl: "https://image.cookpad-mart.com/dummy/1"
        ),
        FetchProductsQuery.Data.Product(
            id: UUID().uuidString,
            name: "商品 \(2)",
            price: 200,
            summary: "おいしい食材 \(2)",
            imageUrl: "https://image.cookpad-mart.com/dummy/2"
        ),
    ]
    
    static var previews: some View {
        NavigationView {
            ProductListPageView(products: products)
        }
    }
}
