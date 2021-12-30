//
//  ContentView.swift
//  Pinch
//
//  Created by Morgan Bonhomme on 28/12/2021.
//

import SwiftUI

struct ContentView: View {
  @State private var isAnimating: Bool = false
  @State private var imageScale: CGFloat = 1
  @State private var imageOffset: CGSize = .zero
  
  func resetImageState() {
    withAnimation(.spring()) {
      imageScale = 1
      imageOffset = .zero
    }
  }

  var body: some View {
    NavigationView {
      ZStack {
        Color(.clear)
        
        
        // MARK: Image

        Image("magazine-front-cover")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .padding()
          .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
          .opacity(isAnimating ? 1 : 0).animation(.linear(duration: 1), value: isAnimating)
          .scaleEffect(imageScale)
          .offset(imageOffset)

          // MARK: Zoom

          .onTapGesture(count: 2) {
            if imageScale == 1 {
              withAnimation(.spring()) {
                imageScale = 5
              }
            } else {
              resetImageState()
            }
          }

          // MARK: Drag image

          .gesture(
            DragGesture()
              .onChanged { value in
                withAnimation(.linear(duration: 1)) {
                  imageOffset = value.translation
                }
              }
              .onEnded { _ in
                if imageScale <= 1 {
                  resetImageState()
                }
              }
          )
      }
      .onAppear(perform: { isAnimating = true })
      .navigationTitle("Pinch & Zoom")
      .navigationBarTitleDisplayMode(.inline)
      .overlay(InfoPanelView(scale: imageScale, offset: imageOffset).padding(), alignment: .top)
       
    }
    .navigationViewStyle(.stack)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
