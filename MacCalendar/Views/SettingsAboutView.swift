//
//  SettingsAbout.swift
//  MacCalendar
//
//  Created by ruihelin on 2025/10/6.
//

import SwiftUI

struct SettingsAboutView: View {
    var body: some View {
        VStack(alignment:.center,spacing: 10){
            Text("MacCalendar")
                .font(.title)
            Text("完全免费且开源的macOS小而美菜单栏日历")
                .foregroundStyle(.secondary)
            HStack{
                Text("版本")
                Text(Bundle.main.appVersion ?? "")
            }
            .foregroundStyle(.secondary)
            
            Link(destination: URL(string:"https://github.com/bylinxx/MacCalendar")!) {
                Image("github-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct SettingsAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAboutView()
    }
}
