"
Тести графічного інтерфейсу саду: OrchardPresenter і TreeEditorPresenter. Діалоги підтвердження замінено блоком, файлові діалоги обходяться прямими викликами методів збереження.
"
Class {
	#name : 'OrchardPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'FruitTreesSystem-Tests',
	#package : 'FruitTreesSystem-Tests'
}

{ #category : 'running' }
OrchardPresenterTest >> apricotIn: anOrchard [
	^ anOrchard trees detect: [ :tree | tree isKindOf: ApricotTree ]

]

{ #category : 'running' }
OrchardPresenterTest >> sampleOrchard [
	| orchard |
	orchard := Orchard new.
	orchard owner: 'Тестовий власник'.
	orchard addTree: (AppleTree name: 'Айдаред' age: 5 height: 2.5 yield: 20 color: 'Червоний').
	orchard addTree: (AppleTree name: 'Антонівка' age: 4 height: 2.0 yield: 10 color: 'Зелений').
	orchard addTree: (ApricotTree name: 'Краснощокий' age: 5 height: 3.0 yield: 12 hadFrosts: false).
	^ orchard

]

{ #category : 'running' }
OrchardPresenterTest >> setUp [
	super setUp.
	presenter := OrchardPresenter new.
	presenter repository: OrchardRepository new.
	presenter confirmBlock: [ :question | true ]

]

{ #category : 'tests - tree editor' }
OrchardPresenterTest >> testAddTreeFromEditor [
	| editor |
	editor := TreeEditorPresenter new.
	editor ageInput text: '5'.
	editor yieldInput text: '20'.

	presenter addTreeFromEditor: editor.
	self assert: presenter orchard trees size equals: 1.

	editor yieldInput text: 'багато'.
	presenter addTreeFromEditor: editor.
	self assert: presenter orchard trees size equals: 1.
	self assert: (presenter statusLabel label includesSubstring: 'не додано')

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testAddTreeUpdatesTable [
	| apple |
	apple := AppleTree name: 'Голден' age: 5 height: 2.5 yield: 20 color: 'Жовтий'.

	presenter addTree: apple.

	self assert: presenter orchard trees size equals: 1.
	self assert: presenter displayedTrees size equals: 1.
	self assert: presenter displayedTrees first == apple.
	self assert: (presenter infoLabel label includesSubstring: 'Дерев у саду: 1')

]

{ #category : 'tests - display' }
OrchardPresenterTest >> testChangeOwner [
	presenter orchard: self sampleOrchard.
	presenter changeOwnerTo: 'Новий власник'.

	self assert: presenter orchard owner equals: 'Новий власник'.
	self assert: (presenter ownerLabel label includesSubstring: 'Новий власник')

]

{ #category : 'tests - tree editor' }
OrchardPresenterTest >> testEditorBuildsAppleTree [
	| editor tree |
	editor := TreeEditorPresenter new.
	editor selectTreeClass: AppleTree.
	editor nameInput text: 'Антонівка'.
	editor ageInput text: '6'.
	editor heightInput text: '3,5'.
	editor yieldInput text: '25'.
	editor colorInput text: 'Зелений'.

	tree := editor buildTree.

	self assert: tree class equals: AppleTree.
	self assert: tree speciesName equals: 'Антонівка'.
	self assert: tree age equals: 6.
	self assert: tree height equals: 3.5.
	self assert: tree yield equals: 25.
	self assert: tree fruitColor equals: 'Зелений'

]

{ #category : 'tests - tree editor' }
OrchardPresenterTest >> testEditorBuildsApricotWithFrost [
	| editor tree |
	editor := TreeEditorPresenter new.
	editor selectTreeClass: ApricotTree.
	editor ageInput text: '4'.
	editor heightInput text: '2'.
	editor yieldInput text: '15'.
	editor frostCheckBox state: true.

	tree := editor buildTree.

	self assert: tree class equals: ApricotTree.
	self assert: tree speciesName equals: 'Apricot'.
	self assert: tree hadFrostDuringFlowering

]

{ #category : 'tests - tree editor' }
OrchardPresenterTest >> testEditorFieldsDependOnTreeType [
	| editor |
	editor := TreeEditorPresenter new.

	editor selectTreeClass: AppleTree.
	self assert: (editor visibleExtraFields includes: editor colorInput).
	self deny: (editor visibleExtraFields includes: editor frostCheckBox).

	editor selectTreeClass: ApricotTree.
	self assert: (editor visibleExtraFields includes: editor frostCheckBox).
	self deny: (editor visibleExtraFields includes: editor colorInput)

]

{ #category : 'tests - tree editor' }
OrchardPresenterTest >> testEditorRejectsInvalidNumbers [
	| editor |
	editor := TreeEditorPresenter new.

	editor ageInput text: 'abc'.
	self assert: editor buildTree isNil.

	editor ageInput text: '-1'.
	self assert: editor buildTree isNil.

	editor ageInput text: ''.
	self assert: editor buildTree isNil.

	editor ageInput text: '3'.
	self deny: editor buildTree isNil

]

{ #category : 'tests - display' }
OrchardPresenterTest >> testFeaturesColumnDependsOnTreeType [
	| apple apricot |
	apple := AppleTree new fruitColor: 'Зелений'; yourself.
	apricot := ApricotTree new hadFrostDuringFlowering: true; yourself.

	self assert: ((presenter featuresOf: apple) includesSubstring: 'Зелений').
	self assert: ((presenter featuresOf: apricot) includesSubstring: 'заморозки')

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testFrostCheck [
	| apricot |
	presenter orchard: self sampleOrchard.
	apricot := self apricotIn: presenter orchard.

	presenter checkFrostAt: -2.
	self assert: apricot hadFrostDuringFlowering.
	self assert: (presenter orchard trees allSatisfy: [ :tree | tree isDamagedByFrost ]).

	presenter checkFrostAt: 5.
	self deny: apricot hadFrostDuringFlowering

]

{ #category : 'tests - display' }
OrchardPresenterTest >> testInitialStateIsEmpty [
	self assert: presenter orchard trees isEmpty.
	self assert: presenter displayedTrees isEmpty.
	self assert: (presenter infoLabel label includesSubstring: 'Дерев у саду: 0').
	self assert: (presenter ownerLabel label includesSubstring: 'не вказано')

]

{ #category : 'tests - persistence' }
OrchardPresenterTest >> testLoadMissingIdFromDatabaseKeepsOrchard [
	| current |
	presenter orchard: self sampleOrchard.
	current := presenter orchard.

	self assert: (presenter loadFromDatabaseWithId: 'missing') isNil.
	self assert: presenter orchard == current.
	self assert: (presenter statusLabel label includesSubstring: 'missing')

]

{ #category : 'tests - windows' }
OrchardPresenterTest >> testMainWindowOpensAndCloses [
	| window |
	presenter orchard: self sampleOrchard.
	window := presenter asWindow.
	[ self shouldnt: [ window open ] raise: Error ] ensure: [ window close ]

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testPassYearGrowsAllTrees [
	| asked |
	asked := false.
	presenter confirmBlock: [ :question | asked := true. true ].
	presenter orchard: self sampleOrchard.

	presenter passYear.

	self
		assert: (presenter orchard trees collect: [ :tree | tree age ]) asArray
		equals: #(6 5 6).
	self deny: asked

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testPassYearKeepsOldTreesWhenDeclined [
	presenter confirmBlock: [ :question | false ].
	presenter orchard: self sampleOrchard.
	presenter addTree: (AppleTree name: 'Стара' age: 20 height: 5 yield: 30 color: 'Зелений').

	presenter passYear.

	self assert: presenter orchard trees size equals: 4.
	self assert: (presenter orchard trees anySatisfy: [ :tree | tree age = 21 ])

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testPassYearOffersToRemoveOldTrees [
	| asked |
	asked := false.
	presenter confirmBlock: [ :question | asked := true. true ].
	presenter orchard: self sampleOrchard.
	presenter addTree: (AppleTree name: 'Стара' age: 20 height: 5 yield: 30 color: 'Зелений').

	presenter passYear.

	self assert: asked.
	self assert: presenter orchard trees size equals: 3.
	self deny: (presenter orchard trees anySatisfy: [ :tree | tree age > 20 ])

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testRemoveSelectedTreeAfterConfirmation [
	| tree |
	presenter orchard: self sampleOrchard.
	tree := presenter orchard trees first.
	presenter treeList selectItem: tree.

	presenter removeSelectedTree.

	self assert: presenter orchard trees size equals: 2.
	self deny: (presenter orchard trees anySatisfy: [ :each | each == tree ]).
	self assert: presenter displayedTrees size equals: 2

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testRemoveSelectedTreeCancelled [
	| tree asked |
	asked := false.
	presenter confirmBlock: [ :question | asked := true. false ].
	presenter orchard: self sampleOrchard.
	tree := presenter orchard trees first.
	presenter treeList selectItem: tree.

	presenter removeSelectedTree.

	self assert: asked.
	self assert: presenter orchard trees size equals: 3

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testRemoveWithoutSelectionDoesNothing [
	presenter orchard: self sampleOrchard.

	presenter removeSelectedTree.

	self assert: presenter orchard trees size equals: 3.
	self assert: (presenter statusLabel label includesSubstring: 'виберіть')

]

{ #category : 'tests - persistence' }
OrchardPresenterTest >> testSaveAndLoadDatabase [
	presenter orchard: self sampleOrchard.
	presenter saveToDatabaseWithId: 'garden-ui'.

	presenter orchard: Orchard new.
	self assert: presenter displayedTrees isEmpty.

	presenter loadFromDatabaseWithId: 'garden-ui'.

	self assert: presenter orchard owner equals: 'Тестовий власник'.
	self assert: presenter displayedTrees size equals: 3

]

{ #category : 'tests - persistence' }
OrchardPresenterTest >> testSaveAndLoadJSONFile [
	| file |
	file := FileLocator imageDirectory / ('orchard-ui-test-', UUID new asString, '.json').
	[
		presenter orchard: self sampleOrchard.
		presenter saveOrchardTo: file.
		self assert: file exists.

		presenter orchard: Orchard new.
		presenter loadOrchardFrom: file.

		self assert: presenter orchard owner equals: 'Тестовий власник'.
		self assert: presenter orchard trees size equals: 3.
		self assert: presenter displayedTrees size equals: 3.
		self assert: (presenter orchard trees first isKindOf: AppleTree).
		self assert: presenter orchard trees first fruitColor equals: 'Червоний'
	] ensure: [ file ensureDelete ]

]

{ #category : 'tests - persistence' }
OrchardPresenterTest >> testSaveAndLoadSTONFile [
	| file |
	file := FileLocator imageDirectory / ('orchard-ui-test-', UUID new asString, '.ston').
	[
		presenter orchard: self sampleOrchard.
		presenter saveOrchardTo: file.
		self assert: file exists.

		presenter orchard: Orchard new.
		presenter loadOrchardFrom: file.

		self assert: presenter orchard owner equals: 'Тестовий власник'.
		self assert: presenter orchard trees size equals: 3.
		self assert: ((self apricotIn: presenter orchard) isKindOf: ApricotTree)
	] ensure: [ file ensureDelete ]

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testSearchApplesByColor [
	presenter orchard: self sampleOrchard.

	presenter
		searchTreesOfClass: AppleTree
		withCharacteristic: [ :tree | tree fruitColor = 'Червоний' ].

	self assert: presenter displayedTrees size equals: 1.
	self assert: presenter displayedTrees first fruitColor equals: 'Червоний'.
	self assert: presenter orchard trees size equals: 3.

	presenter showAllTrees.
	self assert: presenter displayedTrees size equals: 3

]

{ #category : 'tests - actions' }
OrchardPresenterTest >> testSearchIsKeptAfterChanges [
	presenter orchard: self sampleOrchard.
	presenter searchTreesOfClass: AppleTree withCharacteristic: [ :tree | true ].
	self assert: presenter displayedTrees size equals: 2.

	presenter addTree: (ApricotTree name: 'Новий' age: 1 height: 1 yield: 0 hadFrosts: false).

	self assert: presenter displayedTrees size equals: 2.
	self assert: presenter orchard trees size equals: 4

]

{ #category : 'tests - display' }
OrchardPresenterTest >> testShowsOwnerTreesAndTotalYield [
	presenter orchard: self sampleOrchard.

	self assert: presenter displayedTrees size equals: 3.
	self assert: (presenter ownerLabel label includesSubstring: 'Тестовий власник').
	self assert: (presenter infoLabel label includesSubstring: 'Дерев у саду: 3').
	self assert: (presenter infoLabel label includesSubstring:
		(presenter orchard totalYield printShowingDecimalPlaces: 1))

]

{ #category : 'tests - windows' }
OrchardPresenterTest >> testTreeDialogSwitchesLayoutWhileOpen [
	| editor dialog |
	editor := TreeEditorPresenter new.
	dialog := editor asDialogWindow.
	[
		self shouldnt: [ dialog open ] raise: Error.
		editor selectTreeClass: ApricotTree.
		self assert: (editor visibleExtraFields includes: editor frostCheckBox).
		editor selectTreeClass: AppleTree.
		self assert: (editor visibleExtraFields includes: editor colorInput)
	] ensure: [ dialog close ]

]
