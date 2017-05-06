import UIKit

struct GridPosition {
    var x:Int
    var y:Int
    
    init() {
        self.x = 0
        self.y = 0
    }
    
    init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }
    
    ///Center based on grid position
    var center:CGPoint {
        let buffer = Values.dotsBuffer * Values.betweenDots + Values.betweenDots/2
        let xPos = x * Values.betweenDots + buffer
        let yPos = y * Values.betweenDots + buffer
        return CGPoint(x: xPos, y: yPos)
    }
}
