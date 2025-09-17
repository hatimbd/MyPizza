import SwiftUI
import Foundation

struct RegisterView: View {
    @State private var registerData = RegisterData(name: "", mail: "", password: "")
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @Environment(\.dismiss) private var dismiss

    
    private let postURLString = "https://mypizza.lesmoulinsdudev.com/register"

        func registerUser() {
            let params: [String: Any] = [
                "name": registerData.name,
                "mail": registerData.mail,
                "password": registerData.password
            ]
            
            if let url = URL(string: self.postURLString) {
                APIService.shared.postRequest(
                    url: url,
                    params: params,
                    //token: token,
                    type: StatusResponse.self,
                    completionHandler: { (response) in
                        if(response.status=="check the response code !"){
                            print("User registered successfully: \(response)")
                        }
                    },
                    errorHandler: { (error) in
                        print("Error registering user: \(error)")
                    }
                )
            }
        }



    var body: some View {
        NavigationStack {
            VStack {
                Text("Inscription")
                    .font(.system(size: 36))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Image("pizza")
                    )

                TextField("Nom", text: $registerData.name)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                TextField("Adresse mail", text: $registerData.mail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                SecureField("Mot de passe", text: $registerData.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button("Enregistrer") {
                        registerUser()
                    }
                    .frame(width: 310.0, height: 40.0)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .background(Color(red: 0.6, green: 0, blue: 0))
                    .clipShape(Capsule())
                }

                Text("Déjà un compte ?")
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Button("Retour à la page de connexion") {
                    dismiss()
                }
                .frame(width: 310.0, height: 40.0)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .background(Color(red: 0.6, green: 0, blue: 0))
                .clipShape(Capsule())
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .background(Color.gray.opacity(0.2))
            .ignoresSafeArea()
        }
    }

    
}


#Preview {
    RegisterView()
}
