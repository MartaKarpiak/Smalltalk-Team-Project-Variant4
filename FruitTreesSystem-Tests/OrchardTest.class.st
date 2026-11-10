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
OrchardTest >> testTotalYield [
    self assert: orchard totalYield equals: 30.
]
