//
//  EventEditView.swift
//  MacCalendar
//
//  Created by ruihelin on 2025/10/8.
//

import SwiftUI

struct EventEditView: View {
    @EnvironmentObject var calendarManager: CalendarManager
    
    let event: CalendarEvent
    
    @State private var editedEvent: CalendarEvent
    @State private var alertInfo: AlertInfo?
    @State private var showingResetConfirmation = false
    
    init(event: CalendarEvent) {
        self.event = event
        self._editedEvent = State(initialValue: event)
    }
    
    private func bindingFor(optionalString: Binding<String?>) -> Binding<String> {
        return Binding<String>(
            get: { optionalString.wrappedValue ?? "" },
            set: { optionalString.wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
    
    private func bindingFor(optionalURL: Binding<URL?>) -> Binding<String> {
        return Binding<String>(
            get: { optionalURL.wrappedValue?.absoluteString ?? "" },
            set: { optionalURL.wrappedValue = URL(string: $0) }
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Image(systemName: "t.square").font(.title3).frame(width: 35)
                        .foregroundColor(.secondary)
                    TextField("标题", text: $editedEvent.title)
                        .textFieldStyle(.plain)
                }
                
                Divider()
                    .foregroundStyle(Color(hex: "cccccc"))
                
                HStack {
                    Image(systemName: "location").font(.title3).frame(width: 35).foregroundColor(.secondary)
                    TextField("地点", text: bindingFor(optionalString: $editedEvent.location))
                        .textFieldStyle(.plain)
                } 
                
                Divider()
                    .foregroundStyle(Color(hex: "cccccc"))
                
                HStack {
                    Image(systemName: "hourglass").font(.title3).frame(width: 35).foregroundColor(.secondary)
                    Toggle("全天", isOn: $editedEvent.isAllDay.animation())
                }
                
                Divider()
                    .foregroundStyle(Color(hex: "cccccc"))
                
                HStack {
                    Image(systemName: "clock").font(.title3).frame(width: 35).foregroundColor(.secondary)
                    DatePicker("", selection: $editedEvent.startDate, displayedComponents: editedEvent.isAllDay ? .date : [.date, .hourAndMinute])
                        .labelsHidden()
                    Image(systemName: "arrow.right").foregroundColor(.secondary)
                    DatePicker("", selection: $editedEvent.endDate, in: editedEvent.startDate..., displayedComponents: editedEvent.isAllDay ? .date : [.date, .hourAndMinute])
                        .labelsHidden()
                }
                .onChange(of: editedEvent.startDate) { newStartDate in
                    if newStartDate > editedEvent.endDate {
                        editedEvent.endDate = newStartDate
                    }
                }
                
                Group {
                    Divider()
                        .foregroundStyle(Color(hex: "cccccc"))
                    
                    HStack {
                        Image(systemName: "link").font(.title3).frame(width: 35).foregroundColor(.secondary)
                        TextField("URL", text: bindingFor(optionalURL: $editedEvent.url))
                            .textFieldStyle(.plain)
                    }
                    
                    Divider()
                        .foregroundStyle(Color(hex: "cccccc"))
                    
                    HStack {
                        Image(systemName: "doc.text").font(.title3).frame(width: 35).foregroundColor(.secondary)
                        TextField("备注", text: bindingFor(optionalString: $editedEvent.notes))
                            .textFieldStyle(.plain)
                    }
                }
            }
            .padding(10)
            .background(Color(hex: "#ccc").opacity(0.1))
            .cornerRadius(8)
            .padding()
            
            Spacer()
            
            VStack(spacing: 12) {
                HStack{
                    Button("重置"){
                        showingResetConfirmation = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                    .cornerRadius(10)
                    
                    Button("保存") {
                        Task {
                            do {
                                try await calendarManager.updateEvent(event: editedEvent)
                                self.alertInfo = AlertInfo(
                                    title: "保存成功",
                                    message: "修改已成功保存。",
                                    onDismiss: {
                                    }
                                )
                                
                            } catch {
                                self.alertInfo = AlertInfo(
                                    title: "保存失败",
                                    message: error.localizedDescription,
                                    onDismiss: nil
                                )
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(width: 480, height: 450)
        .navigationTitle("编辑日程")
        .disabled(editedEvent.allowsModify == false)
        .alert("放弃修改", isPresented: $showingResetConfirmation) {
            Button("放弃", role: .destructive) {
                editedEvent = event
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("确定要放弃修改吗？此操作无法撤销。")
        }
        .alert(item: $alertInfo) { info in
            if let onDismissAction = info.onDismiss {
                return Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .default(Text("确定"), action: {
                        onDismissAction()
                    })
                )
            } else {
                return Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .cancel(Text("好的"))
                )
            }
        }
    }
    

}
