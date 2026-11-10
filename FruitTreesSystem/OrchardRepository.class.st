Class {
	#name : 'OrchardRepository',
	#superclass : 'Object',
	#instVars : [
		'savedOrchards'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'initialization' }
OrchardRepository >> initialize [
    super initialize.
    savedOrchards := Dictionary new

]

{ #category : 'as yet unclassified' }
OrchardRepository >> orchardWithId: anId [
    | data orchard |

    data := savedOrchards
        at: anId
        ifAbsent: [ ^ nil ].

    orchard := Orchard new.
    orchard loadFromData: data.

    ^ orchard

]

{ #category : 'as yet unclassified' }
OrchardRepository >> saveOrchard: anOrchard withId: anId [
    savedOrchards
        at: anId
        put: anOrchard asData.

    ^ anId

]
