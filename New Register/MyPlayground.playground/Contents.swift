import Cocoa


var baseUrl = "https://geographic.org/streetview/uk/Stroud_District/index.html"

var relUrl = "https://geographic.org/streetview/uk/Stroud_District/"

func getCoordinate( addressString : String,
					completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
	let geocoder = CLGeocoder()
	geocoder.geocodeAddressString(addressString) { (placemarks, error) in
		if error == nil {
			if let placemark = placemarks?[0] {
				let location = placemark.location!
				
				completionHandler(location.coordinate, nil)
				return
			}
		}
		
		completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
	}
}

getCoordinate(addressString: "Stroud, Whiteshill, Main Road") { loc, err in
	if let err = err {
		print(err)
	}
	else {
		print(loc)
	}
}

func getWebpage(url: String) -> [(String, String)] {
	if let uri = URL(string: url) {
		do {
			let contents = try String(contentsOf: uri)
			return contents.splitToArray("<li><a href=\"").filter({ s in
				return !s.starts(with: "<")
			}).map { s -> (String, String) in
				let link = s.before("\"")
				let name = s.after(">").before("<")
				return (link, name)
			}
		}
		catch {
			
		}
	}
	return []
}

extension String {
func before(_ sequence: String, returnAllWhenMissing: Bool = false) -> String {
	if !self.contains(sequence) {
		if returnAllWhenMissing {
			return self
		}
		return ""
	}
	
	let end = index((range(of: sequence)?.upperBound)!, offsetBy: -1)
	let start = self.startIndex
	return String(self[start ..< end])
}
	
	func length(encoding: String.Encoding = .utf8) -> Int {
		return lengthOfBytes(using: encoding)
	}
	

func after(_ sequence: String, returnAllWhenMissing: Bool = false) -> String {
	if !self.contains(sequence) {
		if returnAllWhenMissing {
			return self
		}
		return ""
	}
	
	let start = index((range(of: sequence)?.upperBound)!, offsetBy: 0)
	let end = self.endIndex
	return String(self[start ..< end])
}

func splitToArray(_ splitter: String) -> [String] {
	
	var ret : [String] = []
	if !self.contains(splitter) {
		return [self]
	}
	
	var text = self
	var cand = text.before(splitter)
	
	while text.length() > 0 {
		text = text.after(splitter)
		ret.append(cand)
		cand = text.before(splitter, returnAllWhenMissing: true)
	}
	if cand.length() > 0 {
		ret.append(cand)
	}
	return ret
}
}

var areas = getWebpage(url: baseUrl)

var streets : [(String, String, String, String)] = []
//while areas.count > 2 {
//	areas.removeLast()
//}
//
areas.forEach { tup in
	let (html, title) = tup
	let sts = getWebpage(url: relUrl + html)
	sts.forEach { tup2 in
		print("Stroud, \(title), \(tup2.1)")
		var done = false
		streets.append((title, tup2.1, "", ""))
//		getCoordinate(addressString: "Stroud, \(title), \(tup2.1)") { loc, err in
//			if let err = err {
//				print(err)
//				streets.append((title, tup2.1, "", ""))
//			}
//			else {
//				streets.append((title, tup2.1, String(describing: loc.latitude), String(describing: loc.longitude)))
//			}
//			done = true
//		}
//		while (!done) {
//		}
//		sleep(3)

	}
}

print(streets)

var text = streets.map { kvp in
	return "\"\(kvp.0)\",\"\(kvp.1)\"\n" //,\"\(kvp.2)\",\"\(kvp.3)\"\n"
}.joined()

if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
	
	let fileURL = dir.appendingPathComponent("streets.csv")
	
	//writing
	do {
		try text.write(to: fileURL, atomically: false, encoding: .utf8)
	}
	catch {/* error handling here */}
}
