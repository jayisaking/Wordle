//
//  ContentView.swift
//  Wordle
//
//  Created by 孫揚喆 on 2022/3/21.
//


import SwiftUI
struct letter{
    var element=AnyView(ZStack{
        RoundedRectangle(cornerRadius: 5)
            .stroke(Color.yellow,lineWidth:3)
            .frame(width:50,height: 55)
            .padding(.horizontal,3)
        
    })
}
struct ContentView: View {
    func setWord()->[String]{
        let filePath = Bundle.main.path(forResource: "5letterword", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        do {
            let listString = try String.init(contentsOf: URL)
            // use string here
            var seperatedStringArray=listString.components(separatedBy: "\n")
            var position=Int.random(in: 0..<2499)
            var targetString:[String]=[]
            for i in 0 ..< 5{
                targetString.append(String(Array(seperatedStringArray[position])[i]))
            }
            
            return targetString
        } catch  {
            print(error);
        }
        return ["a","p","p","l","e"]
    }
    @State private var firstOrNot=true
    @State private var modeSelection:[Int]=Array(repeating: 0, count: 5)
    @State private var popUpPresented=false
    var keyBoardFirstLine=["q","w","e","r","t","y","u","i","o","p"]
    @State private var keyBoardFirstLineColor:[Color]=Array(repeating: Color.yellow, count: 10)
    var keyBoardSecondLine=["a","s","d","f","g","h","j","k","l"]
    @State private var keyBoardSecondLineColor:[Color]=Array(repeating: Color.yellow, count: 10)
    var keyBoardThirdLine=["z","x","c","v","b","n","m"]
    @State private var keyBoardThirdLineColor:[Color]=Array(repeating: Color.yellow, count: 10)
    @State private var letterState:[[letter]]=Array(repeating: Array(repeating:letter() , count: 5), count: 5)
    @State private var recentX=0
    @State private var recentY=0
    @State private var currentAnwser=["","","","",""]
    @State private var targetString=["z","e","b","r","a"]
    @State private var correction=true
    @State private var failMessage=false //examine whether users has fail
    func initiate()->(){
        keyBoardFirstLineColor=Array(repeating: Color.yellow, count: 10)
        keyBoardSecondLineColor=Array(repeating: Color.yellow, count: 10)
        keyBoardThirdLineColor=Array(repeating: Color.yellow, count: 10)
        letterState=Array(repeating: Array(repeating:letter() , count: 5), count: 5)
        recentX=0
        recentY=0
        currentAnwser=["","","","",""]
        targetString=setWord()
        correction=true
        failMessage=false
    }
    func alterColorOfKeyBoard(mode:Int,letter:String){
        if keyBoardFirstLine.contains(letter){
            var index:Int=keyBoardFirstLine.firstIndex(of:letter) ?? 0
            if keyBoardFirstLineColor[index]==Color.yellow{
                if mode==1{
                    keyBoardFirstLineColor[index]=Color.green
                }else if mode==3{
                    keyBoardFirstLineColor[index]=Color.gray
                }else{
                    if #available(iOS 15.0, *) {
                        keyBoardFirstLineColor[index]=Color.brown
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }else if keyBoardSecondLine.contains(letter){
            var index:Int=keyBoardSecondLine.firstIndex(of:letter) ?? 0
            if keyBoardSecondLineColor[index]==Color.yellow{
                if mode==1{
                    keyBoardSecondLineColor[index]=Color.green
                }else if mode==3{
                    keyBoardSecondLineColor[index]=Color.gray
                }else{
                    if #available(iOS 15.0, *) {
                        keyBoardSecondLineColor[index]=Color.brown
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }else{
            var index:Int=keyBoardThirdLine.firstIndex(of:letter) ?? 0
            if keyBoardThirdLineColor[index]==Color.yellow{
                if mode==1{
                    keyBoardThirdLineColor[index]=Color.green
                }else if mode==3{
                    keyBoardThirdLineColor[index]=Color.gray
                }else{
                    if #available(iOS 15.0, *) {
                        keyBoardThirdLineColor[index]=Color.brown
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
    func getAnswer()->String{
        var answer=""
        for i in 0 ..< 5{
            answer+=targetString[i]
        }
         return answer
    }
    func checkValidaty()->(){
        if recentX<5{
            return
        }
        var temp=targetString
        for i in 0 ..< 5{
            if !targetString.contains(currentAnwser[i]){
                    letterState[recentY][i].element = AnyView(ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.gray)
                            .frame(width:50,height: 55)
                            .padding(.horizontal,3)
                        Text(currentAnwser[i].uppercased())
                            .font(.system(size:33))
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                        
                    })
                    correction=false
                    modeSelection[i]=3
                    //                alterColorOfKeyBoard(mode: 3, letter: currentAnwser[i])
                    
                }else{
                    var position = targetString.firstIndex(of: currentAnwser[i]) ?? 0
                    if position==i{
                        letterState[recentY][i].element = AnyView(ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.green)
                                .frame(width:50,height: 55)
                                .padding(.horizontal,3)
                            Text(currentAnwser[i].uppercased())
                                .font(.system(size:33))
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                            
                        })
                        //                    alterColorOfKeyBoard(mode: 1, letter: currentAnwser[i])
                        modeSelection[i]=1
                        
                    }else{
                        letterState[recentY][i].element = AnyView(ZStack{
                            if #available(iOS 15.0, *) {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color.brown)
                                    .frame(width:50,height: 55)
                                    .padding(.horizontal,3)
                            } else {
                                // Fallback on earlier versions
                            }
                            Text(currentAnwser[i].uppercased())
                                .font(.system(size:33))
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                            
                        })
                        //                    alterColorOfKeyBoard(mode: 2, letter: currentAnwser[i])
                        modeSelection[i]=2
                        correction=false
                    }
                    targetString[position]=""
                
            }
        }
        targetString=temp
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in 0 ..< 5{
                alterColorOfKeyBoard(mode: modeSelection[i], letter: currentAnwser[i])
            }
        }
        if correction{
            DispatchQueue.main.asyncAfter(deadline:.now()+1.0){
                popUpPresented=true
            }
            return
        }else if recentY==4{
            DispatchQueue.main.asyncAfter(deadline:.now()+1.0){
                failMessage=true
            }
        }
        correction=true
        if recentY==4{
            return
        }else{
            recentY+=1
            recentX=0
            
        }
    }
    func deleteLetter()->(){
        if recentX == 0 {
            return
        }
        currentAnwser[recentX]=""
        letterState[recentY][recentX-1].element = AnyView(ZStack{
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.yellow, lineWidth: 3)
                .frame(width:50,height: 55)
                .padding(.horizontal,3)
            
        })
        recentX-=1
        
    }
    func addLetter(enteredLetter:String)-> (){
        if recentX>4{
            return
        }
        currentAnwser[recentX]=enteredLetter
        letterState[recentY][recentX].element = AnyView(ZStack{
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.yellow, lineWidth: 3)
                .frame(width:50,height: 55)
                .padding(.horizontal,3)
            Text(enteredLetter.uppercased())
                .font(.system(size:33))
                .foregroundColor(Color.yellow)
                .fontWeight(.semibold)
            
        })
        recentX+=1
        
    }
    
    var body: some View {
        ZStack{
            VStack(spacing:5){
                ForEach(0 ..< 5){itemY in
                    HStack(spacing:5){
                        ForEach(0 ..< 5) { itemX in
                            letterState[itemY][itemX].element
                        }
                    }.padding(.vertical,3)
                }
                Spacer()
                VStack(spacing:5){
                    HStack(spacing: 5){
                        ForEach(0 ..< keyBoardFirstLine.count){item in
                            Button(action: {
                                if firstOrNot{
                                    targetString=setWord()
                                    firstOrNot=false
                                }
                                addLetter(enteredLetter: keyBoardFirstLine[item])
                            }) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(keyBoardFirstLineColor[item])
                                        .frame(width: 32, height: 45)
                                    Text(keyBoardFirstLine[item])
                                        .font(.system(size:22))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            
                        }
                    }
                    HStack(spacing: 5){
                        ForEach(0 ..< keyBoardSecondLine.count){item in
                            Button(action: {
                                if firstOrNot{
                                    targetString=setWord()
                                    firstOrNot=false
                                }
                                addLetter(enteredLetter: keyBoardSecondLine[item])
                            }) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(keyBoardSecondLineColor[item])
                                        .frame(width: 32, height: 45)
                                    Text(keyBoardSecondLine[item])
                                        .font(.system(size:22))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            
                        }
                        Button(action: {//delete icon
                            deleteLetter()
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(Color.yellow)
                                    .frame(width: 35, height: 45)
                                Image(systemName: "delete.left.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size:20))
                                
                            }
                        }
                    }
                    
                    
                    HStack(spacing: 5){
                        ForEach(0 ..< keyBoardThirdLine.count){item in
                            Button(action: {
                                if firstOrNot{
                                    targetString=setWord()
                                    firstOrNot=false
                                }
                                addLetter(enteredLetter: keyBoardThirdLine[item])
                            }) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(keyBoardThirdLineColor[item])
                                        .frame(width: 32, height: 45)
                                    Text(keyBoardThirdLine[item])
                                        .font(.system(size:22))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            
                        }
                        Button(action: {
                            checkValidaty()
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.yellow)
                                    .frame(width: 70, height: 45)
                                Text("return")
                                    .font(.system(size:18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }.padding(.leading,4)
                            
                        }
                    }
                    
                }
            }.padding(.vertical,20)
            if popUpPresented{
                ZStack{
                    Color.gray
                        .opacity(0.6)
                    
                    Rectangle(
                    )
                        .frame(width:270,height:340)
                        .foregroundColor(Color.white)
                    HStack {
                        Spacer()
                        VStack {
                            Button(action:{
                                popUpPresented=false
                                initiate()
                                
                            }){
                                Image(systemName: "xmark")
                                    .font(.system(size:35))
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                            
                        }
                    }.frame(width:230,height:300)
                    Text("Success")
                        .fontWeight(.bold)
                        .font(.title)
                }.ignoresSafeArea()
            }
            if failMessage{
                ZStack{
                    Color.gray
                        .opacity(0.6)
                    
                    Rectangle(
                    )
                        .frame(width:270,height:340)
                        .foregroundColor(Color.white)
                    HStack {
                        Spacer()
                        VStack {
                            Button(action:{
                                failMessage=false
                                initiate()
                                
                            }){
                                Image(systemName: "xmark")
                                    .font(.system(size:35))
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                            
                        }
                    }.frame(width:230,height:300)
                    VStack{
                    Text("Failed")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.bottom,10)
                    Text("The answer is")
                        .font(.title)
                    Text(getAnswer())
                        .font(.title)

                        .foregroundColor(Color.red)
                    }
                }.ignoresSafeArea()
            }

        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}

