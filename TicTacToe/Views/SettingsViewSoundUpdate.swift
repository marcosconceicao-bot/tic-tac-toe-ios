
// Add to SettingsView.swift

// In the main settings list, add:
Section("Audio") {
    NavigationLink(destination: SoundSettingsView()) {
        HStack {
            Image(systemName: "speaker.wave.3.fill")
                .foregroundColor(.blue)
                .frame(width: 25)
            Text("Sound & Music")
        }
    }
}
