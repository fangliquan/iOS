//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol ExampleProtocal{
    var simpleDesp:String{get}
    mutating func adjust()
    
}
class SimpleClass: ExampleProtocal{
    var simpleDesp: String = "A simple class"
    var anotherProperty:Int = 45621
    func adjust() {
        simpleDesp += " NO 100% adjusted"
    }
    
}

var simple = SimpleClass()
simple.adjust()

let aDesp = simple.simpleDesp

struct SimpleStructure:ExampleProtocal{
    var simpleDesp: String = "A simple structure"
    mutating func adjust() {
        simpleDesp += "(adjusted)"
    }
    
}
var b = SimpleStructure()
b.adjust()
let bDesp = b.simpleDesp

extension Int:ExampleProtocal {
    var simpleDesp :String {
        return "The number\(self)"
    }
    mutating func adjust() {
        self += 42
    }
    
}

print(7.simpleDesp)

		