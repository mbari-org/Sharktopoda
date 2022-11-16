//
//  SharktopodaApp.swift
//  Created for Sharktopoda on 9/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

@main
struct SharktopodaApp: App {
  @StateObject private var sharktopodaData = SharktopodaData()
  
  @StateObject private var dataStore = DataStore()
  
  init() {
    setAppDefaults()
  }
  
  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(sharktopodaData)
      
    }
    .commands {
      SharktopodaCommands()
    }
    
//    WindowGroup("Note", for: Note.ID.self) { $noteId in
//      NoteView(noteId: noteId)
//        .environmentObject(dataStore)
//    }

//    WindowGroup("Video", for: VideoAsset.ID.self) { $videoId in
//      VideoView(id: videoId)
//        .environmentObject(sharktopodaData)
//    }
    
    Settings {
      Preferences()
        .environmentObject(sharktopodaData)
    }
  }
}

struct NoteView: View {
  @EnvironmentObject var dataStore: DataStore
  let noteId: UUID?
  
  var body: some View {
    if let noteId {
      if let index = dataStore.notes.firstIndex(
        where: { $0.id == noteId }
      ) {
        TextEditor(text: $dataStore.notes[index].text)
          .navigationTitle(dataStore.notes[index].name)
      } else {
        // If we ended up here, it means that the note detail window was state restored by SwiftUI, but we didn't implement data persistence, so we can't show the note.
        Text("Couldn't find the presented note, because data persistence is not implemented in this sample project")
      }
    } else {
      Text("Nothing selected")
    }
  }
}

class DataStore: ObservableObject {
  @Published var notes: [Note] = []
}

struct Note: Identifiable {
  var id = UUID()
  var text: String = ""
  var name: String
}
