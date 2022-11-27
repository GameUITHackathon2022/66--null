extends Node

var maxValue: int = 100

var awarenessPoint: int = 100 setget setAwareness, getAwareness
var moneyPoint: int = 0 setget setMoney, getMoney

func setAwareness(value):
	if awarenessPoint + value <= 100 and awarenessPoint + value >= 0:
		awarenessPoint += value

func getAwareness():
	return awarenessPoint

func setMoney(value):
	if moneyPoint + value <= 100 and moneyPoint + value >= 0:
		moneyPoint += value

func getMoney():
	return moneyPoint
