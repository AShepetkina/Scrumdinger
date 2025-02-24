import SwiftUI

struct ScrumsView: View {
    @State private var currentTime: String = ""
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false
    let saveAction: () -> Void
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                List($scrums) { $scrum in
                    NavigationLink(destination: DetailView(scrum: $scrum)) {
                        CardView(scrum: scrum)
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .navigationTitle("Daily Scrums")
                .toolbar {
                    Button(action: {
                        isPresentingNewScrumView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Scrum")
                }

                Spacer()

                Text(currentTime)
                    .font(.footnote)
                    .padding()
                    .onReceive(timer) { _ in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm:ss, dd MMM yyyy"
                        currentTime = formatter.string(from: Date())
                    }
            }
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NewScrumSheet(
                scrums: $scrums,
                isPresentingNewScrumView: $isPresentingNewScrumView)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
    }
}
