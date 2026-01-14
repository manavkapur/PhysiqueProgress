//
//  AuthService.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 01/01/26.
//

import FirebaseAuth

final class AuthService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ){
        Auth.auth().signIn(withEmail: email, password: password){ _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
     func signup(
         email: String,
         password: String,
         completion: @escaping (Result<Void, Error>) -> Void
     ) {
         Auth.auth().createUser(withEmail: email, password: password) { _, error in
             if let error {
                 completion(.failure(error))
             } else {
                 completion(.success(()))
             }
         }
     }
}
