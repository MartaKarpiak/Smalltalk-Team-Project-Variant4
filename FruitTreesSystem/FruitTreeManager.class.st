"
Клас для зберігання та керування колекцією фруктових дерев.
"
Class {
	#name : 'FruitTreeManager',
	#superclass : 'Object',
	#instVars : [
		'treesCollection'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'adding' }
FruitTreeManager >> addTree: aTree [
    (aTree isKindOf: FruitTree) ifFalse: [
        self error: 'Only fruit trees can be added'
    ].
    treesCollection add: aTree.
    ^ aTree

]

{ #category : 'adding' }
FruitTreeManager >> addTreeFromDialog [
    | choice tree ageText heightText yieldText |

    choice := UIManager default
        chooseFrom: #('Apple' 'Apricot')
        title: 'Choose fruit tree'.

    (choice isNil or: [ choice = 0 ]) ifTrue: [
        ^ nil
    ].

    tree := choice = 1
        ifTrue: [ AppleTree new ]
        ifFalse: [ ApricotTree new ].

    ageText := UIManager default request: 'Enter age:'.
    ageText ifNil: [ ^ nil ].

    heightText := UIManager default request: 'Enter height in meters:'.
    heightText ifNil: [ ^ nil ].

    yieldText := UIManager default request: 'Enter yield in kg:'.
    yieldText ifNil: [ ^ nil ].

    [
        tree age: ageText asNumber.
        tree height: heightText asNumber.
        tree yield: yieldText asNumber
    ] on: Error do: [
        UIManager default inform: 'Enter valid numbers'.
        ^ nil
    ].

    self addTree: tree.
    ^ tree

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> growAllOneYear [
    treesCollection do: [ :tree |
        tree growOneYear
    ]

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> growAllTwoYears [
    treesCollection do: [ :tree |
        tree growTwoYears
    ]

]

{ #category : 'initialization' }
FruitTreeManager >> initialize [
    super initialize.
    treesCollection := OrderedCollection new

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> loadFromJSONFile: aFileName [
    | file data loadedTrees |

    file := aFileName asFileReference.

    file exists ifFalse: [
        self error: 'File not found'
    ].

    data := file readStreamDo: [ :stream |
        STONJSON fromStream: stream
    ].

    loadedTrees := OrderedCollection new.

    data do: [ :each |
        loadedTrees add: (self treeFromData: each)
    ].

    treesCollection := loadedTrees.

    ^ treesCollection

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> mostProductiveTree [
    | best |

    treesCollection isEmpty ifTrue: [ ^ nil ].

    best := treesCollection first.

    treesCollection do: [ :tree |
        (tree yield > best yield) ifTrue: [
            best := tree
        ]
    ].

    ^ best

]

{ #category : 'printing' }
FruitTreeManager >> printOn: aStream [
    aStream nextPutAll: 'Fruit trees:'; cr.

    treesCollection isEmpty
        ifTrue: [
            aStream nextPutAll: '(empty)'
        ]
        ifFalse: [
            treesCollection do: [ :tree |
                tree printOn: aStream.
                aStream cr
            ]
        ]

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> saveToJSONFile: aFileName [
    | data file |

    data := treesCollection collect: [ :tree |
        self treeAsData: tree
    ].

    file := aFileName asFileReference.

    file writeStreamDo: [ :stream |
        STONJSON
            put: data asArray
            onStreamPretty: stream
    ].

    ^ file

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> tallestTree [
    | tallest |

    treesCollection isEmpty ifTrue: [ ^ nil ].

    tallest := treesCollection first.

    treesCollection do: [ :tree |
        (tree height > tallest height) ifTrue: [
            tallest := tree
        ]
    ].

    ^ tallest

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> topThreeMostProductiveTrees [
    | sorted |

    sorted := treesCollection asSortedCollection: [
        :a :b | a yield >= b yield
    ].

    ^ sorted first: (3 min: sorted size)

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> treeAsData: aTree [
    | data |

    data := Dictionary new.

    data at: 'type' put: aTree class name asString.
    data at: 'age' put: aTree age.
    data at: 'height' put: aTree height.
    data at: 'yield' put: aTree yield.
    data at: 'fruitingAge' put: aTree fruitingAge.

    (aTree isKindOf: AppleTree) ifTrue: [
        data at: 'fruitColor' put: aTree fruitColor
    ].

    (aTree isKindOf: ApricotTree) ifTrue: [
        data at: 'hadFrostDuringFlowering'
            put: aTree hadFrostDuringFlowering
    ].

    ^ data

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> treeFromData: data [
    | type tree |

    type := data at: 'type'.

    tree := type = 'AppleTree'
        ifTrue: [ AppleTree new ]
        ifFalse: [
            type = 'ApricotTree'
                ifTrue: [ ApricotTree new ]
                ifFalse: [
                    self error: 'Unknown tree type'
                ]
        ].

    tree age: (data at: 'age').
    tree height: (data at: 'height').
    tree yield: (data at: 'yield').
    tree fruitingAge: (data at: 'fruitingAge').

    (tree isKindOf: AppleTree) ifTrue: [
        tree fruitColor: (data at: 'fruitColor')
    ].

    (tree isKindOf: ApricotTree) ifTrue: [
        tree hadFrostDuringFlowering:
            (data at: 'hadFrostDuringFlowering')
    ].

    ^ tree

]

{ #category : 'adding' }
FruitTreeManager >> trees [
    ^ treesCollection

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> treesNotTallerThan: maxHeight [
    ^ treesCollection select: [ :tree |
        tree height <= maxHeight
    ]

]

{ #category : 'as yet unclassified' }
FruitTreeManager >> treesOfFruitingAge [
    ^ treesCollection select: [ :tree |
        tree age >= tree fruitingAge
    ]

]
