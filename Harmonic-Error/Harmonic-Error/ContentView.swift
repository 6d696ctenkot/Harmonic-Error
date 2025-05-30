import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var phase: CGFloat = 0.0
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var glitch = false
    @State private var player: AVAudioPlayer?

    var body: some View {
        ZStack {
            AngularGradient(
                gradient: Gradient(colors: [.red, .blue, .green, .purple, .yellow]),
                center: .center,
                angle: .degrees(Double(phase))
            )
            .blur(radius: glitch ? 30 : 5)
            .saturation(glitch ? 2.5 : 1.0)
            .scaleEffect(glitch ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.5), value: glitch)

            if glitch {
                Text("!#@&%*?!")
                    .font(.system(size: 50, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(Double.random(in: -10...10)))
                    .offset(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: -30...30))
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            phase += 1
            if Int.random(in: 0...100) > 95 {
                glitch.toggle()
                playGlitchSound()
            }
        }
    }

    func playGlitchSound() {
        guard let url = Bundle.main.url(forResource: "glitch", withExtension: "wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing glitch sound.")
        }
    }
}
