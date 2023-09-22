//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Resat Pekgozlu on 29/04/2023.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
}

@MainActor class GlobalActorBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor
    func getData() {
        // REALY HEAVY COMPLEX METHODS
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { data in
                    Text(data)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
