Class {
	#name : 'OrchardRepositoryTest',
	#superclass : 'TestCase',
	#category : 'FruitTreesSystem-Tests',
	#package : 'FruitTreesSystem-Tests'
}

{ #category : 'tests' }
OrchardRepositoryTest >> testSaveAndRestoreOrchards [
    | repository orchard1 orchard2 apple apricot restored1 restored2 |

    repository := OrchardRepository new.

    orchard1 := Orchard new.
    orchard1 owner: 'Marta'.

    apple := AppleTree new.
    apple age: 5.
    apple yield: 20.
    orchard1 addTree: apple.

    orchard2 := Orchard new.
    orchard2 owner: 'Maria'.

    apricot := ApricotTree new.
    apricot age: 5.
    apricot yield: 10.
    orchard2 addTree: apricot.

    repository saveOrchard: orchard1 withId: 'garden-1'.
    repository saveOrchard: orchard2 withId: 'garden-2'.

    restored1 := repository orchardWithId: 'garden-1'.
    restored2 := repository orchardWithId: 'garden-2'.

    self assert: restored1 owner equals: 'Marta'.
    self assert: restored1 trees size equals: 1.
    self assert: restored1 totalYield equals: 20.

    self assert: restored2 owner equals: 'Maria'.
    self assert: restored2 trees size equals: 1.
    self assert: restored2 totalYield equals: 10.

    self deny: restored1 == orchard1.
    self assert: (repository orchardWithId: 'missing') isNil

]
