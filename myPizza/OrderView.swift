//
//  OrderView.swift
//  myPizza
//
//  Created by Hatim Bahand on 16/01/2025.
//

import SwiftUI

struct OrderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var receivedToken = UserDefaults.standard.string(forKey: "connexionToken")
    //@State private var receivedTokenn = ""
    
    @State private var recipeData = RecipeData(id : 0, name: "", ingredients: "")
    @State private var navigateToOrderView = false
    
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var recipes : [RecipeData] = []
    @State private var doughs : [DoughData] = []
    @State private var  orderData = OrderData(recipeId:1, doughId:1)

    
    private let getURLStringRecipes = "https://mypizza.lesmoulinsdudev.com/recipes"
    private let getURLStringDoughs = "https://mypizza.lesmoulinsdudev.com/doughs"
    private let postURLStringOrder = "https://mypizza.lesmoulinsdudev.com/order"
    

        func getRecipes() {
          
            if let url = URL(string: self.getURLStringRecipes ) {
                APIService.shared.getRequest(
                    url: url,
                    type: [RecipeData].self,
                    completionHandler: { (response) in
                        if(!response.isEmpty){
                            recipes = response
                            print("recipes loaded successfully: \(response)")
                            print(response)
                        }
                    },
                    errorHandler: { (error) in
                        print("Error registering user: \(error)")
                    }
                )
            }
        }
        func getDoughs() {
          
            if let url = URL(string: self.getURLStringDoughs ) {
                APIService.shared.getRequest(
                    url: url,
                    type: [DoughData].self,
                    completionHandler: { (response) in
                        if(!response.isEmpty){
                            doughs = response
                            print("doughs loaded successfully: \(response)")
                            print(response)
                        }
                    },
                    errorHandler: { (error) in
                        print("Error registering user: \(error)")
                    }
                )
            }
        }
    func sendOrder() {
        let params: [String: Any] = [
            "recipeId": orderData.recipeId,
            "doughId": orderData.doughId
        ]
        if let token = receivedToken, !token.isEmpty {
            if let url = URL(string: self.postURLStringOrder) {
                APIService.shared.postRequest(
                    url: url,
                    params: params,
                    token: token,
                    type: OrderData.self,
                    completionHandler: { (response) in
                        //if(response.status=="check the response code !"){
                        print("commmad sent successfully: \(response)")
                        
                        // }
                    },
                    errorHandler: { (error) in
                        print("Error registering user: \(error)")
                    }
                )
            }
        }
    }

        
        
    
    
    
    var body: some View {
        
        NavigationStack{
            VStack {
                Text("Choisissez votre recette")
                    .bold()
                    .foregroundStyle(.white)
                    .font(.system(size: 26))
                Picker(selection: $orderData.recipeId, label: Text("Recette")) {
                    ForEach(recipes){ recipe in
                        Text(recipe.name)
                            .tag(recipe.id)
                    }
                }.onAppear{ getRecipes()}
                
                .frame(width: 300.0, height: 200.0)
                Text("Choisissez votre patte")
                    .bold()
                    .font(.system(size: 26))
                    .foregroundStyle(.white)
                Picker(selection: $orderData.doughId, label: Text("Dough")) {
                    ForEach(doughs){ dough in
                        Text(dough.name)
                            .tag(dough.id)
                    }
                }.onAppear{ getDoughs()}
                .frame(width: 300.0, height: 200.0)
                .padding(.bottom, 20)
                Button("Commander") {
                    sendOrder()
                }
                .frame(width: 310.0, height: 40.0)
                .foregroundStyle(.white)
                
                .padding(.horizontal, 20)
                .background(Color(red: 0.6, green: 0, blue: 0))
                .clipShape(Capsule())
                Button("Retour") {
                    dismiss()
                }
                .frame(width: 310.0, height: 40.0)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .background(Color(red: 0.6, green: 0, blue: 0))
                .clipShape(Capsule())
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0, green: 0.1, blue: 0.2))
        }
    }
}

#Preview {
    OrderView()
}
