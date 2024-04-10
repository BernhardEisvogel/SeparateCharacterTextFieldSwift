//
//  SeparateCharacterTextField.swift
//
//  Created by Bernhard Eisvogel on 09.04.24.
//
import SwiftUI

struct ContentView: View {
    @State var string:String = ""
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            TextField("", text:$string)
            SeparateCharacterTextField($string)
            
            SeparateCharacterTextField(text: $string, background: {
                RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                    .stroke(Color.red, lineWidth: 3.0)
            })
        }.frame(width: 400)
    }
}
