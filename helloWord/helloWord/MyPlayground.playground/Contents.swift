//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var a = 10

var b:Int = a

let oneMillio = 1_0000_0000

var array = Array<Any>();

array.append("1")

array.append(0)

array.append([1,2]) 

var strc = "1"

//for arrayItem in array {
//    
//    
//    print(arrayItem)
//
//}


array.contains{
    (element) ->Bool in
    if let element:String = "1"{
        print(element);
    }else{
        print(element)
    }
    return true;
}
