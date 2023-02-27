//
//  ListaDeTarefasApp.swift
//  ListaDeTarefas
//
//  Created by Argos A Maia on 24/02/23.
//

import SwiftUI

@main
struct ContentViewApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                LoginView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Login")
                    }
                
                ListadeTarefasView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Lista de Tarefas")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
