//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
//使用protocol 来声明一个协议。
protocol ExampleProtocal{
    var simpleDesp:String{get}
    mutating func adjust()
    
}
//类、枚举和结构体都可以实现协议。
class SimpleClass: ExampleProtocal{
    var simpleDesp: String = "A simple class"
    var anotherProperty:Int = 45621
    func adjust() {
        simpleDesp += " NO 100% adjusted"
    }
    
}
/*
//注意声明SimpleStructure 时候mutating 关键字用来标记一个会修改结构体的方法。SimpleClass 的声明不需要
标记任何方法，因为类中的方法通常可以修改类属性（类的性质）。
使用extension 来为现有的类型添加功能，比如新的方法和计算属性。你可以使用扩展在别处修改定义，甚至是
从外部库或者框架引入的一个类型，使得这个类型遵循某个协议。
 */
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
//你可以像使用其他命名类型一样使用协议名——例如，创建一个有不同类型但是都实现一个协议的对象􀔀合。当你处理类型是协议的值时，协议外定义的方法不可用。
let protocolValue : ExampleProtocal = simple
print(protocolValue.simpleDesp)
//即使protocolValue 变量运行时的类型是simpleClass ，编译器会把它的类型当做ExampleProtocol 。这表示你不能调用类在它实现的协议之外实现的方法或者属性。
//print(protocolValue.anotherProperty) // 去掉注释可以看到错误

*/

enum PrinterError:Error{
    case OutOfPaper
    case NoToner
    case NoFile
}
//使用throw 来抛出一个错误并使用throws 来表示一个可以抛出错误的函数。如果在函数中抛出一个错误，这个函数会立刻返回并且调用该函数的代码会进行错误处理。
func send(job:Int,toPrinter printerName:String)throws ->String{
    if printerName == "Never Has Toner"{
        throw PrinterError.NoToner
    }
    return "Job sent"
}

//有多种方式可以用来进行错误处理。一种方式是使用do-catch 。在do 代码块中，使用try 来标记可以抛出错误的代码。在catch 代码块中，除非你另外命名，否则错误会自动命名为error 。
do {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
    
} catch {
    print(error)
}

do {
    let printerResponse = try send(job: 1440, toPrinter: "GutenBerg")
    print(printerResponse)
    
} catch PrinterError.NoFile {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

//另一种处理错误的方式使用try? 将结果转换为可选的。如果函数抛出错误，该错误会被抛弃并且结果为nil 。否则的话，结果会是一个包含函数返回值的可选值。
let printerSuccess = try?send(job: 1885, toPrinter: "Mergenthaler")
let printerFailure = try?send(job: 1884, toPrinter: "Never Has Toner")

//使用defer 代码块来表示在函数返回前，函数中最后执行的代码。无论函数是否会抛出错误，这段代码都将执行。使用defer ，可以把函数调用之初就要执行的代码和函数调用结束时的扫尾代码写在一起，虽然这两者的执行时机截然不同。
var fridgeIsOpen = false
let fridgeConten = ["milk","eggs","leftovers"]
func fridgeContains(_ food:String)->Bool{
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }
    let result  = fridgeConten.contains(food)
    return result
}

fridgeContains("banana")
print(fridgeIsOpen)



