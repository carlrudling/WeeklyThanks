

import SwiftUI

struct SnapshotView: View {
    var body: some View {
        ZStack {
            Rectangle().fill(Color(red: 4/255, green: 5/255, blue: 15/255).gradient)
            VStack {
                Image(systemName: "photo")
                    .font(.system(size: 80))
                    .background(in: Circle().inset(by: -40))
                    .backgroundStyle(.blue.gradient)
                    .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
                    .padding(60)
                Text("Hello, world!")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    SnapshotView()
}
