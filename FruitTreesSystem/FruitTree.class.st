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

{ #category : 'as yet unclassified' }
FruitTree class >> fruitBearingAge [
    ^ 3
]

{ #category : 'accessing' }
FruitTree class >> name: aName age: anAge height: aHeight yield: aYield [
    ^ self new
        name: aName;
        age: anAge;
        height: aHeight;
        yield: aYield;
        yourself.
]

{ #category : 'arithmetic' }
FruitTree >> * anotherTree [
    ^ self yield * anotherTree yield

]

{ #category : 'arithmetic' }
FruitTree >> + anotherTree [
    ^ self yield + anotherTree yield

]

{ #category : 'arithmetic' }
FruitTree >> - anotherTree [
    ^ self yield - anotherTree yield

]

{ #category : 'arithmetic' }
FruitTree >> / anotherTree [
    ^ self yield / anotherTree yield

]

{ #category : 'comparing' }
FruitTree >> < anotherTree [
    ^ self yield < anotherTree yield

]

{ #category : 'comparing' }
FruitTree >> <= anotherTree [
    ^ self yield <= anotherTree yield

]

{ #category : 'comparing' }
FruitTree >> = anotherTree [
    (anotherTree isKindOf: FruitTree) ifFalse: [
        ^ false
    ].
    ^ self yield = anotherTree yield

]

{ #category : 'comparing' }
FruitTree >> > anotherTree [
    ^ self yield > anotherTree yield

]

{ #category : 'comparing' }
FruitTree >> >= anotherTree [
    ^ self yield >= anotherTree yield

]

{ #category : 'accessing' }
FruitTree >> age [
    ^ age
]

{ #category : 'accessing' }
FruitTree >> age: anAge [
    age := anAge asInteger.
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

{ #category : 'comparing' }
FruitTree >> hash [
    ^ self yield hash

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
]

{ #category : 'testing' }
FruitTree >> isFruiting [
    ^ age >= self class fruitingAge
]

{ #category : 'printing' }
FruitTree >> printOn: aStream [
    aStream
        nextPutAll: self speciesName;
        nextPutAll: ' (age: ';
        nextPutAll: self age asString;
        nextPutAll: ', height: ';
        nextPutAll: self height asString;
        nextPutAll: ' m, yield: ';
        nextPutAll: self yield asString;
        nextPutAll: ' kg)'

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
