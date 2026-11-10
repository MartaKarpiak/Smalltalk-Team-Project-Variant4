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
OrchardTest >> testFindTrees [
    | twoYearOldApples |
    twoYearOldApples := orchard findTreesOfClass: AppleTree withCharacteristic: [ :t | t age = 2 ].
    self assert: twoYearOldApples size equals: 1.
]

{ #category : 'tests' }
OrchardTest >> testPassYear [
    orchard passYear.
    self assert: appleTree age equals: 3.
    self assert: orchard totalYield equals: 90. 
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
