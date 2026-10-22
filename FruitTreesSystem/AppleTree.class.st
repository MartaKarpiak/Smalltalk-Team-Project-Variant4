"
Клас яблуні. Зберігає інформацію про колір плодів та має специфічне плодоношення.
"
Class {
	#name : 'AppleTree',
	#superclass : 'FruitTree',
	#instVars : [
		'fruitColor'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'as yet unclassified' }
AppleTree class >> fruitBearingAge [
    ^ 3
]

{ #category : 'as yet unclassified' }
AppleTree class >> name: aName age: anAge height: aHeight yield: aYield color: aColor [
    ^ (self name: aName age: anAge height: aHeight yield: aYield)
        color: aColor;
        yourself.
]

{ #category : 'testing' }
AppleTree >> canBearFruit [
    ^ (super canBearFruit) and: [
        (age - fruitingAge) even
    ]

]

{ #category : 'accessing' }
AppleTree >> fruitColor [
    ^ fruitColor
]

{ #category : 'accessing' }
AppleTree >> fruitColor: aString [
    fruitColor := aString
]

{ #category : 'initialization' }
AppleTree >> initialize [
    super initialize.
    speciesName := 'Apple'.
    fruitColor := 'Red'

]
