import SwiftUI

struct ConnexionView: View {
    @State private var loginData = LoginData(mail: "", password: "")
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var navigateToOrdersView = false
    @State private var navigateToRegisterView = false
    @State private var connexionToken: String = ""


    private let postURLString = "https://mypizza.lesmoulinsdudev.com/auth"

    func login() {
        let params: [String: Any] = [
            "mail": loginData.mail,
            "password": loginData.password
        ]
        
        if let url = URL(string: self.postURLString) {
            APIService.shared.postRequest(
                url: url,
                params: params,
                type: token.self,
                completionHandler: { (response) in
                    if(response.token != ""){
                        print("User logged in successfully: \(response)")
                        connexionToken = response.token
                        UserDefaults.standard.set(connexionToken, forKey: "connexionToken")
                        navigateToOrdersView = true
                            
                    }
                },
                errorHandler: { (error) in
                    print("Error login user: \(error)")
                }
            )
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("My Pizza")
                    .font(.system(size: 36))
                    .bold()
                    .foregroundStyle(.white)
                    .background(
                        Image("pizza")
                    )

                TextField("Adresse mail", text: $loginData.mail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .frame(height: 40.0)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                SecureField("Mot de passe", text: $loginData.password)
                    .frame(height: 40.0)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button("Connexion") {
                        login()
                    
                    }
                    .frame(width: 310.0, height: 40.0)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .background(Color(red: 0.6, green: 0, blue: 0))
                    .clipShape(Capsule())
                    .navigationDestination(isPresented: $navigateToOrdersView) {
                        OrdersView()
                    }
                }

                Text("Pas encore inscrit? créer un compte")
                    .foregroundStyle(.white)

                Button("Créer un compte") {
                    navigateToRegisterView = true
                }
                .frame(width: 310.0, height: 40.0)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .background(Color(red: 0.6, green: 0, blue: 0))
                .clipShape(Capsule())
                .navigationDestination(isPresented: $navigateToRegisterView) {
                    RegisterView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }


}



#Preview {
    ConnexionView()
}
