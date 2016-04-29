/*
*   Copyright (c) 2016 Oleh Kulykov <info@resident.name>
*
*   Permission is hereby granted, free of charge, to any person obtaining a copy
*   of this software and associated documentation files (the "Software"), to deal
*   in the Software without restriction, including without limitation the rights
*   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*   copies of the Software, and to permit persons to whom the Software is
*   furnished to do so, subject to the following conditions:
*
*   The above copyright notice and this permission notice shall be included in
*   all copies or substantial portions of the Software.
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*   THE SOFTWARE.
*/


import UIKit


internal enum OKAlertControllerElementType: Int {
	case Title
	case Message
	case Background
	case AllDefaultActions
	case AllCancelActions
	case AllDestructiveActions
	case Shadow
	case Border
}

extension SequenceType {
	@warn_unused_result
	public func findFirst(@noescape includeElement: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
		for element in self {
			if includeElement(element) {
				return element
			}
		}
		return nil
	}
}
/*
extension Array {

	// Returns the first element satisfying the predicate, or `nil`
	// if there is no matching element.
	func findFirstMatching<L : BooleanType>(predicate: T -> L) -> T? {
		for item in self {
			if predicate(item) {
				return item // found
			}
		}
		return nil // not found
	}
}
*/
internal class OKAlertControllerElement {

	typealias ElementType = OKAlertControllerElementType
	typealias Param = OKAlertControllerParam
	typealias ParamType = OKAlertControllerParamType

	let type: ElementType
	let tag: Int
	var params: [Param]

	var key: String {
		return "\(tag)"
	}

	func checkLabel(label: UILabel) -> Bool {
		if let text = label.text {
			let dstText: String = self[.Text]?.getValue() ?? ""
			if label.tag == tag || text == key || text == dstText {
				label.tag = tag
				label.attributedText = attributedString // assigning a new a value updates the values in the font, textColor
				return true
			}
		}
		return false
	}

	var attributedString: NSAttributedString {
		var text: String?
		var attributes = [String : AnyObject](minimumCapacity: 2)
		for param in params {
			switch param.type {
			case .Text:
				text = param.getValue()
			case .Color:
				if let color: UIColor = param.getValue() {
					attributes[NSForegroundColorAttributeName] = color
				}
			case .Font:
				if let font: UIFont = param.getValue() {
					attributes[NSFontAttributeName] = font
				}
			default:
				continue
			}
		}
		return NSAttributedString(string: text ?? "", attributes: attributes)
	}

	subscript(type: ParamType) -> Param? {
		return params.findFirst({ $0.type == type })
	}

	init(type: ElementType, tag: Int) {
		self.type = type
		self.tag = tag
		self.params = []
	}

	init(type: ElementType, tag: Int, param: Param) {
		self.type = type
		self.tag = tag
		self.params = [param]
	}
}
