//
//  ContentView.swift
//  Fly
//
//  Created by feng on 8/28/24.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        List {
            NavigationLink(destination: METARView()) {
                Label("METAR", systemImage: "list.bullet")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Fly")
    }
}

struct METARView: View {
    var body: some View {
        Text("这里将显示METAR气象报文")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("METAR")
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Fly")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
