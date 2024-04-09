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
        }.frame(width: 400)
    }
}

struct SeparateCharacterTextField: View {
    
    private var maxFields:Int = 8
    @FocusState private var focus: Int?
    @Binding private var text:String

    
    init(_ text:Binding<String>){
        _text = text
    }
    init(text:Binding<String>){
        _text = text
    }
    
    func replace(_ myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        if chars.count-index <= 0 {chars.append(contentsOf: Array(repeating: " ", count: 1 + index - chars.count))}
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }

    
    var body: some View {
        HStack {
            ForEach(0..<maxFields, id: \.self) { i  in
                TextField("", text: Binding<String>(
                    get: {
                        let sIndex = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
                        if sIndex != nil && i < text.count{return String(text[sIndex!])}
                        else{return " "}
                    },
                    set: { newValue in
                        text = replace(text, i, newValue.first ?? " ")
                    })
                )
                .onSubmit {
                    focus = nil
                }
                .onKeyPress(action: {
                    a in
                    handleKey(key: a, focus:$focus, position: i)
                    return .ignored
                })
                
               .focused($focus, equals: i)
                    .textFieldStyle(.plain)
                    .frame(width: 50, height: 50)
                    .background(content: {
                        RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                            .stroke(Color.black, lineWidth: 3.0)
                        
                    })
            }
        }.textFieldStyle(RoundedBorderTextFieldStyle())
        .multilineTextAlignment(.center)
    }
    
    private func handleKey(key : KeyPress, focus:FocusState<Int?>.Binding, position:Int = 0){
        if (key.key == .delete || key.key == .clear || key.key == .deleteForward || key.key.character.description == "\u{7F}"){
            focus.wrappedValue = max(position - 1 , 0)
        }else if (key.key == KeyEquivalent.upArrow || key.key == .leftArrow){
            focus.wrappedValue = max(position - 1 , 0)
        }else if (key.key == KeyEquivalent.downArrow || key.key == .rightArrow){
            focus.wrappedValue = min(position + 1 , maxFields)
        }else{
            focus.wrappedValue = min(position + 1, maxFields)
        }
    }
}