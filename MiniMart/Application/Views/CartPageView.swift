import SwiftUI

struct CartPageView: View {
    @State var isCartViewPresented: Bool = false
    @State var isOrderConfirmationAlertPresented: Bool = false
    @EnvironmentObject var cartState: CartState
    
    var body: some View {
        VStack {
            List(cartState.cartItems, id: \.product.id) { item in
                HStack(alignment: .top) {
                    RemoteImage(urlString: item.product.imageUrl)
                        .frame(width: 100, height: 100)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.product.name)
                        Text("\(item.product.price)円")
                        Text("\(item.quantity)個")
                    }
                    .padding(.vertical, 8)
                }
            }
            VStack(spacing: 16) {
                Text("合計: \(cartState.totalPrice)円")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Button(action: {
                    self.isOrderConfirmationAlertPresented = true
//                    self.isCartViewPresented?.dismiss()
                }) {
                    Text("注文する")
                }
                .padding(.all)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(10)
            }
            .padding(8)
        }
        
        .alert(isPresented: $isOrderConfirmationAlertPresented) {
            Alert(
                title: Text("注文が完了しました"),
                message: nil,
                dismissButton: Alert.Button.default(Text("OK")) {
                    isCartViewPresented = false
                    cartState.clear()
                }
            )
        }
        .navigationTitle("カート")
    }
}

struct CartPageView_Previews: PreviewProvider {
//    @State var isCartViewPresented: Bool = false
    static var previews: some View {
        NavigationView {
            CartPageView()
        }
        .environmentObject(CartState())
    }
}
