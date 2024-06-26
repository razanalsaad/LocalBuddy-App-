import SwiftUI
import CloudKit

struct activityForm: View {
    @EnvironmentObject var viewModel: ActivityViewModel
    
    @State private var location = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var numberOfPeople = 1
    @State private var selectedActivityIndex = 0
    @State private var showingAlert = false
    @State private var navigateToMyActivity = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Activity Information")) {
                    TextField("Location", text: $location)
                    Picker("Select Activity", selection: $selectedActivityIndex) {
                        ForEach(viewModel.activityTypes.indices, id: \.self) { index in
                            Text(viewModel.activityTypes[index].name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Date & Time")) {
                    DatePicker("Date of the activity", selection: $date, in: Date()..., displayedComponents: .date)
                    DatePicker("Start Time", selection: $startTime, in: startTimeRange, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, in: endTimeRange, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Number of people")) {
                    HStack {
                        ForEach(1...4, id: \.self) { count in
                            Button(action: {
                                numberOfPeople = count
                            }) {
                                Text("\(count)")
                                    .frame(width: 60, height: 50)
                                    .background(numberOfPeople == count ? Color("mustard") : Color("gray2"))
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                Section {
                    Button(action: {
                        showingAlert = true
                    }) {
                       Text("Apply Activity")
                          .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .onAppear {
                viewModel.fetchActivityTypes()
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("New Activity Created"),
                    message: Text("You've successfully created a new activity"),
                    dismissButton: .default(Text("Ok")) {
                        navigateToMyActivity = true
                    }
                )
            }
            
            NavigationLink(destination: my_Activity(), isActive: $navigateToMyActivity) {
                EmptyView()
            }
            .hidden()
        }
    }

    private var startTimeRange: ClosedRange<Date> {
        let minTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let maxTime = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        return minTime...maxTime
    }
    
    private var endTimeRange: ClosedRange<Date> {
        let minTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let maxTime = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        return startTime...maxTime
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isPlaceholderVisible: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if isPlaceholderVisible {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                    .padding(.leading, 5)
            }

            TextField("", text: $text, onEditingChanged: { isEditing in
                self.isPlaceholderVisible = !isEditing && text.isEmpty
            })
            .foregroundColor(.black)
            .padding(.leading, 5)
        }
    }
}

struct activityform_Previews: PreviewProvider {
    static var previews: some View {
        activityForm()
            .environmentObject(ActivityViewModel())
    }
}
