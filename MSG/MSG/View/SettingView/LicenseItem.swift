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
    LicenseItem(name: "Lottie Simple License (FL 9.13.21)",
                text: """
                Copyright © 2021 Design Barn Inc.

                Permission is hereby granted, free of charge, to any person obtaining a copy of the public animation files available for download at the LottieFiles site (“Files”) to download, reproduce, modify, publish, distribute, publicly display, and publicly digitally perform such Files, including for commercial purposes, provided that any display, publication, performance, or distribution of Files must contain (and be subject to) the same terms and conditions of this license. Modifications to Files are deemed derivative works and must also be expressly distributed under the same terms and conditions of this license. You may not purport to impose any additional or different terms or conditions on, or apply any technical measures that restrict exercise of, the rights granted under this license. This license does not include the right to collect or compile Files from LottieFiles to replicate or develop a similar or competing service.

                Use of Files without attributing the creator(s) of the Files is permitted under this license, though attribution is strongly encouraged. If attributions are included, such attributions should be visible to the end user.

                FILES ARE PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. EXCEPT TO THE EXTENT REQUIRED BY APPLICABLE LAW, IN NO EVENT WILL THE CREATOR(S) OF FILES OR DESIGN BARN, INC. BE LIABLE ON ANY LEGAL THEORY FOR ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL, PUNITIVE, OR EXEMPLARY DAMAGES ARISING OUT OF THIS LICENSE OR THE USE OF SUCH FILES.
                """
               ),
]
