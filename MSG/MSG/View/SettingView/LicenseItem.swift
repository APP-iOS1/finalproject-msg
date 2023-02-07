//
//  LicenseItem.swift
//  MSG
//
//  Created by zooey on 2023/02/07.
//

import Foundation

struct LicenseItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var text: String
}

var licenseListItem: [LicenseItem] = [
    LicenseItem(name: "mapleStoryLight",
                text: """
                Copyright 2023 NEXON Korea Corpoation
                
                - 제공되는 모든 서체의 지적 재산권을 포함한 모든 권리는 (주)넥슨코리아에 있습니다.
                
                - 서체는 개인 및 기업 사용자를 포함한 모든 사용자에게 무료로 제공되며 자유롭게 사용 및 배포하실 수 있습니다.(상업적인 용도로 사용 가능)
                    단, 임의로 수정, 편집 등을 할 수 없으며 배포되는 형태 그대로 사용해야 합니다.
                
                - 글꼴 자체를 유로로 판매하는 것음 금지되며, 서체의 본 저작권 안내를 포함해서 다른 소프트웨어와 번들하거다 임베디드 폰트로 사용하실 수 있습니다.
                
                - 서체의 출처 표기를 권장합니다.
                
                - 서체를 사용한 인쇄물, 광고물(온라인 포함)은 넥슨의 프로모션을 위해 활용될 수 있습니다.
                """
               ),
    LicenseItem(name: "mapleStoryBold",
                text: """
                Copyright 2023 NEXON Korea Corpoation
                
                - 제공되는 모든 서체의 지적 재산권을 포함한 모든 권리는 (주)넥슨코리아에 있습니다.
                
                - 서체는 개인 및 기업 사용자를 포함한 모든 사용자에게 무료로 제공되며 자유롭게 사용 및 배포하실 수 있습니다.(상업적인 용도로 사용 가능)
                    단, 임의로 수정, 편집 등을 할 수 없으며 배포되는 형태 그대로 사용해야 합니다.
                
                - 글꼴 자체를 유로로 판매하는 것음 금지되며, 서체의 본 저작권 안내를 포함해서 다른 소프트웨어와 번들하거다 임베디드 폰트로 사용하실 수 있습니다.
                
                - 서체의 출처 표기를 권장합니다.
                
                - 서체를 사용한 인쇄물, 광고물(온라인 포함)은 넥슨의 프로모션을 위해 활용될 수 있습니다.
                """
               ),
]
