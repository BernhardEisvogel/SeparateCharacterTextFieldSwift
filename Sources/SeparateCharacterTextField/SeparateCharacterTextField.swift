//
//  SeparateCharacterTextField.swift
//
//  Created by Bernhard Eisvogel on 10.04.24.
//

import SwiftUI

public struct SeparateCharacterTextField<Content: View>: View {
    
    private var maxFields:Int = 8
    @FocusState private var focus: Int?
    @Binding private var text:String
    let content: Content
    
    public init(text:Binding<String>, @ViewBuilder background: () -> Content){
        _text = text
        self.content = background()
    }
    
    func replace(_ myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        if chars.count-index <= 0 {chars.append(contentsOf: Array(repeating: " ", count: 1 + index - chars.count))}
        chars[index] = newChar
        var modifiedString = String(chars)
        
        // We dont want it to end with a lot of white spaces
        while(modifiedString.last == " " && modifiedString.count > 0) {
            modifiedString.removeLast()
        }
        
        return modifiedString
    }

    public var body: some View {
        HStack {
            ForEach(0..<maxFields, id: \.self) { i  in
                TextField("", text: Binding<String>(
                    get: {
                        let sIndex = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
                        if sIndex != nil && i < text.count{return String(text[sIndex!])}
                        else{return " "}
                    },
                    set: { newValue in
                        var newValueP = newValue
                        while(newValueP.last == " " && newValueP.count > 0) {
                            newValueP.removeLast()
                        }
                        text = replace(text, i, newValueP.last ?? " ")
                    })
                )
                .onAppear {keyboardSubscribe(i)}
               .focused($focus, equals: i)
                .textFieldStyle(.plain)
                .frame(width: 50, height: 50)
                .background(content: {
                    content
                })
            }
        }.textFieldStyle(RoundedBorderTextFieldStyle())
        .multilineTextAlignment(.center)
    }
    
    private func keyboardSubscribe(_ i:Int) {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            if focus == i {
                handleKey(key:aEvent.keyCode, focus:$focus, position: i)
            }
            return aEvent
        }
    }
    
    private func handleKey(key : UInt16, focus:FocusState<Int?>.Binding, position:Int = 0){
        if (key == 51){// delete = 51
            focus.wrappedValue = max(position - 1 , 0)
        }else if (key == 126 || key == 123){// left =123,up, 126
            focus.wrappedValue = max(position - 1 , 0)
        }else if (key == 125 || key == 124){// down == 125, right == 124
            focus.wrappedValue = min(position + 1 , maxFields)
        }else{
            focus.wrappedValue = min(position + 1, maxFields)
        }
    }
}

@available(iOS 17.0, *)
extension SeparateCharacterTextField where Content == StrokeShapeView<RoundedRectangle, Color, EmptyView>{
    // This initialiser is for the standard constructor and gives a default value for the ViewBuilder
    public init(_ text:Binding<String>){
        self.init(text: text, background: {
                RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                    .stroke(Color.black, lineWidth: 3.0)
        })
    }
}
