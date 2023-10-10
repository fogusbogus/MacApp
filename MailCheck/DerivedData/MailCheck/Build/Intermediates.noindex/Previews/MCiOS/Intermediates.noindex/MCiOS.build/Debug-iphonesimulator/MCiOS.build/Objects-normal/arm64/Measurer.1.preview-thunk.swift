@_private(sourceFile: "Measurer.swift") import MCiOS
import SwiftUI
import SwiftUI

extension Measurer_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/Measurer.swift", line: 52)
        Measurer()
    
#sourceLocation()
    }
}

extension Measurer {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/Measurer.swift", line: 43)
		MeasureView(id: __designTimeString("#186216.[3].[2].property.[0].[0].arg[0].value", fallback: ""), delegate: self) {
			Text(/*@START_MENU_TOKEN@*/__designTimeString("#186216.[3].[2].property.[0].[0].arg[2].value.[0].arg[0].value", fallback: "Hello, World!")/*@END_MENU_TOKEN@*/)
				.frame(width: width * __designTimeInteger("#186216.[3].[2].property.[0].[0].arg[2].value.[0].modifier[0].arg[0].value.[0]", fallback: 2))
		}
    
#sourceLocation()
    }
}

extension Measurer {
    @_dynamicReplacement(for: sizeChanged(_:)) private func __preview__sizeChanged(_ newSize: CGSize) {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/Measurer.swift", line: 37)
		print(newSize.width)
	
#sourceLocation()
    }
}

extension MeasureView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/Measurer.swift", line: 22)
		GeometryReader { geo in
			Group(content: content)
				.onAppear {
					delegate.sizeChanged(geo.size)
				}
		}
	
#sourceLocation()
    }
}

import struct MCiOS.MeasureView
import protocol MCiOS.MeasureViewSizeChangeDelegate
import struct MCiOS.Measurer
import struct MCiOS.Measurer_Previews
