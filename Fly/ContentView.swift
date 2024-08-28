//
//  ContentView.swift
//  Fly
//
//  Created by feng on 8/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SidebarView()
        }
    }
}

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
    @State private var metarInput: String = ""
    @State private var translatedReport: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("METAR 报文翻译")
                .font(.headline)
            
            TextField("请输入 METAR 报文", text: $metarInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: translateMETAR) {
                Text("翻译")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Text("翻译结果：")
                .font(.subheadline)
                .padding(.top)
            
            Text(translatedReport)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .navigationTitle("METAR")
    }
    
    private func translateMETAR() {
        let components = metarInput.split(separator: " ")
        var translation = ""
        
        for component in components {
            if let airport = parseAirportCode(component) {
                translation += "\(airport): \(getAirportName(airport))\n"
            } else if let timeInfo = parseTime(component) {
                translation += "\(timeInfo)\n"
            } else if let weatherInfo = parseWeather(component) {
                translation += "\(weatherInfo)\n"
            } else {
                translation += "\(component): 未知的 METAR 代码。\n"
            }
        }
        
        translatedReport = translation
    }
    
    // 解析机场代码
    private func parseAirportCode(_ code: Substring) -> String? {
        // 使用已知的 ICAO 机场代码进行匹配
        let knownAirports = ["ZUUU", "EGLL", "KLAX", "RJTT"] // 示例
        return knownAirports.contains(String(code)) ? String(code) : nil
    }
    
    // 获取机场名称
    private func getAirportName(_ code: String) -> String {
        let airportNames = [
            "ZUUU": "成都双流国际机场",
            "EGLL": "伦敦希思罗机场",
            "KLAX": "洛杉矶国际机场",
            "RJTT": "东京羽田机场"
        ]
        return airportNames[code, default: "未知机场"]
    }
    
    // 解析时间信息
    private func parseTime(_ component: Substring) -> String? {
        let pattern = #"(\d{2})(\d{2})(\d{2})Z"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: String(component), range: NSRange(location: 0, length: component.count)) {
            let day = (component as NSString).substring(with: match.range(at: 1))
            let hour = (component as NSString).substring(with: match.range(at: 2))
            let minute = (component as NSString).substring(with: match.range(at: 3))
            return "\(day) 日 \(hour):\(minute) UTC 报文发布"
        }
        return nil
    }
    
    // 解析天气信息
    private func parseWeather(_ component: Substring) -> String? {
        // 添加更多模式匹配来识别和翻译天气信息
        let weatherTranslations = [
            "AUTO": "自动生成",
            "-TSRA": "小雷暴雨",
            "SCT015": "散云，云底高度 1500 英尺",
            "BKN025": "多云，云底高度 2500 英尺",
            "OVC040": "阴云，云底高度 4000 英尺",
            "Q1008": "气压 1008 百帕斯卡"
        ]
        return weatherTranslations[String(component)]
    }
}
