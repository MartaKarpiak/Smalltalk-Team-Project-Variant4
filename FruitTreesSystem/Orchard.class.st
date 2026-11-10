Class {
	#name : 'Orchard',
	#superclass : 'Object',
	#instVars : [
		'owner',
		'trees'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'adding' }
Orchard >> addTree: aFruitTree [
    trees add: aFruitTree.
]

{ #category : 'as yet unclassified' }
Orchard >> checkFrostDamage: temperature [
    trees do: [ :tree |
        tree isDamagedByFrost: (temperature < 0).

        (tree isKindOf: ApricotTree) ifTrue: [
            tree hadFrostDuringFlowering: (temperature < 0)
        ]
    ]

]

{ #category : 'as yet unclassified' }
Orchard >> findTreesOfClass: aClass withCharacteristic: aBlock [
    ^ (trees select: [ :tree | tree isKindOf: aClass ]) select: aBlock.
]

{ #category : 'initialization' }
Orchard >> initialize [
    super initialize.
    trees := OrderedCollection new.
]

{ #category : 'accessing' }
Orchard >> owner [
    ^ owner
]

{ #category : 'accessing' }
Orchard >> owner: aString [
    owner := aString.
]

{ #category : 'as yet unclassified' }
Orchard >> passYear [
    trees do: [ :each | each growOneYear ]
]

{ #category : 'printing' }
Orchard >> printOn: aStream [
    aStream 
        nextPutAll: 'Сад власника: '; nextPutAll: owner asString;
        nextPutAll: '. Кількість дерев: '; print: trees size.
]

{ #category : 'as yet unclassified' }
Orchard >> promptToRemoveOldTrees [
    | oldTrees |
    oldTrees := trees select: [ :tree | tree age > 20 ].
    oldTrees ifNotEmpty: [
        (UIManager default confirm: 'У саду є старі дерева (вік > 20). Бажаєте їх викорчувати?')
            ifTrue: [ trees removeAll: oldTrees ] ].
]

{ #category : 'removing' }
Orchard >> removeTree: aFruitTree [
    trees remove: aFruitTree ifAbsent: [].
]

{ #category : 'accessing' }
Orchard >> totalYield [
    ^ trees inject: 0 into: [ :sum :tree |
        sum + tree currentHarvest
    ]

]

{ #category : 'accessing' }
Orchard >> trees [
    ^ trees
]
