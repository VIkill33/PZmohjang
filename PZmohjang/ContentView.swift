//
//  ContentView.swift
//  PZmohjang
//
//  Created by Vikill Blacks on 2023/2/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject var northPlayer = Player(type: .north)
    @StateObject var eastPlayer = Player(type: .east)
    @StateObject var southPlayer = Player(type: .south)
    @StateObject var westPalyer = Player(type: .west)
    @State var currentPlayer: player_type = .north
    @State var isInput = false
    @State var isSetting = false
    @State var isHelp = false
    @AppStorage("score_upbound") var score_upbound: Int = 0
    @AppStorage("yao_ratio") var yao_ratio: Int = 4
    let rectangleWidth = UIScreen.screenWidth / 4
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                HStack {
                    Button(action: {
                        isHelp.toggle()
                    }, label: {
                        Text("\(Image(systemName: "questionmark.circle"))")
                            .font(.title3)
                    })
                    Spacer()
                    Button(action: {
                        isSetting.toggle()
                    }, label: {
                        Text("\(Image(systemName: "gear"))")
                            .font(.title3)
                    })
                }
                .padding([.horizontal, .top])
                Spacer()
                playerButton(playerText: "北", bindingPlayer: northPlayer, isInput: $isInput, currentPlayer: $currentPlayer)
                HStack {
                    playerButton(playerText: "西", bindingPlayer: westPalyer, isInput: $isInput, currentPlayer: $currentPlayer)
                    playerRectangle(bindingPlayer: northPlayer)
                        .opacity(0.0)
                    playerButton(playerText: "东", bindingPlayer: eastPlayer, isInput: $isInput, currentPlayer: $currentPlayer)
                }
                playerButton(playerText: "南", bindingPlayer: southPlayer, isInput: $isInput, currentPlayer: $currentPlayer)
                Spacer()
                Button("下一局") {
                    let playerList = [northPlayer, eastPlayer, southPlayer, westPalyer]
                    setNewHost(playerList: playerList)
                    for player in playerList {
                        player.resetState()
                    }
                }
                calcButton(northPlayer: northPlayer, southPlayer: southPlayer, westPlayer: westPalyer, eastPlayer: eastPlayer, score_upbound: $score_upbound, yao_ratio: $yao_ratio)
                    .padding()
            }
            .ignoresSafeArea(.keyboard)
            if isInput {
                switch currentPlayer {
                case .north:
                    inputBox(bindingPlayer: northPlayer, isInput: $isInput, currentPlayer: $currentPlayer)
                case .east:
                    inputBox(bindingPlayer: eastPlayer, isInput: $isInput, currentPlayer: $currentPlayer)
                case .west:
                    inputBox(bindingPlayer: westPalyer, isInput: $isInput, currentPlayer: $currentPlayer)
                case .south:
                    inputBox(bindingPlayer: southPlayer, isInput: $isInput, currentPlayer: $currentPlayer)
                }
            }
            if isSetting {
                settingBox(isSetting: $isSetting, score_upbound: $score_upbound, yao_ratio: $yao_ratio, northPlayer: northPlayer, southPlayer: southPlayer, westPlayer: westPalyer, eastPlayer: eastPlayer)
            }
        }
        //.environmentObject(northPlayer)
        //.environmentObject(eastPlayer)
        //.environmentObject(southPlayer)
        //.environmentObject(westPalyer)
        .sheet(isPresented: $isHelp) {
            helpSheet()
        }
    }
}

extension ContentView {
    func setNewHost(playerList: [Player]) {
        for i in 0..<4 {
            if i == 0 {
                if playerList[3].isHost {
                    if playerList[3].isWin {
                        return
                    }
                    playerList[3].isHost = false
                    playerList[i].isHost = true
                    return
                }
            } else {
                if playerList[i - 1].isHost {
                    if playerList[i - 1].isWin {
                        return
                    }
                    playerList[i - 1].isHost = false
                    playerList[i].isHost = true
                    return
                }
            }
        }
    }
}

struct inputBox: View {
    @ObservedObject var bindingPlayer: Player
    
    let boxWidth = UIScreen.screenWidth * 0.85
    let boxHeight = UIScreen.screenHeight * 0.345
    @Binding var isInput: Bool
    @Binding var currentPlayer: player_type
    @State var input_hu: String = ""
    @State var input_yao: String = ""
    var body: some View {
        ZStack {
            /*
            Color.gray.opacity(0.3)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            //.ignoresSafeArea()
                .onTapGesture {
                    isInput = false
                }
             */
            Group {
                Color.primary.colorInvert()
                    .mask(
                        RoundedRectangle(cornerRadius: 10.0)
                    )
                    .shadow(color: Color.gray.opacity(0.7), radius: 16.0, y: 16.0)
                VStack {
                    Text(currentPlayer.player_type2String())
                        .font(.largeTitle).bold()
                        .padding()
                    HStack {
                        Text("胡：")
                            .bold()
                        TextField("输入胡数", text: $input_hu)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("幺：")
                            .bold()
                        TextField("输入幺数", text: $input_yao)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Button(action: {
                            bindingPlayer.isHost.toggle()
                        }, label: {
                            HStack {
                                Text("做庄")
                                if bindingPlayer.isHost {
                                    Text("\(Image(systemName: "checkmark.square"))")
                                } else {
                                    Text("\(Image(systemName: "square"))")
                                }
                            }
                        })
                        .padding([.vertical, .trailing])
                        Button(action: {
                            bindingPlayer.isWin.toggle()
                        }, label: {
                            HStack {
                                Text("胡牌")
                                if bindingPlayer.isWin {
                                    Text("\(Image(systemName: "checkmark.square"))")
                                } else {
                                    Text("\(Image(systemName: "square"))")
                                }
                            }
                        })
                        .padding([.vertical, .trailing])
                        Button(action: {
                            bindingPlayer.isPiaohun.toggle()
                        }, label: {
                            HStack {
                                Text("飘荤")
                                if bindingPlayer.isPiaohun {
                                    Text("\(Image(systemName: "checkmark.square"))")
                                } else {
                                    Text("\(Image(systemName: "square"))")
                                }
                            }
                        })
                        .padding(.vertical)
                    }
                    Spacer()
                    Button(action: {
                        if bindingPlayer.hu >= 0 {
                            bindingPlayer.hu = Int(input_hu) ?? 0
                        }
                        if bindingPlayer.yao >= 0 {
                            bindingPlayer.yao = Int(input_yao) ?? 0
                        }
                        isInput = false
                    }, label: {
                        Text("1")
                            .frame(minWidth: 0, maxWidth: 100)
                            .font(.title)
                            .foregroundColor(.white)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.accentColor)
                                    .overlay(Text("完成").font(.callout).bold()
                                        .foregroundColor(.white))
                            })
                        
                    })
                }
                .padding()
            }
            .frame(width: boxWidth, height: boxHeight)
        }
    }
}

struct settingBox: View {
    @Binding var isSetting: Bool
    @Binding var score_upbound: Int
    @Binding var yao_ratio: Int
    @State var input_yao_ratio: String = ""
    @State var input_score_upbound: String = ""
    @State var isUpbound = false
    @ObservedObject var northPlayer: Player
    @ObservedObject var southPlayer: Player
    @ObservedObject var westPlayer: Player
    @ObservedObject var eastPlayer: Player
    let boxWidth = UIScreen.screenWidth * 0.85
    let boxHeight = UIScreen.screenHeight * 0.5
    var body: some View {
        ZStack {
            /*
             Color.gray.opacity(0.3)
             .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
             //.edgesIgnoringSafeArea(.all)
             .onTapGesture {
             isSetting = false
             }
             */
            Color.primary.colorInvert()
                .mask(
                    RoundedRectangle(cornerRadius: 10.0)
                )
                .shadow(color: Color.gray.opacity(0.7), radius: 16.0, y: 16.0)
            VStack {
                Text("设置")
                    .font(.largeTitle).bold()
                    .padding()
                Group {
                    HStack {
                        Text("幺")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    HStack {
                        Text("1 幺 = ")
                            .bold()
                        TextField("", text: $input_yao_ratio)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        Text("胡")
                            .bold()
                    }
                    Divider()
                }
                Group {
                    HStack {
                        Text("封顶")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    HStack {
                        Text("是否封顶")
                            .bold()
                        Toggle("", isOn: $isUpbound)
                    }
                    if isUpbound {
                        HStack {
                            Text("封顶上限 = ")
                                .bold()
                            TextField("", text: $input_score_upbound)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                            Text("胡")
                                .bold()
                        }
                    }
                    Divider()
                }
                Spacer()
                Button(action: {
                    let playerlist: [Player] = [northPlayer, southPlayer, westPlayer, eastPlayer]
                    for player in playerlist {
                        player.reset()
                    }
                }, label: {
                    Text("重置记分")
                        .padding()
                })
                Button(action: {
                    yao_ratio = Int(input_yao_ratio) ?? 0
                    score_upbound = Int(input_score_upbound) ?? 0
                    isSetting = false
                }, label: {
                    Text("1")
                        .frame(minWidth: 0, maxWidth: 100)
                        .font(.title)
                        .foregroundColor(.white)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.accentColor)
                                .overlay(Text("完成").font(.callout).bold()
                                    .foregroundColor(.white))
                        })
                })
            }
            .padding()
        }
        .frame(width: boxWidth, height: boxHeight)
        .onAppear {
            input_yao_ratio = String(yao_ratio)
            if score_upbound > 0 {
                isUpbound = true
                input_score_upbound = String(score_upbound)
            }
        }
        .onChange(of: isUpbound, perform: { _ in
            if !isUpbound {
                score_upbound = 0
                input_score_upbound = ""
            }
        })
    }
}

struct calcButton: View {
    @ObservedObject var northPlayer: Player
    @ObservedObject var southPlayer: Player
    @ObservedObject var westPlayer: Player
    @ObservedObject var eastPlayer: Player
    @Binding var score_upbound: Int
    @Binding var yao_ratio: Int
    var body: some View {
        Button(action: {
            var error_flag = false
            let playerlist: [Player] = [northPlayer, southPlayer, westPlayer, eastPlayer]
            var win_count = 0
            var host_count = 0
            for player in playerlist {
                if player.isWin {
                    win_count += 1
                }
                if player.isHost {
                    host_count += 1
                }
            }
            if win_count != 1 || host_count != 1 {
                error_flag = true
            }
            print(error_flag)
            if !error_flag {
                calculateScore()
            }
        }, label: {
            Text("1")
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.largeTitle)
                .foregroundColor(.white)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor)
                        .overlay(Text("开始计算").font(.title2).bold()
                            .foregroundColor(.white))
                })
        })
    }
}

extension calcButton {
    func calculateScore() {
        let playerlist: [Player] = [northPlayer, southPlayer, westPlayer, eastPlayer]
        for player in playerlist {
            for calc_player in playerlist.filter({$0.id != player.id}) {
                var temp_score = 0
                if calc_player.isWin {
                    temp_score += 10
                }
                if player.isWin {
                    temp_score -= 10
                }
                temp_score += calc_player.hu
                temp_score -= player.hu
                // 庄家翻倍
                if calc_player.isHost || player.isHost {
                    temp_score *= 2
                }
                // 飘昏翻倍，额外加30底分
                if calc_player.isPiaohun {
                    temp_score *= 2
                    temp_score += 30
                }
                if player.isPiaohun {
                    temp_score *= 2
                    temp_score -= 30
                }
                // 幺分单独计算，不计入翻倍
                temp_score += calc_player.yao * yao_ratio
                temp_score -= player.yao * yao_ratio
                // 封顶
                if score_upbound > 0 && abs(temp_score) > score_upbound {
                    temp_score = score_upbound
                }
                
                calc_player.score += temp_score
            }
        }
    }
}

struct playerButton: View {
    var playerText: String = ""
    @ObservedObject var bindingPlayer: Player
    @Binding var isInput: Bool
    @Binding var currentPlayer: player_type
    var body: some View {
        Button(action: {
            isInput = true
            currentPlayer = bindingPlayer.type
            print(currentPlayer)
        }, label: {
            playerRectangle(playerText: playerText, bindingPlayer: bindingPlayer)
        })
    }
}

struct playerRectangle: View {
    var playerText: String = ""
    @ObservedObject var bindingPlayer: Player
    // let rectangleWidth = UIScreen.screenWidth / 3.5
    let rectangleWidth = 100.0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(bindingPlayer.isHost ? Color.orange : Color.accentColor)
                .frame(width:rectangleWidth, height: rectangleWidth)
            Text(playerText)
                .font(.largeTitle).bold()
                .foregroundColor(bindingPlayer.isWin ? .red : .accentColor)
            VStack {
                HStack {
                    Text("\(bindingPlayer.score) 分")
                    Spacer()
                    Text("\(bindingPlayer.hu) 胡")
                }
                Spacer()
                HStack {
                    if bindingPlayer.isPiaohun {
                        Text("飘")
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                HStack {
                    if bindingPlayer.isWin {
                        Text("胡")
                            .foregroundColor(.red)
                    }
                    if bindingPlayer.isHost  {
                        Text("庄")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    if bindingPlayer.yao > 0 {
                        Text("\(bindingPlayer.yao * 4)胡\(bindingPlayer.yao)幺")
                    }
                }
            }
            .padding(5.0)
        }
        .frame(width: rectangleWidth, height: rectangleWidth)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
