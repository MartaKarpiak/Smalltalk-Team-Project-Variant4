Class {
	#name : 'Orchard',
	#superclass : 'Object',
	#instVars : [
		'owner',
		'trees',
		'treeManager'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'adding' }
Orchard >> addTree: aTree [
    ^ treeManager addTree: aTree

]

{ #category : 'converting' }
Orchard >> asData [
    | data |

    data := Dictionary new.

    data at: 'owner' put: owner.

    data at: 'trees' put:
        (trees collect: [ :tree |
            treeManager treeAsData: tree
        ]) asArray.

    ^ data

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
    ^ treeManager
        findTreesOfClass: aClass
        withCharacteristic: aBlock

]

{ #category : 'initialization' }
Orchard >> initialize [
    super initialize.
    treeManager := FruitTreeManager new.
    trees := treeManager trees

]

{ #category : 'as yet unclassified' }
Orchard >> loadFromData: data [
    self initialize.

    owner := data at: 'owner' ifAbsent: [ nil ].

    (data at: 'trees' ifAbsent: [ #() ]) do: [ :treeData |
        self addTree: (treeManager treeFromData: treeData)
    ].

    ^ self

]

{ #category : 'as yet unclassified' }
Orchard >> loadFromJSONFile: aFileName [
    | file data |

    file := aFileName asFileReference.

    file exists ifFalse: [
        self error: 'File not found'
    ].

    data := file readStreamDo: [ :stream |
        STONJSON fromStream: stream
    ].

    self loadFromData: data.

    ^ self

]

{ #category : 'as yet unclassified' }
Orchard >> loadFromSTONFile: aFileName [
    | file data |

    file := aFileName asFileReference.

    file exists ifFalse: [
        self error: 'File not found'
    ].

    data := file readStreamDo: [ :stream |
        STON fromStream: stream
    ].

    self loadFromData: data.

    ^ self

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
    treeManager growAllOneYear

]

{ #category : 'printing' }
Orchard >> printOn: aStream [
    aStream
        nextPutAll: 'Сад власника: ';
        nextPutAll: (owner
            ifNil: [ 'Не вказано' ]
            ifNotNil: [ owner asString ]);
        cr;
        nextPutAll: 'Кількість дерев: ';
        print: trees size;
        cr.

    trees do: [ :tree |
        aStream
            nextPutAll: '- ';
            print: tree;
            cr
    ].

    aStream
        nextPutAll: 'Загальний урожай: ';
        print: self totalYield;
        nextPutAll: ' кг'

]

{ #category : 'as yet unclassified' }
Orchard >> promptToRemoveOldTrees [
    | oldTrees |

    oldTrees := self treesOlderThan: 20.

    oldTrees isEmpty ifTrue: [ ^ 0 ].

    (UIManager default confirm:
        'У саду є старі дерева (вік > 20). Бажаєте їх викорчувати?')
        ifFalse: [ ^ 0 ].

    ^ self removeTreesOlderThan: 20

]

{ #category : 'removing' }
Orchard >> removeTree: aFruitTree [
    ^ treeManager removeTree: aFruitTree

]

{ #category : 'removing' }
Orchard >> removeTreesOlderThan: anAge [
    | oldTrees |

    oldTrees := self treesOlderThan: anAge.

    oldTrees do: [ :tree |
        self removeTree: tree
    ].

    ^ oldTrees size

]

{ #category : 'as yet unclassified' }
Orchard >> saveToJSONFile: aFileName [
    | file |

    file := aFileName asFileReference.

    file writeStreamDo: [ :stream |
        STONJSON put: self asData onStream: stream
    ].

    ^ file

]

{ #category : 'as yet unclassified' }
Orchard >> saveToSTONFile: aFileName [
    | file |

    file := aFileName asFileReference.

    file writeStreamDo: [ :stream |
        STON put: self asData onStream: stream
    ].

    ^ file

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

{ #category : 'as yet unclassified' }
Orchard >> treesOlderThan: anAge [
    ^ trees select: [ :tree |
        tree age > anAge
    ]

]
