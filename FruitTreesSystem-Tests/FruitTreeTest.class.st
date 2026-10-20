"
Клас для модульних тестів фруктових дерев.
"
Class {
	#name : 'FruitTreeTest',
	#superclass : 'TestCase',
	#category : 'FruitTreesSystem-Tests',
	#package : 'FruitTreesSystem-Tests'
}

{ #category : 'tests' }
FruitTreeTest >> testAppleFruitingCycle [
    | apple |

    apple := AppleTree new.

    apple age: 2.
    self deny: apple canBearFruit.

    apple age: 3.
    self assert: apple canBearFruit.

    apple age: 4.
    self deny: apple canBearFruit.

    apple age: 5.
    self assert: apple canBearFruit

]

{ #category : 'tests' }
FruitTreeTest >> testApricotFrost [
    | apricot |

    apricot := ApricotTree new.
    apricot age: 5.
    apricot yield: 20.

    self assert: apricot currentHarvest equals: 20.

    apricot hadFrostDuringFlowering: true.

    self assert: apricot currentHarvest equals: 4.

    apricot hadFrostDuringFlowering: false.

    self assert: apricot currentHarvest equals: 20

]

{ #category : 'tests' }
FruitTreeTest >> testFruitTreeInitialization [
    | tree |

    tree := FruitTree new.

    self assert: tree speciesName equals: 'Fruit tree'.
    self assert: tree age equals: 0.
    self assert: tree height equals: 0.
    self assert: tree yield equals: 0.
    self assert: tree fruitingAge equals: 3

]

{ #category : 'tests' }
FruitTreeTest >> testJSONSaveAndLoad [
    | manager loaded apple apricot fileName file |

    fileName := 'fruit-trees-test-', UUID new asString, '.json'.
    file := fileName asFileReference.

    [
        manager := FruitTreeManager new.

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

        manager addTree: apple.
        manager addTree: apricot.

        manager saveToJSONFile: fileName.

        loaded := FruitTreeManager new.
        loaded loadFromJSONFile: fileName.

        self assert: loaded trees size equals: 2.

        self assert:
            (loaded trees first speciesName)
            equals: 'Apple'.

        self assert:
            (loaded trees first fruitColor)
            equals: 'Green'.

        self assert:
            (loaded trees first age)
            equals: 5.

        self assert:
            (loaded trees second speciesName)
            equals: 'Apricot'.

        self assert:
            (loaded trees second hadFrostDuringFlowering).

        self assert:
            (loaded trees second yield)
            equals: 15.

    ] ensure: [
        file exists ifTrue: [ file delete ]
    ]

]

{ #category : 'tests' }
FruitTreeTest >> testManagerAddsTrees [
    | manager apple apricot |

    manager := FruitTreeManager new.
    apple := AppleTree new.
    apricot := ApricotTree new.

    manager addTree: apple.
    manager addTree: apricot.

    self assert: manager trees size equals: 2.
    self assert: (manager trees first == apple).
    self assert: (manager trees second == apricot)

]

{ #category : 'tests' }
FruitTreeTest >> testManagerFindsTallestAndMostProductive [
    | manager apple apricot |

    manager := FruitTreeManager new.

    apple := AppleTree new.
    apple height: 2.5.
    apple yield: 25.

    apricot := ApricotTree new.
    apricot height: 3.2.
    apricot yield: 15.

    manager addTree: apple.
    manager addTree: apricot.

    self assert: (manager tallestTree == apricot).
    self assert: (manager mostProductiveTree == apple)

]

{ #category : 'tests' }
FruitTreeTest >> testManagerGrowAll [
    | manager apple apricot |

    manager := FruitTreeManager new.

    apple := AppleTree new.
    apple age: 1.

    apricot := ApricotTree new.
    apricot age: 2.

    manager addTree: apple.
    manager addTree: apricot.

    manager growAllOneYear.

    self assert: apple age equals: 2.
    self assert: apricot age equals: 3.

    manager growAllTwoYears.

    self assert: apple age equals: 4.
    self assert: apricot age equals: 5

]

{ #category : 'tests' }
FruitTreeTest >> testManagerSelectsByHeight [
    | manager apple1 apple2 apricot selected |

    manager := FruitTreeManager new.

    apple1 := AppleTree new.
    apple1 height: 2.

    apple2 := AppleTree new.
    apple2 height: 2.5.

    apricot := ApricotTree new.
    apricot height: 3.5.

    manager addTree: apple1.
    manager addTree: apple2.
    manager addTree: apricot.

    selected := manager treesNotTallerThan: 2.5.

    self assert: selected size equals: 2.
    self assert: (selected first == apple1).
    self assert: (selected second == apple2)

]

{ #category : 'tests' }
FruitTreeTest >> testManagerTopThree [
    | manager |

    manager := FruitTreeManager new.

    #(10 40 30 20) do: [ :amount |
        | tree |
        tree := AppleTree new.
        tree yield: amount.
        manager addTree: tree
    ].

    self
        assert: ((manager topThreeMostProductiveTrees
            collect: [ :tree | tree yield ]) asArray)
        equals: #(40 30 20)

]
