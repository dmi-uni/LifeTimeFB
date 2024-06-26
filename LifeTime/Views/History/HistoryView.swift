import SwiftUI

struct HistoryView: View {
    @Environment(DBService.self) private var dataService
    @State private var isSheetPresented: Bool = false
    @State private var selectedFilterActivity: Activity?
    
    private var activityDictionary: [String: Activity] {
        Dictionary(uniqueKeysWithValues: dataService.activities.map { ($0.id, $0) })
    }
    
    private var filteredSessions: [Session] {
        if let activity = selectedFilterActivity {
            return dataService.sessions.filter { $0.activityID == activity.id }
        } else {
            return dataService.sessions
        }
    }
    
//    private var filterTitle: String {
//        if let activity = selectedFilterActivity {
//            return activity.title
//        } else {
//            return "История"
//        }
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                if !filteredSessions.isEmpty {
                    List{
                        ForEach(filteredSessions) { session in
                            HistoryItem(title: getActivityTitle(session: session), session: session)
                                .swipeActions {
                                    Button {
                                        dataService.deleteSession(id: session.id)
                                    } label: {
                                        Text("Удалить")
                                    }
                                    .tint(Color.appRed)
                                }
                        }
                        .listRowBackground(Color.backgroundSecondary)
                    }
                    .scrollContentBackground(.hidden)
                    .animation(.default, value: dataService.sessions)
                } else {
                    VStack {
                        Image(systemName: "clock")
                            .font(.title)
                            .padding(8)
                        
                        Text("Начните отслеживать активность!")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationTitle("История")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            withAnimation {
                                selectedFilterActivity = nil
                            }
                        } label: {
                            Text("Показать все")
                        }
                        .disabled(selectedFilterActivity == nil)
                        
                        Divider()
                        
                        ForEach(dataService.activities) { activity in
                            Button {
                                withAnimation {
                                    selectedFilterActivity = activity
                                }
                            } label: {
                                HStack {
                                    Text(activity.title)
                                    if selectedFilterActivity == activity {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    } label: {
                        Label(
                            "Filter", 
                            systemImage: selectedFilterActivity == nil 
                            ? "line.horizontal.3.decrease.circle"
                            : "line.horizontal.3.decrease.circle.fill"
                        )
                    }
                }
            }
            .tint(.accent)
            .sheet(isPresented: $isSheetPresented) {
                AddSessionView()
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func getActivityTitle(session: Session) -> String {
        activityDictionary[session.activityID]?.title ?? "Неизвестное"
    }
}

#Preview {
    HistoryView()
        .environment(DBService())
}
