//
//  helpSheet.swift
//  PZmohjang
//
//  Created by Vikill Blacks on 2023/2/18.
//

import SwiftUI

struct helpSheet: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                helpTitle(titleText: "记分规则")
                Divider().padding(.horizontal)
                Text("邳州麻将在胡牌之后，无论是哪家点炮或者自摸（自摸不翻倍），各家均根据每家胡数进行结算。\n\n胡和幺均为量词，其具体数字可由玩家自行商议确定，本 App 将 1 胡记为 1 分，幺的数量支持自定义设置。\n\n其中：\n一对 +1 胡，\n一坎 +2 胡，\n送杠 +4 胡，\n自杠 +6 胡，\n和牌 +10 胡。")
                    .multilineTextAlignment(.leading)
                    .padding()
                helpTitle(titleText: "额外加分")
                Divider().padding(.horizontal)
                Group {
                    Text("1.")
                        .bold()
                    Text("庄家与别人计算胡数时，乘 2 倍。\n")
                    Text("2.")
                        .bold()
                    Text("飘荤：（和牌且所有牌均为对或坎加一对头子）,飘荤后与别人计算胡数时，乘 2 倍，额外再加 30 胡荤底（庄家飘荤与别人计算胡数时，则乘 4 倍，再额外加上荤底）。\n")
                    Text("3.")
                        .bold()
                    Text("1、9的条、筒和万以及字牌的计算为：\n一对 +2 胡，\n一坎 +4 胡 1 幺，\n送杠 +8 胡 2 幺，\n自杠 +12 胡 3 幺。\n其中，幺对应的胡数每家单独计算，不计入任何翻倍中。")
                }
                .padding(.horizontal)
            }
        }
    }
}

struct helpTitle: View {
    var titleText: String
    var body: some View {
        Text(titleText)
            .font(.largeTitle).bold()
            .padding()
    }
}

struct helpSheet_Previews: PreviewProvider {
    static var previews: some View {
        helpSheet()
    }
}
