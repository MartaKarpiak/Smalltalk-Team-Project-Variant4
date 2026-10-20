"
Базовий клас для всіх фруктових дерев у системі. Містить спільні властивості: назву, вік, висоту, урожайність та вік початку плодоношення.
"
Class {
	#name : 'FruitTree',
	#superclass : 'Object',
	#instVars : [
		'speciesName',
		'age',
		'height',
		'yield',
		'fruitingAge'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'accessing' }
FruitTree >> age [
    ^ age
]

{ #category : 'accessing' }
FruitTree >> age: aNumber [
    age := aNumber
]

{ #category : 'testing' }
FruitTree >> canBearFruit [
    ^ age >= fruitingAge
]

{ #category : 'as yet unclassified' }
FruitTree >> currentHarvest [
    ^ self canBearFruit
        ifTrue: [ self yield ]
        ifFalse: [ 0 ]

]

{ #category : 'accessing' }
FruitTree >> fruitingAge [
    ^ fruitingAge
]

{ #category : 'accessing' }
FruitTree >> fruitingAge: aNumber [
    fruitingAge := aNumber
]

{ #category : 'as yet unclassified' }
FruitTree >> growOneYear [
    age := age + 1.
    height := height + 0.3.
    self canBearFruit ifTrue: [
        yield := yield + 5
    ]
]

{ #category : 'as yet unclassified' }
FruitTree >> growTwoYears [
    self growOneYear.
    self growOneYear
]

{ #category : 'accessing' }
FruitTree >> height [
    ^ height
]

{ #category : 'accessing' }
FruitTree >> height: aNumber [
    height := aNumber
]

{ #category : 'initialization' }
FruitTree >> initialize [
    super initialize.
    speciesName := 'Fruit tree'.
    age := 0.
    height := 0.
    yield := 0.
    fruitingAge := 3
]

{ #category : 'accessing' }
FruitTree >> speciesName [
    ^ speciesName
]

{ #category : 'accessing' }
FruitTree >> speciesName: aString [
    speciesName := aString
]

{ #category : 'accessing' }
FruitTree >> yield [
    ^ yield
]

{ #category : 'accessing' }
FruitTree >> yield: aNumber [
    yield := aNumber
]
