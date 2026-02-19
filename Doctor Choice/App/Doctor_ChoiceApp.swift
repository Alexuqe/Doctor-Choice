//
//  Doctor_ChoiceApp.swift
//  Doctor Choice
//
//  Created by Sasha on 16.02.26.
//

import SwiftUI

@main
struct Doctor_ChoiceApp: App {
    var body: some Scene {
        let cache = CacheService()
        let network = NetworkService(cache: cache)
        let pediatricVM = PediatriciansViewModel(networkService: network)

        WindowGroup {
            ContentView(viewModel: pediatricVM)
        }
    }
}
