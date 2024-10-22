//
//  WebSocketServer.swift
//  WebSocketServer
//
//  Created by digital on 22/10/2024.
//

import Swifter
import SwiftUI

class WebSocketServer {
    static var shared = WebSocketServer()
    
    @ObservedObject var cmd = TerminalCommandExecutor()
    let server = HttpServer()
    
    func start() {
        server["/say"] = websocket(text: { session, text in
            self.cmd.say(text)
        }, binary: { session, binary in

            if self.saveImage(from: binary, to: "./tmp.png"){
                print("Save OK")
            }else{
                print("Not an image")
            }
            
        })
        do{
            try server.start()
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
        }catch{
            
        }
    }
    
    func saveImage(from byteArray: [UInt8], to filePath: String) -> Bool {
        // 1. Convertir [UInt8] en Data
        let imageData = Data(byteArray)
        
        // 2. Créer une image à partir des données (Supposons que les données soient dans un format d'image, ex: PNG, JPEG)
        guard let image = NSImage(data: imageData) else {
            print("Impossible de créer l'image à partir des données fournies.")
            return false
        }
        
        // 3. Convertir NSImage en format de fichier (par exemple, PNG)
        guard let tiffData = image.tiffRepresentation else {
            print("Impossible d'obtenir la représentation TIFF de l'image.")
            return false
        }
        
        // 4. Créer une représentation bitmap pour l'image
        guard let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            print("Impossible de créer une représentation bitmap.")
            return false
        }
        
        // 5. Obtenir les données PNG de la représentation bitmap
        guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            print("Impossible de convertir l'image en PNG.")
            return false
        }
        
        // 6. Sauvegarder les données PNG dans un fichier
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            try pngData.write(to: fileURL)
            print("Image sauvegardée avec succès à : \(filePath)")
            return true
        } catch {
            print("Erreur lors de la sauvegarde de l'image : \(error)")
            return false
        }
    }
}
