"
Клас для модульних тестів фруктових дерев.
"
Class {
	#name : 'FruitTreeTest',
	#superclass : 'TestCase',
	#category : 'FruitTreesSystem-Tests',
	#package : 'FruitTreesSystem-Tests'
}

{ #category : 'tests - manager' }
FruitTreeTest >> testAddTreeRejectsNonTree [
	| manager |
	manager := FruitTreeManager new.

	self should: [ manager addTree: 42 ] raise: Error.
	self assert: manager trees isEmpty

]

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

{ #category : 'tests - growth' }
FruitTreeTest >> testAppleYieldGrowsOnlyInFruitingYears [
	| apple |
	apple := AppleTree new.
	apple age: 2.

	apple growOneYear.
	self assert: apple age equals: 3.
	self assert: apple yield equals: 5.

	apple growOneYear.
	self assert: apple age equals: 4.
	self assert: apple yield equals: 5.

	apple growOneYear.
	self assert: apple age equals: 5.
	self assert: apple yield equals: 10

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

{ #category : 'tests - growth' }
FruitTreeTest >> testApricotNoHarvestBeforeFruitingAge [
	| apricot |
	apricot := ApricotTree new.
	apricot age: 1.
	apricot yield: 20.

	self assert: apricot currentHarvest equals: 0.

	apricot hadFrostDuringFlowering: true.
	self assert: apricot currentHarvest equals: 0

]

{ #category : 'tests - arithmetic' }
FruitTreeTest >> testArithmeticOperators [
	| big small |
	big := AppleTree new yield: 20; yourself.
	small := ApricotTree new yield: 15; yourself.

	self assert: big + small equals: 35.
	self assert: big - small equals: 5.
	self assert: big * small equals: 300.
	self assert: big / small equals: 4 / 3

]

{ #category : 'tests - comparing' }
FruitTreeTest >> testComparisonOperators [
	| big small sameAsBig |
	big := AppleTree new yield: 20; yourself.
	small := ApricotTree new yield: 15; yourself.
	sameAsBig := ApricotTree new yield: 20; yourself.

	self assert: big > small.
	self assert: small < big.
	self assert: big >= sameAsBig.
	self assert: big <= sameAsBig.
	self assert: big = sameAsBig.
	self deny: big = small.
	self deny: big = 20

]

{ #category : 'tests - persistence' }
FruitTreeTest >> testDefaultManagerActsAsInMemoryDatabase [
	| first second |
	FruitTreeManager reset.

	[
		first := FruitTreeManager default.
		first addTree: AppleTree new.

		second := FruitTreeManager default.

		self assert: first == second.
		self assert: second trees size equals: 1.

		FruitTreeManager reset.

		self deny: FruitTreeManager default == first.
		self assert: FruitTreeManager default trees isEmpty
	] ensure: [
		FruitTreeManager reset ]

]

{ #category : 'tests - demo' }
FruitTreeTest >> testDemoSampleManager [
	| manager |
	manager := FruitTreeDemo sampleManager.

	self assert: manager trees size equals: 4.
	self assert: (manager trees count: [ :tree | tree isKindOf: AppleTree ]) equals: 2.
	self assert: (manager trees count: [ :tree | tree isKindOf: ApricotTree ]) equals: 2.
	self assert: manager tallestTree height equals: 3.2.
	self assert: manager treesOfFruitingAge size equals: 3

]

{ #category : 'tests - manager' }
FruitTreeTest >> testEmptyManager [
	| manager |
	manager := FruitTreeManager new.

	self assert: manager trees isEmpty.
	self assert: manager tallestTree isNil.
	self assert: manager mostProductiveTree isNil.
	self assert: manager topThreeMostProductiveTrees isEmpty.
	self assert: (manager treesNotTallerThan: 10) isEmpty.
	self assert: manager treesOfFruitingAge isEmpty

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

{ #category : 'tests - growth' }
FruitTreeTest >> testGrowOneYearBeforeFruitingAge [
	| tree |
	tree := FruitTree new.
	tree height: 1.

	tree growOneYear.

	self assert: tree age equals: 1.
	self assert: (tree height closeTo: 1.3).
	self assert: tree yield equals: 0

]

{ #category : 'tests - growth' }
FruitTreeTest >> testGrowOneYearReachingFruitingAge [
	| tree |
	tree := FruitTree new.
	tree age: 2.
	tree yield: 10.

	tree growOneYear.

	self assert: tree age equals: 3.
	self assert: tree canBearFruit.
	self assert: tree yield equals: 15

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

{ #category : 'tests - printing' }
FruitTreeTest >> testPrintOn [
	| apple |
	apple := AppleTree new.
	apple age: 5.
	apple height: 2.5.
	apple yield: 20.

	self
		assert: apple printString
		equals: 'Apple (age: 5, height: 2.5 m, yield: 20 kg)'

]

{ #category : 'tests - persistence' }
FruitTreeTest >> testSTONSaveAndLoad [
	| manager loaded apple apricot fileName file |
	fileName := 'fruit-trees-test-' , UUID new asString , '.ston'.
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

		manager saveToSTON: fileName.

		loaded := FruitTreeManager new.
		loaded loadFromSTON: fileName.

		self assert: loaded trees size equals: 2.

		self assert: loaded trees first class equals: AppleTree.
		self assert: loaded trees first fruitColor equals: 'Green'.
		self assert: loaded trees first age equals: 5.
		self assert: loaded trees first height equals: 2.5.

		self assert: loaded trees second class equals: ApricotTree.
		self assert: loaded trees second hadFrostDuringFlowering.
		self assert: loaded trees second yield equals: 15.
		self assert: (loaded trees second currentHarvest closeTo: 3)
	] ensure: [
		file exists ifTrue: [ file delete ] ]

]

{ #category : 'tests - manager' }
FruitTreeTest >> testTreesOfFruitingAge [
	| manager young old result |
	manager := FruitTreeManager new.
	young := ApricotTree new age: 1; yourself.
	old := AppleTree new age: 5; yourself.
	manager addTree: young.
	manager addTree: old.

	result := manager treesOfFruitingAge.

	self assert: result size equals: 1.
	self assert: result first == old

]
