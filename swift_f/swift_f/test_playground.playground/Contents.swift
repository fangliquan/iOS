//: Playground - noun: a place where people can play

import UIKit

/*
var str = "Hello, playground"
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble = 70

let label = "this width is"
let width = 94;
let widthLabel = label + String(width)

let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples"
let fruitSummary = "I have \(apples + oranges) pieces of fruit。"
*/

/*
 注意let 在上述例子的等式中是如何使用的，它将匹配等式的值赋给常量x 。
 运行switch 中匹配到的子句之后，程序会退出switch 语句，并不会继续向下运行，所以不需要在每个子句结尾
 写break 。

 */

/*
let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raiins and make ants on a log");
case "cucumber","watercreess":
    print("That would make a good tea sandwich");
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)");
default:
    print("Everything tastes good in soup")
}

 */


/*
 你可以使用for-in 来遍历字典，需要两个变量来表示每个键值对。字典是一个无序的􀔀合，所以他们的键和值以
 任意顺序迭代结束。
 */
/*
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]

var largest = 0
var largestKind = "";
var largestKindArray = [Int]()
for (kind,numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            largestKind = kind;
            largestKindArray.insert(number, at: largestKindArray.count);
        }
    }
}
print("最大的值\(largest)")

print("最大的值\(largestKind)")

print(largestKindArray)

*/

/*
 可以在循环中使用..< 来表示范围
 使用..< 创建的范围不包含上界，如果想包含的话需要使用... 。
 */

/*
var total = 0
for i in 0...4{
    total += i;
}
print(total)


//函数和闭包
//使用func 来声明一个函数，使用名字和参数来调用函数。使用-> 来指定函数返回值的类型


func great( person:String,day :String) ->String{
    return "Hello \(person),today is \(day)"
}
//默认情况下，函数使用它们的参数名称作为它们参数的标签，在参数名称前可以自定义参数标签，或者使用_表示不使用参数标签。
func greaton(_ person:String,on day :String) ->String{
    return "Hello \(person),today is \(day)"
}
great(person: "", day: "")

greaton("John", on: "Sunday")

 */

//使用元组来让一个函数返回多个值。该元组的元素可以用名称或数字来表示。
/*
func calculateStatistics(scores:[Int]) ->(min:Int,max:Int,sum:Int){
    var minInt = scores[0]
    var maxInt = scores[0]
    var sum = 0
    
    for score in scores {
        if score>maxInt {
            maxInt = score
        }else if score<minInt{
            minInt = score
        }
        sum+=score
    }
    return(minInt,maxInt,sum)
}

let statistics = calculateStatistics(scores: [3,4,567,89,99])

print(statistics.sum)

print(statistics.max)

print(statistics.min)

print(statistics.2)
*/
//函数可以带有可变个数的参数，这些参数在函数内表现为数组的形式：

/*
func sumOf(numbers:Int...)->Int{
    var sum = 0;
    for number in numbers {
        sum+=number
    }
    return sum
}

sumOf(numbers: 34,56,78)

sumOf()

//函数可以嵌套。被嵌套的函数可以访问外侧函数的变量，你可以使用嵌套函数来重构一个太长或者太复杂的函数。
func returnFifteen()->Int{
    var y = 10
    func add(){
        y+=10
    }
    add();
    return y;
}
returnFifteen()
//函数是第一等类型，这意味着函数可以作为另一个函数的返回值。
func makeIncrementer()->((Int) ->Int){
    func addOne(number:Int)->Int{
        return 1+number
    }
    return addOne
}

var increment = makeIncrementer()

increment(10)

//函数也可以当做参数传入另一个函数

func hasAnyMatches(list:[Int],condition:(Int) ->Bool)->Bool{
    for item in list {
        if condition(item) {
            return true;
        }
    }
    return false;
}

func lessThanTen(number:Int)->Bool{
    return number<10
}

var numbers = [20,19,6,12]

hasAnyMatches(list: numbers, condition: lessThanTen)

/*
 
 函数实际上是一种特殊的闭包:它是一段能之后被调取的代码。闭包中的代码能访问闭包所建作用域中能得到的变
 量和函数，即使闭包是在一个不同的作用域被执行的 - 你已经在嵌套函数例子中所看到。你可以使用{} 来创建
 一个匿名闭包。使用in 将参数和返回值类型声明与闭包函数体进行分离。
 */

numbers.map { (number :Int) -> Int in
    let result = 3*number;
    return result;
}

print(numbers)

//有很多种创建更简洁的闭包的方法。如果一个闭包的类型已知，比如作为一个回调函数，你可以忽略参数的类型
//和返回值。单个语句闭包会把它语句的值当做结果返回。
let mappedNumbers = numbers.map({number in 3*number})

print(mappedNumbers)


/*
 你可以通过参数位置而不是参数名字来引用参数——这个方法在非常短的闭包中非常有用。当一个闭包作为最后
 一个参数传给一个函数的时候，它可以直接跟在括号后面。当一个闭包是传给函数的唯一参数，你可以完全忽略
 括号。
 */
let sortedNumbers = numbers.sort{$0>$1}
print(sortedNumbers)
 
 */

//对象和类

/*
 使用class 和类名来创建一个类。类中属性的声明和常量、变量声明一样，唯一的区别就是它们的上下文是
 类。同样，方法和函数声明也一样。
 */

/*
class Shape{
    var numberOfSize = 0
    func simpleDescription() -> String {
      return"A shape with \(numberOfSize) sides."
    }
    
    func simpleDescription(str:String) -> String {
        return"A shape with \(numberOfSize) sides."
    }

}
//要创建一个类的实例，在类名后面加上括号。使用点语法来访问实例的属性和方法。
var shape = Shape()
shape.numberOfSize = 7
var shapeDescription = shape.simpleDescription()

class NameShape{
    var numberOfSides:Int = 0
    var name:String
    init(name:String) {
        self.name = name;
    }
    func simpleDescription() -> String {
        return"A shape with \(numberOfSides)"
    }
}

/*
 注意self 被用来区别实例变量。当你创建实例的时候，像传入函数参数一样给类传入构造器的参数。每个属性都
 需要赋值——无论是通过声明（就像numberOfSides ）还是通过构造器（就像name ）。
 如果你需要在删除对象之前进行一些清理工作，使用deinit 创建一个析构函数。
 子类的定义方法是在它们的类名后面加上父类的名字，用冒号分割。创建类的时候并不需要一个标准的根类，所
 以你可以忽略父类。
 子类如果要重写父类的方法的话，需要用override 标记——如果没有添加override 就重写父类方法的话编译器
 会报错。编译器同样会检测override 标记的方法是否确实在父类中
 
 */

class Square:NameShape{
    
    var sideLength:Double = 0.0;
   
    init(sideLength:Double,name:String) {
        
        super.init(name: name)
        self.sideLength = sideLength
        numberOfSides = 4
     }
    func area() -> Double {
        return sideLength*sideLength
    }
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)"
    }
}

let test = Square(sideLength: 5.2, name: "my test square")

test.area()
test.simpleDescription()

//除了储存简单的属性之外，属性可以有 getter 和 setter 。

class EquilateralTriangle:NameShape{
    var sideLength: Double = 0.0
    init(sideLength:Double,name:String) {
        super.init(name: name)
        self.sideLength = sideLength;
        numberOfSides = 3
    }
    
    var perimeter :Double{
        get{
            return 3.0 * sideLength
         }
        set{
            sideLength = newValue/3.0
        }
    }
    
    override func simpleDescription() -> String {
        return "an equilateral triagle with sides of length \(sideLength)."
    }
}

var triangle  = EquilateralTriangle(sideLength: 3.1, name: "a triangle")

print(triangle.perimeter)

triangle.perimeter = 9.9

print(triangle.sideLength)

/*
在perimeter 的 setter 中，新值的名字是newValue 。你可以在set 之后显式的设置一个名字。
注意EquilateralTriangle 类的构造器执行了三步：
1. 设置子类声明的属性值
2. 调用父类的构造器
3. 改变父类定义的属性值。其他的工作比如调用方法、getters 和 setters 也可以在这个阶段完成。
如果你不需要计算属性，但是仍然需要在设置一个新值之前或者之后运行代码，使用willSet 和didSet 。

 */

class TriangleAndSquare {
    var triangle: EquilateralTriangle {
       willSet {
           square.sideLength = newValue.sideLength
        }
    }
    var square:Square{
        willSet{
            triangle.sideLength = newValue.sideLength
        }
    }
    
    init(size:Double,name:String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
    
}

var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")

print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")

print(triangleAndSquare.triangle.sideLength)


/*
 处理变量的可选值时，你可以在操作（比如方法、属性和子脚本）之前加? 。如果? 之前的值是nil ， ? 后面
 的东西都会被忽略，并且整个表达式返回nil 。否则， ? 之后的东西都会被运行。在这两种情况下，整个表达式
 的值也是一个可选值。
 */

let optionalSquare:Square? = Square(sideLength: 2.5, name: "optional Square")

let sideLength = optionalSquare?.sideLength


*/

//枚举和结构体
//使用enum 来创建一个枚举。就像类和其他所有命名类型一样，枚举可以包含方法。

enum Rank: Int{
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case.Jack:
            return "jack"
        case.Queen:
            return "queen"
        case.King:
            return "king"
            
        default:
            return String(self.rawValue)
        }
    }
}

let ace = Rank.Ace
let aceRawValue = ace.rawValue
let kingRawValue = Rank.King.rawValue

let queenString = Rank.simpleDescription(.Jack)
print(queenString())

/*
 默认情况下，Swift 按照从 0 开始每次加 1 的方式为原始值进行赋值，不过你可以通过显式赋值进行改变。在
 上面的例子中， Ace 被显式赋值为 1，并且剩下的原始值会按照顺序赋值。你也可以使用字符串或者浮点数作为
 枚举的原始值。使用rawValue 属性来访问一个枚举成员的原始值。
 使用init?(rawValue:) 初始化构造器在原始值和枚举值之间进行转换。
 */
if let convertedRank = Rank(rawValue: 3){
    let threeDescription = convertedRank.simpleDescription()
}


//枚举的成员值是实际值，并不是原始值的另一种表达方法。实际上，如果没有比较有意义的原始值，你就不需要提供原始值。

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
    func color() -> String {
        switch self {
        case .Spades:
            return "balck"
        case .Hearts:
            return "red"
        case .Diamonds:
            return "red"
        case .Clubs:
            return "black"
        }
    }
}
let hearts = Suit.Hearts
let heartsDescription = hearts.simpleDescription()

let heartsColor = hearts.color()
let shapeColor = Suit.Clubs.color()

/*
 注意，有两种方式可以引用Hearts 成员：给hearts 常量赋值时，枚举成员Suit.Hearts 需要用全名来引用，因
 为常量没有显式指定类型。在switch 里，枚举成员使用缩写.Hearts 来引用，因为self 的值已经知道是一个su
 it 。已知变量类型的情况下你可以使用缩写。
 一个枚举成员的实例可以有实例值。相同枚举成员的实例可以有不同的值。创建实例的时候传入值即可。实例值
 和原始值是不同的：枚举成员的原始值对于所有实例都是相同的，而且你是在定义枚举的时候设置原始值。
 */

//例如，考虑从服务器获取日出和日落的时间。服务器会返回正常结果或者错误信息。
enum ServerResponse{
    case Reasult(String,String)
    case Failure(String)
}

let success = ServerResponse.Reasult("6:00pm", "8:09pm")
let failure = ServerResponse.Failure("Out of cheese")

switch success {
case let .Reasult(sunrise,sunset):
    let serRepsonse = "Sunrise is at\(sunrise) and sunset is at\(sunset)"

case let .Failure(message):
    print("Failure....\(message)")
}


//注意日升和日落时间是如何从ServerResponse 中提取到并与switch 的case 相匹配的。

//使用struct 来创建一个结构体。结构体和类有很多相同的地方，比如方法和构造器。它们之间最大的一个区别就是结构体是传值，类是传引用。

struct Card{
    var rank :Rank
    var suit :Suit
    func sampleDesp() -> String{
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
    
}

let threeOfSpades = Card(rank: .Three, suit: .Spades)

let  threeOfSpadesDesp = threeOfSpades.sampleDesp()

let threeOfRank = threeOfSpades.rank.hashValue



		