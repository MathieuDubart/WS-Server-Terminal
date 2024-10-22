//
//  main.swift
//  WebSocketServer
//
//  Created by Al on 22/10/2024.
//

import Foundation

var serverWS = WebSocketServer.shared
serverWS.start()

RunLoop.main.run()
