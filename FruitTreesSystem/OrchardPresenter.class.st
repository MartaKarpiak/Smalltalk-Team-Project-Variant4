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
		'infoLabel'
	],
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'layout' }
OrchardPresenter class >> defaultLayout [
    ^ SpBoxLayout newTopToBottom
        add: #infoLabel expand: false;
        add: #treeList;
        add: (SpBoxLayout newLeftToRight
            add: #addButton;
            add: #removeButton;
            add: #passYearButton;
            add: #saveButton;
            add: #loadButton;
            yourself) expand: false;
        yourself
]

{ #category : 'initialization' }
OrchardPresenter >> connectPresenters [
    passYearButton action: [ 
        orchard passYear. 
        self updateUI ].
    removeButton action: [ self removeSelectedTree ].
    saveButton action: [ self saveOrchardToFile ].
    loadButton action: [ self loadOrchardFromFile ].
    addButton action: [ self openAddTreeDialog ].
]

{ #category : 'initialization' }
OrchardPresenter >> initialize [
    super initialize.
    orchard := Orchard new.
    orchard owner: 'Марія'.
]

{ #category : 'initialization' }
OrchardPresenter >> initializePresenters [
    treeList := self newList.
    addButton := self newButton label: 'Додати дерево'.
    removeButton := self newButton label: 'Викорчувати'.
    passYearButton := self newButton label: 'Минув рік'.
    saveButton := self newButton label: 'Зберегти'.
    loadButton := self newButton label: 'Завантажити'.
    infoLabel := self newLabel label: 'Загальний урожай: 0'.
]

{ #category : 'initialization' }
OrchardPresenter >> loadOrchardFromFile [
    | file |
    file := UIManager default chooseExistingFileReference: 'Завантажити сад' extensions: #('ston' 'json') path: ''.
    file ifNotNil: [
        file readStreamDo: [ :stream | 
            orchard := STON fromStream: stream.
            self updateUI.
            self inform: 'Сад успішно завантажено!' ] ]
]

{ #category : 'initialization' }
OrchardPresenter >> openAddTreeDialog [
    | treeClass ageString targetAge newTree |
    
    treeClass := UIManager default 
        chooseFrom: #('Яблуня' 'Абрикос') 
        values: { AppleTree . ApricotTree } 
        title: 'Оберіть тип дерева'.
    treeClass ifNil: [ ^ self ].
    
    ageString := UIManager default request: 'Введіть вік дерева (у роках):' initialAnswer: '0'.
    ageString ifNil: [ ^ self ].
    targetAge := ageString asInteger.
    
    newTree := treeClass new.
    
    targetAge timesRepeat: [ newTree growOneYear ].
    
    orchard addTree: newTree.
    self updateUI.
]

{ #category : 'initialization' }
OrchardPresenter >> removeSelectedTree [
    | selected |
    selected := treeList selectedItem.
    selected ifNotNil: [ 
        orchard removeTree: selected.
        self updateUI ]
]

{ #category : 'initialization' }
OrchardPresenter >> saveOrchardToFile [
    | file |
    file := UIManager default chooseForSaveFileReference: 'Зберегти сад' extensions: #('ston' 'json') path: ''.
    file ifNotNil: [
        file writeStreamDo: [ :stream | STON put: orchard onStream: stream ].
        self inform: 'Сад успішно збережено!' ]
]

{ #category : 'updating' }
OrchardPresenter >> updateUI [
    treeList items: orchard trees.
    infoLabel label: 'Загальний урожай: ', orchard totalYield asString.
]
