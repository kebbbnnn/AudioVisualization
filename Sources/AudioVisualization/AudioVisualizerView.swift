// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct AudioVisualizerView: View {
    @StateObject private var model: AudioPlayViewModel
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 70) / 2 // between 0.1 and 35
        return CGFloat(level * (40/35))
    }
    
    public init(width: CGFloat, url: URL) {
        //_model = StateObject(wrappedValue: AudioPlayViewModel(url: url, sampels_count: Int(width * 0.6 / 4)))
        _model = StateObject(wrappedValue: AudioPlayViewModel(url: url, sampels_count: Int((width - 50) / 4)))
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack( alignment: .leading ) {
                LazyHStack(alignment: .center, spacing: 8) {
                    Button {
                        if model.isPlaying {
                            model.pauseAudio()
                        } else {
                            model.playAudio()
                        }
                    } label: {
                        Image(systemName: !(model.isPlaying) ? "play.fill" : "pause.fill" )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                        
                    }
                    
                    HStack(alignment: .center, spacing: 2) {
                        if model.soundSamples.isEmpty {
                            ProgressView()
                        } else {
                            ForEach(model.soundSamples, id: \.self) { model in
                                BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                            }
                        }
                    }
                    //.frame(width: proxy.size.width * 0.6)
                    .frame(width: proxy.size.width - 50)
                }
                .padding(.horizontal, 10)
            }
            .onAppear {
                //model.update(sample_count: Int(proxy.size.width * 0.6 / 4))
                model.update(sample_count: Int((proxy.size.width - 50) / 4))
            }
            .onDisappear {
                model.pauseAudio()
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(minHeight: 0, maxHeight: 50)
            .frame(width: proxy.size.width)
            .background(Color.gray.opacity(0.3).cornerRadius(10))
        }
    }
}

struct BarView: View {
    let value: CGFloat
    var color: Color = Color.gray
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .cornerRadius(10)
                .frame(width: 2, height: value)
        }
    }
}
