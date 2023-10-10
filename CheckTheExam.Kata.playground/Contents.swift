import UIKit

func checkTheExam(correct: [String], answered: [String]) -> Int {
	
	var result = 0
	
	(0..<correct.count).forEach { index in
		if !(answered[index].isEmpty) {
			
			if answered[index] == correct[index] {
				result += 4
			}
			else {
				result -= 1
			}
			
		}
	}
	return result < 0 ? 0 : result
	
}

print(checkTheExam(correct: ["a", "a", "b", "b"], answered: ["a", "c", "b", "d"]))
