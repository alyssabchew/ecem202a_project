//
//  ViewController+GoogleDrive.swift
//  ARKitImageDetection
//
//  Created by Alyssa Chew on 12/3/22.
//  Copyright © 2022 Apple. All rights reserved.
//
// Adopted from code by Milan Paradina

import GTMSessionFetcherCore
import GoogleSignIn

extension ViewController {
    func googleSignIn(completionHandler: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil {
                print("Managed to restore previous sign in!\nScopes: \(String(describing: user?.grantedScopes))")
                
                self.requestScopes(googleUser: user!) { success in
                    if success == true {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                }
            } else {
                print("No previous user!\nThis is the error: \(String(describing: error?.localizedDescription))")
                let signInConfig = GIDConfiguration.init(clientID: "650303852572-8uenbk721vei175rb2p6utcbiahvlemr.apps.googleusercontent.com")
                GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { gUser, signInError in
                    if signInError == nil {
                        self.requestScopes(googleUser: gUser!) { signInSuccess in
                            if signInSuccess == true {
                                completionHandler(true)
                            } else {
                                completionHandler(false)
                            }
                        }
                    } else {
                        print("error with signing in: \(String(describing: signInError)) ")
                      self.service.authorizer = nil
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    func requestScopes(googleUser: GIDGoogleUser, completionHandler: @escaping (Bool) -> Void) {
        
        let grantedScopes = googleUser.grantedScopes
        if grantedScopes == nil || !grantedScopes!.contains("https://www.googleapis.com/auth/drive") {
            let additionalScopes = ["https://www.googleapis.com/auth/drive.file"]
            
            GIDSignIn.sharedInstance.addScopes(additionalScopes, presenting: self) { user, scopeError in
                if scopeError == nil {
                    user?.authentication.do { authentication, err in
                        if err == nil {
                            guard let authentication = authentication else { return }
                            // Get the access token to attach it to a REST or gRPC request.
                           // let accessToken = authentication.accessToken
                            let authorizer = authentication.fetcherAuthorizer()
                            self.service.authorizer = authorizer
                            completionHandler(true)
                        } else {
                            print("Error with auth: \(String(describing: err?.localizedDescription))")
                            completionHandler(false)
                        }
                    }
                } else {
                    completionHandler(false)
                    print("Error with adding scopes: \(String(describing: scopeError?.localizedDescription))")
                }
            }
        } else {
            print("Already contains the scopes!")
            completionHandler(true)
        }
    }
}
