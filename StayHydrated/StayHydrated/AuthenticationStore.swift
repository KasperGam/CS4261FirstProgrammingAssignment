//
//  AuthenticationStore.swift
//  StayHydrated
//
//  Created by Kasper Gammeltoft on 9/4/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import FirebaseUI
import FirebaseDatabase

public class AuthenticationStore {
    
    static var auth: Auth?
    
    static var currentDBUser: DatabaseReference? {
        guard let currentUser = auth?.currentUser else { return nil }
        let database = Database.database().reference()
        return database.child("UserData").child(currentUser.uid)
    }
}
