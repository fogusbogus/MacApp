import Cocoa

import Foundation


//Logic

class Mandelbrot {
	
	static func generate(width: Int, height: Int) -> [Int] {
		let c = [152,145,146,147,148,149,150,151,145,146,147,148,149,150,152]
		let m1 = 3.5/20.0, m2 = 2.0/22.0
		var ret = Array(repeating: 0, count: width * height)
		var idx = 0
		for py in 0..<width {
			for px in 0..<height {
				let xz = Double(px) * m1 - 2.5
				let yz = Double(py) * m2 - 1
				var x = 0.0, y = 0.0
				for i in 0..<c.count {
					var xt = x*x + y*y
					if xt > 4 {
						ret[idx] = c[i]
						idx += 1
						break
					}
					xt += xz
					y = 2*x*y + yz
					x = xt
				}
			}
		}
		return ret
	}
}


let c = Mandelbrot.generate(width: 21, height: 19)
