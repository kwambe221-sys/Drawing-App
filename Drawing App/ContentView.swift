//
//  ContentView.swift
//  Drawing App
//
//  Created by Boateng, Kwame on 5/1/26.
//
import SwiftUI

struct Line {
    var points: [CGPoint] = []
    var color: Color = .red
    var lineWidth: Double = 1.0
}

struct ContentView: View {
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var thickness: Double = 1.0

    var body: some View {
        VStack {
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }
                
                var activePath = Path()
                activePath.addLines(currentLine.points)
                context.stroke(activePath, with: .color(currentLine.color), lineWidth: currentLine.lineWidth)
            }
            .frame(minWidth: 400, minHeight: 400)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let newPoint = value.location
                        currentLine.points.append(newPoint)
                    }
                    .onEnded { value in
                        lines.append(currentLine)
                        currentLine = Line(points: [], color: currentLine.color, lineWidth: thickness)
                    }
            )

            HStack {
                Slider(value: $thickness, in: 1...20) {
                    Text("Thickness")
                }
                .frame(maxWidth: 200)
                .onChange(of: thickness) { newThickness in
                    currentLine.lineWidth = newThickness
                }

                Divider()

                
                ColorPicker("Color", selection: $currentLine.color)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

