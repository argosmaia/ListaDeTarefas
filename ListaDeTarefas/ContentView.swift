//
//  ContentView.swift
//  ListaDeTarefas
//
//  Created by Argos A Maia on 24/02/23.
//

import SwiftUI
import CoreData
import Foundation
import AVFoundation

struct Reminder: Identifiable {
    let id = UUID()
    let title: String
    var description: String
    let date: Date
    let sound: String
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var navigateToTasks = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                TextField("E-mail: ", text: $email)
                    .padding()
                SecureField("Senha: ", text: $password)
                    .padding()
            }
            .navigationBarTitle(Text("Login"))
            .navigationBarItems(trailing:
                Button(action: {
                    if self.email == "argosantao2013@gmail.com" && self.password == "12345" {
                        // Goes to another page
                        self.showAlert = false
                        self.email = ""
                        self.password = ""
                        self.navigateToTasks = true
                    } else {
                        self.showAlert = true
                    }
                }) {
                    Text("Login")
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Email or Password"), message: Text("Please try again."), dismissButton: .default(Text("OK")))
            }
            .background(
                NavigationLink(
                    destination: ListadeTarefasView(reminders: [
                        Reminder(title: "Lembrete 1", description: "Descrição do lembrete 1", date: Date(), sound: "som1"),
                        Reminder(title: "Lembrete 2", description: "Descrição do lembrete 2", date: Date(), sound: "som2"),
                        Reminder(title: "Lembrete 3", description: "Descrição do lembrete 3", date: Date(), sound: "som3"),
                    ]),
                    isActive: $navigateToTasks,
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct ListadeTarefasView: View {
    @State private var reminders: [Reminder]
    @State private var player: AVAudioPlayer?
    @State private var showAddReminder = false

    init(reminders: [Reminder] = []) {
        self._reminders = State(initialValue: reminders)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders) { reminder in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(reminder.title)
                                .font(.headline)
                            Text("Data: \(reminder.date)")
                            Text("Som: \(reminder.sound)")
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            TextField("Escreva aqui...", text: $reminders[reminders.firstIndex(where: { $0.id == reminder.id })!].description)
                                .onTapGesture(count: 1) {
                                    print("One-tap recognized")
                                }
                                .onTapGesture(count: 2) {
                                    print("Double-tap recognized")
                                }
                        }
                    }
                }
                .onDelete { indexSet in
                    self.reminders.remove(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("Lista de Tarefas")
            .navigationBarItems(trailing: Button(action: {
                self.showAddReminder.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddReminder) {
                AddReminderView { reminder in
                    self.reminders.append(reminder)
                    self.showAddReminder.toggle()
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.checkReminders()
            }
        }
    }
    
    func checkReminders() {
        let now = Date()
        for reminder in reminders {
            if reminder.date <= now {
                // find the index of the reminder in the array
                if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                    // update the description of the reminder
                    reminders[index].description = "Lembrete expirado"
                    // play the sound
                    if let soundURL = Bundle.main.url(forResource: reminder.sound, withExtension: "mp3") {
                        do {
                            player = try AVAudioPlayer(contentsOf: soundURL)
                            player?.play()
                        } catch {
                            print("Error playing sound: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

struct AddReminderView: View {
    let onAdd: (Reminder) -> Void
    // 3. Adicionando uma função de retorno de chamada para notificar a tela pai sobre a adição de um novo lembrete
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var sound = "som1"

    var body: some View {
        NavigationView {
            Form {
                TextField("Título", text: $title)
                TextField("Descrição", text: $description)
                DatePicker("Data", selection: $date, displayedComponents: [.date, .hourAndMinute])
                Picker("Som", selection: $sound) {
                    Text("Som 1").tag("som1")
                    Text("Som 2").tag("som2")
                    Text("Som 3").tag("som3")
                }
                Button("Adicionar") {
                    let newReminder = Reminder(title: title, description: description, date: date, sound: sound)
                    onAdd(newReminder) // 3. Notificando a tela pai sobre a adição de um novo lembrete
                }
            }
            .navigationBarTitle("Novo Lembrete")
        }
    }
}
class ReminderController {
    var reminders: [Reminder] = []
    var player: AVAudioPlayer?
    
    func checkReminders() {
        let now = Date()
        for reminder in reminders {
            if reminder.date <= now {
            // find the index of the reminder in the array
                if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                // update the description of the reminder
                    reminders[index].description = "Lembrete expirado"
                    // play the sound
                    if let soundURL = Bundle.main.url(forResource: reminder.sound, withExtension: "mp3") {
                        do {
                            player = try AVAudioPlayer(contentsOf: soundURL)
                            player?.play()
                        } catch {
                        print("Error playing sound: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
