//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let swiftTeam = 13
let iOSTeam = 54
let otherTeams = 48
var totalTeam = swiftTeam + iOSTeam + otherTeams
totalTeam += 1

let priceInferred = 19.99
let priceExplicit: Double = 19.99

let onSaleInferred = true
let onsaleExpleicit: Bool = false

let nameInferred = "Whoopie Cushion"

if onSaleInferred
{
    print("\(nameInferred) on sale for \(priceInferred)!")
} else
{
    print("\(nameInferred) at regular price: \(priceInferred)!")
}