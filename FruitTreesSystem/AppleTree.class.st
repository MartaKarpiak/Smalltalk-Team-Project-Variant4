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
