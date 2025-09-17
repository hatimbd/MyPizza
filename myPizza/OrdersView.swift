//
//  OrdersView.swift
//  myPizza
//
//  Created by Hatim Bahand on 16/01/2025.
//

import SwiftUI

struct OrdersView: View {
    @State private var recipeData = RecipeData(id : 0, name: "", ingredients: "")
    @State private var navigateToOrderView = false
    
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var orders : [OrdersData] = []
    
    @State private var receivedTokenn = UserDefaults.standard.string(forKey: "connexionToken")
    
    @Environment(\.dismiss) private var dismiss

    
    private let getURLString = "https://mypizza.lesmoulinsdudev.com/orders"
    

    func getOrders() {
        if let tokenn = receivedTokenn, !tokenn.isEmpty {
            if let url = URL(string: self.getURLString ) {
                APIService.shared.getRequest(
                    url: url,
                    type: [OrdersData].self,
                    completionHandler: { (response) in
                        if(!response.isEmpty){
                            orders = response
                            print("orders loaded successfully: \(response)")
                            print(response)
                        }
                    },
                    errorHandler: { (error) in
                        print("Error registering user: \(error)")
                    }
                )
            }
        }
    }

    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("Vos dernières commandes")
                    .padding(.bottom, 500)
                    .bold()
                    .font(.system(size: 26))
                Button("Nouvelle commande") {
                    navigateToOrderView = true
                }
                .frame(width: 310.0, height: 40.0)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .background(Color(red: 0.6, green: 0, blue: 0))
                .clipShape(Capsule())
                .navigationDestination(isPresented: $navigateToOrderView){
                    OrderView()
                }
                Button("load recipes") {
                    getOrders()
                }
                .frame(width: 310.0, height: 40.0)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .background(Color(red: 0.6, green: 0, blue: 0))
                .clipShape(Capsule())
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(Color(red: 0, green: 0.1, blue: 0.2))
            .ignoresSafeArea()
            
            
            
        }
    }
}

#Preview {
    OrdersView()
}
