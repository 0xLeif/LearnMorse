//
//  ContentView.swift
//  Shared
//
//  Created by Leif on 2/22/21.
//

import SwiftUI

import Fake
import Morse

struct ContentView: View {
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State private var isTranslatingFromMorse = true
    
    @State private var currentWord = Fake.Word.Random.word
    @State private var currentAnswer = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            Toggle(isOn: $isTranslatingFromMorse, label: {
                Text(isTranslatingFromMorse ? "Translate from Morse" : "Translate to Morse")
            })
            .padding()
            
            Spacer()
            
            Text(isTranslatingFromMorse ? currentWord.toMorse: currentWord).font(.largeTitle)
                .scaleEffect(2)
            
            VStack {
                Text("(answer)").font(.caption)
                Text(isTranslatingFromMorse ? currentWord: currentWord.toMorse).font(.caption2)
            }
            .rotationEffect(.radians(.pi))
            .scaleEffect(0.5)
            
            Spacer()
            
            if isTranslatingFromMorse {
                TextField(isTranslatingFromMorse ? "Translate from Morse" : "Translate to Morse", text: $currentAnswer, onCommit:  {
                    submitAnswer()
                })
                .disableAutocorrection(true)
                .padding()
            } else {
                VStack {
                    Text(currentAnswer).padding()
                    HStack {
                        Button("Delete") {
                            guard !currentAnswer.isEmpty else {
                                return
                            }
                            
                            currentAnswer = currentAnswer.dropLast().map { "\($0)" }.joined()
                        }.padding()
                        Button("Space") {
                            currentAnswer += " "
                        }.padding()
                    }
                    HStack {
                        Button("Dit") {
                            currentAnswer += "."
                        }.padding()
                        Button("Dah") {
                            currentAnswer += "-"
                        }.padding()
                    }
                    
                }
                .padding()
            }
            
            
            Spacer()
            
            Button("Submit") {
                submitAnswer()
            }
            .padding()
        }
        
    }
    
    private var isAnswerCorrect: Bool {
        if isTranslatingFromMorse {
            return currentAnswer.lowercased() == currentWord
        } else {
            return currentAnswer == currentWord.toMorse
        }
    }
    
    private func submitAnswer() {
        if isAnswerCorrect {
            feedback.notificationOccurred(.success)
            currentWord = Fake.Word.Random.word
            currentAnswer = ""
        } else {
            feedback.notificationOccurred(.error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
