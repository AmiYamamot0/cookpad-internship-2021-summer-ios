import SwiftUI

struct ProductDetailPageView: View {
    @State var isCartViewPresented: Bool = false
    @EnvironmentObject var cartState: CartState
    
    var product: FetchProductsQuery.Data.Product
    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(urlString: product.imageUrl)
                .frame(maxHeight: 300)
            VStack(alignment: .leading, spacing: 30) {
                Text(product.name)
                    .font(.title)
                Text("\(product.price)円")
                    .font(.title2)
                Text(product.summary)
                Spacer()
                Button(action: {
                    cartState.add(product: product)
                }) {
                    Text("カートに追加")
                }
                .padding(.all)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(10)
            }
            .padding(.horizontal, 8)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    self.isCartViewPresented = true
                }) {
                    VStack() {
                        Image(systemName: "folder")
                        Text("\(cartState.count)")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isCartViewPresented) {
            NavigationView {
                CartPageView()
            }
        }
    }
}

struct ProductDetailPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailPageView(
                product: FetchProductsQuery.Data.Product(
                    id: UUID().uuidString,
                    name: "商品 \(1)",
                    price: 100,
                    summary: "おいしい食材 \(1)",
                    imageUrl: "https://image.mini-mart.com/dummy/1"
                )
            )
        }
        .environmentObject(CartState())
    }
}
