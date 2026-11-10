"
Діалог введення характеристик нового дерева. Набір полів залежить від типу: для яблуні - колір плодів, для абрикоса - заморозки під час цвітіння.
"
Class {
	#name : 'TreeEditorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'typeLabel',
		'typeList',
		'nameLabel',
		'nameInput',
		'ageLabel',
		'ageInput',
		'heightLabel',
		'heightInput',
		'yieldLabel',
		'yieldInput',
		'colorLabel',
		'colorInput',
		'frostCheckBox'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'accessing' }
TreeEditorPresenter >> ageInput [
	^ ageInput

]

{ #category : 'building' }
TreeEditorPresenter >> buildTree [
	"Створює дерево з введених даних. Повертає nil, якщо числові поля некоректні"
	| treeClass age height yield tree name |
	treeClass := self selectedTreeClass.
	age := self parseNumber: ageInput text.
	height := self parseNumber: heightInput text.
	yield := self parseNumber: yieldInput text.
	(age isNil or: [ height isNil or: [ yield isNil ] ]) ifTrue: [ ^ nil ].
	(age < 0 or: [ height < 0 or: [ yield < 0 ] ]) ifTrue: [ ^ nil ].

	tree := treeClass new.
	name := (nameInput text ifNil: [ '' ]) asString trimBoth.
	name isEmpty ifFalse: [ tree speciesName: name ].
	tree age: age.
	tree height: height.
	tree yield: yield.

	treeClass = AppleTree ifTrue: [
		| color |
		color := (colorInput text ifNil: [ '' ]) asString trimBoth.
		color isEmpty ifFalse: [ tree fruitColor: color ] ].

	treeClass = ApricotTree ifTrue: [
		tree hadFrostDuringFlowering: frostCheckBox state ].

	^ tree

]

{ #category : 'accessing' }
TreeEditorPresenter >> colorInput [
	^ colorInput

]

{ #category : 'initialization' }
TreeEditorPresenter >> connectPresenters [
	typeList whenSelectedItemChangedDo: [ :treeClass |
		self updateLayoutFor: treeClass ]

]

{ #category : 'layout' }
TreeEditorPresenter >> defaultLayout [
	^ self layoutForTreeClass: self selectedTreeClass

]

{ #category : 'layout' }
TreeEditorPresenter >> extraFieldsFor: aClass [
	"Поля, які показуються лише для певного типу дерева"
	^ aClass = ApricotTree
		ifTrue: [ { frostCheckBox } ]
		ifFalse: [ { colorLabel. colorInput } ]

]

{ #category : 'accessing' }
TreeEditorPresenter >> frostCheckBox [
	^ frostCheckBox

]

{ #category : 'accessing' }
TreeEditorPresenter >> heightInput [
	^ heightInput

]

{ #category : 'initialization' }
TreeEditorPresenter >> initializePresenters [
	typeLabel := self newLabel label: 'Тип дерева:'; yourself.
	typeList := self newDropList.
	typeList
		items: { AppleTree. ApricotTree };
		display: [ :treeClass | OrchardPresenter displayNameOfTreeClass: treeClass ].
	typeList selectItem: AppleTree.

	nameLabel := self newLabel label: 'Назва (сорт):'; yourself.
	nameInput := self newTextInput.

	ageLabel := self newLabel label: 'Вік, років:'; yourself.
	ageInput := self newTextInput text: '0'; yourself.

	heightLabel := self newLabel label: 'Висота, м:'; yourself.
	heightInput := self newTextInput text: '1.0'; yourself.

	yieldLabel := self newLabel label: 'Урожайність, кг:'; yourself.
	yieldInput := self newTextInput text: '0'; yourself.

	colorLabel := self newLabel label: 'Колір плодів:'; yourself.
	colorInput := self newTextInput text: 'Червоний'; yourself.

	frostCheckBox := self newCheckBox
		label: 'Були заморозки під час цвітіння (урожай -80%)';
		yourself

]

{ #category : 'layout' }
TreeEditorPresenter >> layoutForTreeClass: aClass [

	| layout |
	layout := SpGridLayout new.
	layout beColumnNotHomogeneous.
	layout
		add: typeLabel atPoint: 1 @ 1;
		add: typeList atPoint: 2 @ 1;
		add: nameLabel atPoint: 1 @ 2;
		add: nameInput atPoint: 2 @ 2;
		add: ageLabel atPoint: 1 @ 3;
		add: ageInput atPoint: 2 @ 3;
		add: heightLabel atPoint: 1 @ 4;
		add: heightInput atPoint: 2 @ 4;
		add: yieldLabel atPoint: 1 @ 5;
		add: yieldInput atPoint: 2 @ 5.
	aClass = ApricotTree
		ifTrue: [ layout add: frostCheckBox atPoint: 1 @ 6 span: 2 @ 1 ]
		ifFalse: [
				layout
					add: colorLabel atPoint: 1 @ 6;
					add: colorInput atPoint: 2 @ 6 ].
	^ layout
]

{ #category : 'accessing' }
TreeEditorPresenter >> nameInput [
	^ nameInput

]

{ #category : 'building' }
TreeEditorPresenter >> parseNumber: aString [
	"Повертає число або nil, якщо рядок не є числом. Кома дозволена як десятковий роздільник"
	| text |
	text := aString asString trimBoth copyReplaceAll: ',' with: '.'.
	text isEmpty ifTrue: [ ^ nil ].
	^ Number readFrom: text ifFail: [ nil ]

]

{ #category : 'accessing' }
TreeEditorPresenter >> selectTreeClass: aClass [
	typeList selectItem: aClass

]

{ #category : 'accessing' }
TreeEditorPresenter >> selectedTreeClass [
	^ typeList selectedItem ifNil: [ AppleTree ]

]

{ #category : 'accessing' }
TreeEditorPresenter >> typeList [
	^ typeList

]

{ #category : 'layout' }
TreeEditorPresenter >> updateLayoutFor: aClass [
	"Перебудовує вміст вікна при зміні типу дерева"
	self layout: (self layoutForTreeClass: aClass)

]

{ #category : 'layout' }
TreeEditorPresenter >> visibleExtraFields [
	^ self extraFieldsFor: self selectedTreeClass

]

{ #category : 'accessing' }
TreeEditorPresenter >> yieldInput [
	^ yieldInput

]
