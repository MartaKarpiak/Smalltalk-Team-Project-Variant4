"
Клас абрикоса. Враховує заморозки під час цвітіння.
"
Class {
	#name : 'ApricotTree',
	#superclass : 'FruitTree',
	#instVars : [
		'hadFrostDuringFlowering'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'as yet unclassified' }
ApricotTree class >> fruitBearingAge [
    ^ 3
]

{ #category : 'as yet unclassified' }
ApricotTree class >> name: aName age: anAge height: aHeight yield: aYield hadFrosts: aBoolean [
    ^ (self name: aName age: anAge height: aHeight yield: aYield)
        hadFrosts: aBoolean;
        yourself.
]

{ #category : 'as yet unclassified' }
ApricotTree >> currentHarvest [
    | normalHarvest |
    normalHarvest := super currentHarvest.

    ^ hadFrostDuringFlowering
        ifTrue: [ normalHarvest * 0.2 ]
        ifFalse: [ normalHarvest ]

]

{ #category : 'accessing' }
ApricotTree >> hadFrostDuringFlowering [
    ^ hadFrostDuringFlowering

]

{ #category : 'accessing' }
ApricotTree >> hadFrostDuringFlowering: aBoolean [
    hadFrostDuringFlowering := aBoolean

]

{ #category : 'initialization' }
ApricotTree >> initialize [
    super initialize.
    speciesName := 'Apricot'.
    hadFrostDuringFlowering := false

]
