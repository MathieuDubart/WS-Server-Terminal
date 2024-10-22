//
//  TerminalCommandExecutor.swift
//  WebSocketServer
//
//  Created by Al on 22/10/2024.
//

import SwiftUI
import Combine

class TerminalCommandExecutor: ObservableObject {
    @Published var output: String = ""
    
    // Fonction pour exécuter la commande dans le terminal
    func executeCommand(_ command: String) {
        DispatchQueue.global().async {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = ["-c", command]
            task.launchPath = "/bin/zsh"
            
            do {
                try task.run()
            } catch {
                DispatchQueue.main.async {
                    self.output = "Erreur lors de l'exécution de la commande: \(error.localizedDescription)"
                }
                return
            }
            
            let outputHandle = pipe.fileHandleForReading
            let outputData = outputHandle.readDataToEndOfFile()
            let outputString = String(data: outputData, encoding: .utf8) ?? ""
            
            DispatchQueue.main.async {
                self.output = outputString
            }
        }
    }
}

extension TerminalCommandExecutor {
    func say(_ textToSay:String) {
        self.executeCommand("say \(textToSay)")
    }
}
