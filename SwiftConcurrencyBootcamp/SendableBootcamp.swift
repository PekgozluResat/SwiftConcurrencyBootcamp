//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Resat Pekgozlu on 30/04/2023.
//

import SwiftUI

actor CurrenUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
    }
}

struct MyUserInfo: Sendable {
    var name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private(set) var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrenUserManager()
    
    func updateCurrentUserInfo() async {
        let info = MyClassUserInfo(name: "info")
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await viewModel.updateCurrentUserInfo()
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
