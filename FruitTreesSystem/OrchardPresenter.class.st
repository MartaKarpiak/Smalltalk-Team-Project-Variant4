"
Головне вікно саду (Spec 2). Показує власника, таблицю дерев і загальний урожай. Через кнопки та меню дає доступ до функцій класу Orchard: посадити, викорчувати, минув рік, заморозки, пошук, файли JSON і STON, база даних OrchardRepository. Запуск: OrchardPresenter new open або OrchardPresenter openWithSampleOrchard.
"
Class {
	#name : 'OrchardPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'orchard',
		'treeList',
		'addButton',
		'removeButton',
		'passYearButton',
		'saveButton',
		'loadButton',
		'infoLabel',
		'ownerLabel',
		'ownerButton',
		'searchButton',
		'showAllButton',
		'frostButton',
		'saveDbButton',
		'loadDbButton',
		'statusLabel',
		'repository',
		'searchClass',
		'searchBlock',
		'confirmBlock'
	],
	#classInstVars : [
		'sharedRepository'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'layout' }
OrchardPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: #ownerLabel expand: false;
		add: #infoLabel expand: false;
		add: #treeList;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: #addButton;
			add: #removeButton;
			add: #passYearButton;
			add: #frostButton;
			add: #searchButton;
			add: #showAllButton;
			add: #ownerButton;
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: #saveButton;
			add: #loadButton;
			add: #saveDbButton;
			add: #loadDbButton;
			yourself) expand: false;
		add: #statusLabel expand: false;
		yourself

]

{ #category : 'accessing' }
OrchardPresenter class >> displayNameOfTreeClass: aClass [
	aClass = AppleTree ifTrue: [ ^ 'Яблуня' ].
	aClass = ApricotTree ifTrue: [ ^ 'Абрикос' ].
	^ 'Дерево'

]

{ #category : 'accessing' }
OrchardPresenter class >> oldTreeAge [
	"Дерева, старші за цей вік, сад пропонує викорчувати"
	^ 20

]

{ #category : 'examples' }
OrchardPresenter class >> openWithSampleOrchard [
	"OrchardPresenter openWithSampleOrchard"
	^ self new
		orchard: self sampleOrchard;
		open

]

{ #category : 'database' }
OrchardPresenter class >> resetSharedRepository [
	sharedRepository := nil

]

{ #category : 'examples' }
OrchardPresenter class >> sampleOrchard [
	| orchard |
	orchard := Orchard new.
	orchard owner: 'Садівник'.
	orchard addTree: (AppleTree name: 'Голден' age: 5 height: 2.5 yield: 20 color: 'Жовтий').
	orchard addTree: (AppleTree name: 'Айдаред' age: 4 height: 2.2 yield: 15 color: 'Червоний').
	orchard addTree: (AppleTree name: 'Антонівка' age: 20 height: 4.5 yield: 30 color: 'Зелений').
	orchard addTree: (ApricotTree name: 'Краснощокий' age: 6 height: 3.4 yield: 25 hadFrosts: false).
	orchard addTree: (ApricotTree name: 'Мелітопольський' age: 2 height: 1.5 yield: 8 hadFrosts: true).
	^ orchard

]

{ #category : 'database' }
OrchardPresenter class >> sharedRepository [
	"Спільна імітація бази даних. Дані зберігаються, доки відкритий образ Pharo"
	^ sharedRepository ifNil: [ sharedRepository := OrchardRepository new ]

]

{ #category : 'actions' }
OrchardPresenter >> addTree: aTree [
	orchard addTree: aTree.
	self updateUI.
	self showStatus: 'Посаджено: ', aTree printString

]

{ #category : 'actions' }
OrchardPresenter >> addTreeFromEditor: anEditor [
	| tree |
	tree := anEditor buildTree.
	tree ifNil: [
		^ self showStatus: 'Дерево не додано: вік, висота й урожайність мають бути невід''ємними числами' ].
	self addTree: tree

]

{ #category : 'updating' }
OrchardPresenter >> askConfirmation: aString [
	^ confirmBlock value: aString

]

{ #category : 'menu' }
OrchardPresenter >> buildFileMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item | item name: 'Зберегти у файл...'; action: [ self saveOrchardToFile ] ];
				addItem: [ :item | item name: 'Завантажити з файлу...'; action: [ self loadOrchardFromFile ] ] ];
		addGroup: [ :group |
			group
				addItem: [ :item | item name: 'Зберегти в базу даних...'; action: [ self saveOrchardToDatabase ] ];
				addItem: [ :item | item name: 'Завантажити з бази даних...'; action: [ self loadOrchardFromDatabase ] ] ];
		yourself

]

{ #category : 'menu' }
OrchardPresenter >> buildMenuBar [
	^ self newMenuBar
		addGroup: [ :group |
			group
				addItem: [ :item | item name: 'Файл'; subMenu: self buildFileMenu ];
				addItem: [ :item | item name: 'Сад'; subMenu: self buildOrchardMenu ] ];
		yourself

]

{ #category : 'menu' }
OrchardPresenter >> buildOrchardMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item | item name: 'Посадити дерево...'; action: [ self openAddTreeDialog ] ];
				addItem: [ :item | item name: 'Викорчувати вибране дерево'; action: [ self removeSelectedTree ] ];
				addItem: [ :item | item name: 'Минув рік'; action: [ self passYear ] ];
				addItem: [ :item | item name: 'Перевірити заморозки...'; action: [ self openFrostDialog ] ] ];
		addGroup: [ :group |
			group
				addItem: [ :item | item name: 'Пошук дерев...'; action: [ self openSearchDialog ] ];
				addItem: [ :item | item name: 'Показати всі дерева'; action: [ self showAllTrees ] ];
				addItem: [ :item | item name: 'Змінити власника...'; action: [ self openOwnerDialog ] ] ];
		yourself

]

{ #category : 'actions' }
OrchardPresenter >> changeOwnerTo: aString [
	orchard owner: aString.
	self updateUI.
	self showStatus: 'Новий власник: ', aString

]

{ #category : 'actions' }
OrchardPresenter >> checkFrostAt: aTemperature [
	| damaged |
	orchard checkFrostDamage: aTemperature.
	damaged := orchard trees count: [ :tree | tree isDamagedByFrost == true ].
	self updateUI.
	self showStatus: 'Температура під час цвітіння: ', aTemperature printString,
		' °C. Постраждалих дерев: ', damaged printString

]

{ #category : 'accessing' }
OrchardPresenter >> confirmBlock: aBlock [
	"Блок отримує текст питання і повертає true або false. У тестах замінює діалог підтвердження"
	confirmBlock := aBlock

]

{ #category : 'initialization' }
OrchardPresenter >> connectPresenters [
	addButton action: [ self openAddTreeDialog ].
	removeButton action: [ self removeSelectedTree ].
	passYearButton action: [ self passYear ].
	frostButton action: [ self openFrostDialog ].
	searchButton action: [ self openSearchDialog ].
	showAllButton action: [ self showAllTrees ].
	ownerButton action: [ self openOwnerDialog ].
	saveButton action: [ self saveOrchardToFile ].
	loadButton action: [ self loadOrchardFromFile ].
	saveDbButton action: [ self saveOrchardToDatabase ].
	loadDbButton action: [ self loadOrchardFromDatabase ]

]

{ #category : 'accessing' }
OrchardPresenter >> displayedTrees [
	^ treeList items

]

{ #category : 'updating' }
OrchardPresenter >> featuresOf: aTree [
	| text |
	text := ''.
	(aTree isKindOf: AppleTree) ifTrue: [
		text := 'колір плодів: ', aTree fruitColor asString ].
	(aTree isKindOf: ApricotTree) ifTrue: [
		text := aTree hadFrostDuringFlowering
			ifTrue: [ 'заморозки під час цвітіння' ]
			ifFalse: [ 'без заморозків' ] ].
	(aTree isDamagedByFrost == true and: [ (aTree isKindOf: ApricotTree) not ]) ifTrue: [
		text := text, ', пошкоджене морозом' ].
	^ text

]

{ #category : 'accessing' }
OrchardPresenter >> infoLabel [
	^ infoLabel

]

{ #category : 'initialization' }
OrchardPresenter >> initialize [
	orchard := Orchard new.
	repository := self class sharedRepository.
	confirmBlock := [ :question | UIManager default confirm: question ].
	super initialize.
	self updateUI

]

{ #category : 'initialization' }
OrchardPresenter >> initializePresenters [
	ownerLabel := self newLabel.
	infoLabel := self newLabel.
	statusLabel := self newLabel label: 'Готово'; yourself.

	treeList := self newTable.
	treeList
		addColumn: (SpStringTableColumn title: 'Тип' evaluated: [ :tree | self class displayNameOfTreeClass: tree class ]);
		addColumn: (SpStringTableColumn title: 'Назва' evaluated: [ :tree | tree speciesName asString ]);
		addColumn: (SpStringTableColumn title: 'Вік' evaluated: [ :tree | tree age asString ]);
		addColumn: (SpStringTableColumn title: 'Висота, м' evaluated: [ :tree | tree height printShowingDecimalPlaces: 1 ]);
		addColumn: (SpStringTableColumn title: 'Урожайність, кг' evaluated: [ :tree | tree yield asString ]);
		addColumn: (SpStringTableColumn title: 'Урожай цього року, кг' evaluated: [ :tree | tree currentHarvest printShowingDecimalPlaces: 1 ]);
		addColumn: (SpStringTableColumn title: 'Плодоносить' evaluated: [ :tree | tree canBearFruit ifTrue: [ 'так' ] ifFalse: [ 'ні' ] ]);
		addColumn: (SpStringTableColumn title: 'Особливості' evaluated: [ :tree | self featuresOf: tree ]).

	addButton := self newButton label: 'Посадити дерево'; yourself.
	removeButton := self newButton label: 'Викорчувати'; yourself.
	passYearButton := self newButton label: 'Минув рік'; yourself.
	frostButton := self newButton label: 'Заморозки'; yourself.
	searchButton := self newButton label: 'Пошук'; yourself.
	showAllButton := self newButton label: 'Показати всі'; yourself.
	ownerButton := self newButton label: 'Змінити власника'; yourself.
	saveButton := self newButton label: 'Зберегти у файл'; yourself.
	loadButton := self newButton label: 'Завантажити з файлу'; yourself.
	saveDbButton := self newButton label: 'Зберегти в БД'; yourself.
	loadDbButton := self newButton label: 'Завантажити з БД'; yourself

]

{ #category : 'initialization' }
OrchardPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Сад';
		initialExtent: 1000 @ 550;
		menu: self buildMenuBar

]

{ #category : 'persistence' }
OrchardPresenter >> loadFromDatabaseWithId: anId [
	| loaded |
	loaded := repository orchardWithId: anId.
	loaded ifNil: [
		self showStatus: 'У базі даних немає саду з ідентифікатором "', anId, '"'.
		^ nil ].
	self orchard: loaded.
	self showStatus: 'Сад завантажено з бази даних: "', anId, '"'.
	^ loaded

]

{ #category : 'persistence' }
OrchardPresenter >> loadOrchardFrom: aFileReference [
	| file loaded |
	file := aFileReference asFileReference.
	loaded := Orchard new.
	file extension asLowercase = 'json'
		ifTrue: [ loaded loadFromJSONFile: file fullName ]
		ifFalse: [ loaded loadFromSTONFile: file fullName ].
	self orchard: loaded.
	self showStatus: 'Сад завантажено з файлу ', file basename.
	^ loaded

]

{ #category : 'dialogs' }
OrchardPresenter >> loadOrchardFromDatabase [
	| id |
	id := UIManager default
		request: 'Ідентифікатор саду в базі даних:'
		initialAnswer: (orchard owner ifNil: [ 'orchard-1' ]).
	(id isNil or: [ id trimBoth isEmpty ]) ifTrue: [ ^ self ].
	self loadFromDatabaseWithId: id trimBoth

]

{ #category : 'dialogs' }
OrchardPresenter >> loadOrchardFromFile [
	| file |
	file := UIManager default
		chooseExistingFileReference: 'Завантажити сад'
		extensions: #('json' 'ston')
		path: FileLocator imageDirectory asFileReference.
	file ifNil: [ ^ self ].
	[ self loadOrchardFrom: file ]
		on: Error
		do: [ :error | self showStatus: 'Не вдалося завантажити файл: ', error description ]

]

{ #category : 'dialogs' }
OrchardPresenter >> openAddTreeDialog [
	| editor dialog |
	editor := TreeEditorPresenter new.
	dialog := editor asDialogWindow.
	dialog
		title: 'Посадити нове дерево';
		initialExtent: 450 @ 320;
		okAction: [ self addTreeFromEditor: editor ].
	dialog open

]

{ #category : 'dialogs' }
OrchardPresenter >> openFrostDialog [
	| answer temperature |
	answer := UIManager default
		request: 'Мінімальна температура під час цвітіння, °C:'
		initialAnswer: '0'.
	answer ifNil: [ ^ self ].
	temperature := Number readFrom: answer trimBoth ifFail: [ nil ].
	temperature ifNil: [ ^ self showStatus: 'Некоректна температура' ].
	self checkFrostAt: temperature

]

{ #category : 'dialogs' }
OrchardPresenter >> openOwnerDialog [
	| name |
	name := UIManager default
		request: 'Ім''я власника саду:'
		initialAnswer: (orchard owner ifNil: [ '' ]).
	(name isNil or: [ name trimBoth isEmpty ]) ifTrue: [ ^ self ].
	self changeOwnerTo: name trimBoth

]

{ #category : 'dialogs' }
OrchardPresenter >> openSearchDialog [
	| treeClass block |
	treeClass := UIManager default
		chooseFrom: #('Усі дерева' 'Яблуні' 'Абрикоси')
		values: { FruitTree. AppleTree. ApricotTree }
		title: 'Пошук дерев'.
	treeClass ifNil: [ ^ self ].
	block := [ :tree | true ].

	treeClass = AppleTree ifTrue: [
		| color |
		color := UIManager default
			request: 'Колір плодів (порожньо - будь-який):'
			initialAnswer: ''.
		color ifNil: [ ^ self ].
		color := color trimBoth.
		color isEmpty ifFalse: [
			block := [ :tree |
				tree fruitColor notNil and: [
					tree fruitColor asLowercase = color asLowercase ] ] ] ].

	treeClass = ApricotTree ifTrue: [
		| choice |
		choice := UIManager default
			chooseFrom: #('Усі абрикоси' 'Були заморозки' 'Без заморозків')
			values: #(#all #frost #noFrost)
			title: 'Заморозки під час цвітіння'.
		choice ifNil: [ ^ self ].
		choice = #frost ifTrue: [ block := [ :tree | tree hadFrostDuringFlowering ] ].
		choice = #noFrost ifTrue: [ block := [ :tree | tree hadFrostDuringFlowering not ] ] ].

	self searchTreesOfClass: treeClass withCharacteristic: block

]

{ #category : 'accessing' }
OrchardPresenter >> orchard [
	^ orchard

]

{ #category : 'accessing' }
OrchardPresenter >> orchard: anOrchard [
	orchard := anOrchard.
	searchClass := nil.
	searchBlock := nil.
	self updateUI

]

{ #category : 'accessing' }
OrchardPresenter >> ownerLabel [
	^ ownerLabel

]

{ #category : 'actions' }
OrchardPresenter >> passYear [
	"Минув рік: усі дерева ростуть, сад пропонує викорчувати старі дерева"
	| oldAge oldTrees removed |
	orchard passYear.
	oldAge := self class oldTreeAge.
	oldTrees := orchard treesOlderThan: oldAge.
	removed := 0.
	(oldTrees notEmpty and: [
		self askConfirmation: 'Минув рік. У саду є дерева, старші за ', oldAge printString,
			' років (', oldTrees size printString, ' шт.). Викорчувати їх?' ])
		ifTrue: [ removed := orchard removeTreesOlderThan: oldAge ].
	self updateUI.
	self showStatus: 'Минув рік. Викорчувано старих дерев: ', removed printString

]

{ #category : 'actions' }
OrchardPresenter >> removeSelectedTree [
	| selected |
	selected := treeList selectedItem.
	selected ifNil: [ ^ self showStatus: 'Спочатку виберіть дерево в таблиці' ].
	(self askConfirmation: 'Викорчувати дерево ', selected printString, '?')
		ifFalse: [ ^ self showStatus: 'Викорчовування скасовано' ].
	self removeTree: selected

]

{ #category : 'actions' }
OrchardPresenter >> removeTree: aTree [
	orchard removeTree: aTree.
	self updateUI.
	self showStatus: 'Викорчувано: ', aTree printString

]

{ #category : 'accessing' }
OrchardPresenter >> repository: anOrchardRepository [
	repository := anOrchardRepository

]

{ #category : 'persistence' }
OrchardPresenter >> saveOrchardTo: aFileReference [
	"Формат визначається розширенням файлу: .json або .ston"
	| file |
	file := aFileReference asFileReference.
	file ensureDelete.
	file extension asLowercase = 'json'
		ifTrue: [ orchard saveToJSONFile: file fullName ]
		ifFalse: [ orchard saveToSTONFile: file fullName ].
	self showStatus: 'Сад збережено у файл ', file basename.
	^ file

]

{ #category : 'dialogs' }
OrchardPresenter >> saveOrchardToDatabase [
	| id |
	id := UIManager default
		request: 'Ідентифікатор саду в базі даних:'
		initialAnswer: (orchard owner ifNil: [ 'orchard-1' ]).
	(id isNil or: [ id trimBoth isEmpty ]) ifTrue: [ ^ self ].
	self saveToDatabaseWithId: id trimBoth

]

{ #category : 'dialogs' }
OrchardPresenter >> saveOrchardToFile [
	| format file |
	format := UIManager default
		chooseFrom: #('JSON' 'STON')
		values: #('json' 'ston')
		title: 'Формат файлу'.
	format ifNil: [ ^ self ].
	file := UIManager default
		chooseForSaveFileReference: 'Зберегти сад'
		extensions: { format }
		path: FileLocator imageDirectory asFileReference.
	file ifNil: [ ^ self ].
	file extension = format ifFalse: [ file := file withExtension: format ].
	[ self saveOrchardTo: file ]
		on: Error
		do: [ :error | self showStatus: 'Не вдалося зберегти файл: ', error description ]

]

{ #category : 'persistence' }
OrchardPresenter >> saveToDatabaseWithId: anId [
	repository saveOrchard: orchard withId: anId.
	self showStatus: 'Сад збережено в базу даних під ідентифікатором "', anId, '"'

]

{ #category : 'actions' }
OrchardPresenter >> searchTreesOfClass: aClass withCharacteristic: aBlock [
	searchClass := aClass.
	searchBlock := aBlock.
	self updateUI.
	self showStatus: 'Знайдено дерев: ', self displayedTrees size printString

]

{ #category : 'actions' }
OrchardPresenter >> showAllTrees [
	searchClass := nil.
	searchBlock := nil.
	self updateUI.
	self showStatus: 'Показано всі дерева'

]

{ #category : 'updating' }
OrchardPresenter >> showStatus: aString [
	statusLabel label: aString

]

{ #category : 'accessing' }
OrchardPresenter >> statusLabel [
	^ statusLabel

]

{ #category : 'accessing' }
OrchardPresenter >> treeList [
	^ treeList

]

{ #category : 'updating' }
OrchardPresenter >> updateUI [
	| trees |
	trees := searchClass
		ifNil: [ orchard trees copy ]
		ifNotNil: [ orchard findTreesOfClass: searchClass withCharacteristic: searchBlock ].
	treeList items: trees asOrderedCollection.
	ownerLabel label: 'Власник саду: ', (orchard owner ifNil: [ 'не вказано' ]) asString.
	infoLabel label: 'Дерев у саду: ', orchard trees size printString,
		'    Загальний урожай: ', (orchard totalYield printShowingDecimalPlaces: 1), ' кг'

]
