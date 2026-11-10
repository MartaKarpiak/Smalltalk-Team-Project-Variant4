Class {
	#name : 'OrchardTest',
	#superclass : 'TestCase',
	#instVars : [
		'orchard',
		'appleTree',
		'apricotTree'
	],
	#category : 'FruitTreesSystem-Tests',
	#package : 'FruitTreesSystem-Tests'
}

{ #category : 'running' }
OrchardTest >> setUp [
    super setUp.
    orchard := Orchard new.
    orchard owner: 'Марія'.
    
    appleTree := AppleTree new.
    appleTree age: 2; yield: 50. 
    
    apricotTree := ApricotTree new.
    apricotTree age: 4; yield: 30. 
    
    orchard addTree: appleTree.
    orchard addTree: apricotTree.
]

{ #category : 'tests' }
OrchardTest >> testCheckFrostDamage [
    | orchard apricot |

    orchard := Orchard new.

    apricot := ApricotTree new.
    apricot age: 5.
    apricot yield: 10.

    orchard addTree: apricot.

    self assert: orchard totalYield equals: 10.

    orchard checkFrostDamage: -2.

    self assert: apricot hadFrostDuringFlowering.
    self assert: orchard totalYield equals: 2.

    orchard checkFrostDamage: 5.

    self deny: apricot hadFrostDuringFlowering.
    self assert: orchard totalYield equals: 10

]

{ #category : 'tests' }
OrchardTest >> testEmptyOrchard [
    | orchard restored |

    orchard := Orchard new.

    self assert: orchard trees isEmpty.
    self assert: orchard totalYield equals: 0.
    self assert: (orchard treesOlderThan: 20) isEmpty.

    restored := Orchard new.
    restored loadFromData: orchard asData.

    self assert: restored trees isEmpty.
    self assert: restored totalYield equals: 0

]

{ #category : 'tests' }
OrchardTest >> testFindTrees [
    | twoYearOldApples |
    twoYearOldApples := orchard findTreesOfClass: AppleTree withCharacteristic: [ :t | t age = 2 ].
    self assert: twoYearOldApples size equals: 1.
]

{ #category : 'tests' }
OrchardTest >> testFindTreesWithCharacteristic [
    | orchard apple1 apple2 apricot found |

    orchard := Orchard new.

    apple1 := AppleTree new.
    apple1 age: 2.

    apple2 := AppleTree new.
    apple2 age: 5.

    apricot := ApricotTree new.
    apricot age: 6.

    orchard addTree: apple1.
    orchard addTree: apple2.
    orchard addTree: apricot.

    found := orchard
        findTreesOfClass: AppleTree
        withCharacteristic: [ :tree | tree age >= 4 ].

    self assert: found size equals: 1.
    self assert: (found first == apple2).
    self assert: orchard trees size equals: 3

]

{ #category : 'tests' }
OrchardTest >> testOrchardDataRoundTrip [
    | orchard restored apple apricot |

    orchard := Orchard new.
    orchard owner: 'Marta'.

    apple := AppleTree new.
    apple age: 5.
    apple yield: 20.
    apple fruitColor: 'Green'.

    apricot := ApricotTree new.
    apricot age: 4.
    apricot yield: 15.

    orchard addTree: apple.
    orchard addTree: apricot.

    restored := Orchard new.
    restored loadFromData: orchard asData.

    self assert: restored owner equals: 'Marta'.
    self assert: restored trees size equals: 2.

    self assert: restored trees first class equals: AppleTree.
    self assert: restored trees second class equals: ApricotTree.

    self assert: restored trees first fruitColor equals: 'Green'.
    self assert: restored totalYield equals: 35.

    restored loadFromData: orchard asData.
    self assert: restored trees size equals: 2

]

{ #category : 'tests' }
OrchardTest >> testOrchardJSONSaveAndLoad [
    | orchard restored apple apricot file |

    orchard := Orchard new.
    orchard owner: 'Marta'.

    apple := AppleTree new.
    apple age: 5.
    apple height: 2.5.
    apple yield: 20.
    apple fruitColor: 'Green'.

    apricot := ApricotTree new.
    apricot age: 4.
    apricot height: 3.
    apricot yield: 15.

    orchard addTree: apple.
    orchard addTree: apricot.

    file := 'orchard-test-roundtrip.json' asFileReference.

    [
        orchard saveToJSONFile: file fullName.

        self assert: file exists.

        restored := Orchard new.
        restored loadFromJSONFile: file fullName.

        self assert: restored owner equals: 'Marta'.
        self assert: restored trees size equals: 2.

        self assert: restored trees first class equals: AppleTree.
        self assert: restored trees second class equals: ApricotTree.

        self assert: restored trees first fruitColor equals: 'Green'.
        self assert: restored totalYield equals: 35.

        restored addTree: AppleTree new.
        self assert: restored trees size equals: 3
    ] ensure: [
        file exists ifTrue: [ file delete ]
    ]

]

{ #category : 'tests' }
OrchardTest >> testOrchardPrinting [
    | orchard apple apricot text |

    orchard := Orchard new.
    orchard owner: 'Marta'.

    apple := AppleTree new.
    apple age: 5.
    apple height: 2.5.
    apple yield: 20.

    apricot := ApricotTree new.
    apricot age: 4.
    apricot height: 3.
    apricot yield: 15.

    orchard addTree: apple.
    orchard addTree: apricot.

    text := orchard printString.

    self assert: (text includesSubstring: 'Marta').
    self assert: (text includesSubstring: 'Кількість дерев: 2').
    self assert: (text includesSubstring: 'Apple').
    self assert: (text includesSubstring: 'Apricot').
    self assert: (text includesSubstring: '35 кг')

]

{ #category : 'tests' }
OrchardTest >> testOrchardSTONSaveAndLoad [
    | orchard restored apple apricot file |

    orchard := Orchard new.
    orchard owner: 'Marta'.

    apple := AppleTree new.
    apple age: 5.
    apple height: 2.5.
    apple yield: 20.
    apple fruitColor: 'Green'.

    apricot := ApricotTree new.
    apricot age: 4.
    apricot height: 3.
    apricot yield: 15.
    apricot hadFrostDuringFlowering: true.

    orchard addTree: apple.
    orchard addTree: apricot.

    file := 'orchard-test-roundtrip.ston' asFileReference.

    [
        orchard saveToSTONFile: file fullName.

        self assert: file exists.

        restored := Orchard new.
        restored loadFromSTONFile: file fullName.

        self assert: restored owner equals: 'Marta'.
        self assert: restored trees size equals: 2.

        self assert: restored trees first class equals: AppleTree.
        self assert: restored trees second class equals: ApricotTree.

        self assert: restored trees first fruitColor equals: 'Green'.
        self assert: restored trees second hadFrostDuringFlowering.

        self assert: restored totalYield equals: 23.

        restored addTree: AppleTree new.
        self assert: restored trees size equals: 3
    ] ensure: [
        file exists ifTrue: [ file delete ]
    ]

]

{ #category : 'tests' }
OrchardTest >> testPassYear [
    orchard passYear.
    self assert: appleTree age equals: 3.
    self assert: orchard totalYield equals: 90. 
]

{ #category : 'tests' }
OrchardTest >> testRemoveTreeByIdentity [
    | orchard apple apricot |

    orchard := Orchard new.

    apple := AppleTree new.
    apple yield: 20.

    apricot := ApricotTree new.
    apricot yield: 20.

    orchard addTree: apple.
    orchard addTree: apricot.

    orchard removeTree: apricot.

    self assert: orchard trees size equals: 1.
    self assert: (orchard trees first == apple).
    self deny: (orchard trees anySatisfy: [ :each |
        each == apricot
    ])

]

{ #category : 'tests' }
OrchardTest >> testRemoveTreesOlderThan [
    | orchard oldTree youngTree boundaryTree |

    orchard := Orchard new.

    oldTree := AppleTree new.
    oldTree age: 25.
    oldTree yield: 20.

    youngTree := ApricotTree new.
    youngTree age: 5.
    youngTree yield: 20.

    boundaryTree := AppleTree new.
    boundaryTree age: 20.
    boundaryTree yield: 20.

    orchard addTree: oldTree.
    orchard addTree: youngTree.
    orchard addTree: boundaryTree.

    self assert: (orchard treesOlderThan: 20) size equals: 1.
    self assert: (orchard removeTreesOlderThan: 20) equals: 1.

    self assert: orchard trees size equals: 2.

    self deny: (orchard trees anySatisfy: [ :tree |
        tree == oldTree
    ]).

    self assert: (orchard trees anySatisfy: [ :tree |
        tree == youngTree
    ]).

    self assert: (orchard trees anySatisfy: [ :tree |
        tree == boundaryTree
    ])

]

{ #category : 'tests' }
OrchardTest >> testTotalYieldWithFrostAndFruitingCycle [
    | orchard apple apricot |

    orchard := Orchard new.

    apple := AppleTree new.
    apple age: 4.
    apple yield: 20.

    apricot := ApricotTree new.
    apricot age: 5.
    apricot yield: 10.
    apricot hadFrostDuringFlowering: true.

    orchard addTree: apple.
    orchard addTree: apricot.

    self assert: orchard totalYield equals: 2

]
