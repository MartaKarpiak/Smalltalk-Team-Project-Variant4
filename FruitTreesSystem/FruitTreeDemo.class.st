"
Приклади використання класів FruitTree, AppleTree, ApricotTree і FruitTreeManager. Запуск усіх прикладів: FruitTreeDemo runAll. Результат виводиться в Transcript.
"
Class {
	#name : 'FruitTreeDemo',
	#superclass : 'Object',
	#category : 'FruitTreesSystem',
	#package : 'FruitTreesSystem'
}

{ #category : 'instance creation' }
FruitTreeDemo class >> appleAge: anAge height: aHeight yield: aYield color: aColor [
	"Створює яблуню із заданими параметрами"
	^ AppleTree new
		age: anAge;
		height: aHeight;
		yield: aYield;
		fruitColor: aColor;
		yourself

]

{ #category : 'instance creation' }
FruitTreeDemo class >> apricotAge: anAge height: aHeight yield: aYield frost: aBoolean [
	"Створює абрикос із заданими параметрами"
	^ ApricotTree new
		age: anAge;
		height: aHeight;
		yield: aYield;
		hadFrostDuringFlowering: aBoolean;
		yourself

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleCollection [
	"Операції з колекцією дерев"
	| manager limit allFruiting |
	self title: 'Collection operations'.
	manager := self sampleManager.
	self log: manager.

	self log: 'Tallest tree: ', manager tallestTree printString.
	self log: 'Most productive tree: ', manager mostProductiveTree printString.

	allFruiting := manager treesOfFruitingAge size = manager trees size.
	self log: 'All trees reached fruiting age: ', allFruiting printString.

	self log: 'Top 3 by yield:'.
	manager topThreeMostProductiveTrees do: [ :tree |
		self log: '  ', tree printString ].

	limit := 2.5.
	self log: 'Trees not taller than ', limit printString, ' m:'.
	(manager treesNotTallerThan: limit) do: [ :tree |
		self log: '  ', tree printString ]

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleComparison [
	"Порівняння та арифметичні операції (за урожайністю)"
	| apple apricot |
	self title: 'Comparison and arithmetic'.
	apple := self appleAge: 5 height: 2.5 yield: 20 color: 'Green'.
	apricot := self apricotAge: 4 height: 3.0 yield: 15 frost: false.
	self log: 'A = ', apple printString.
	self log: 'B = ', apricot printString.
	self log: 'A > B: ', (apple > apricot) printString.
	self log: 'A < B: ', (apple < apricot) printString.
	self log: 'A = B: ', (apple = apricot) printString.
	self log: 'A + B = ', (apple + apricot) printString.
	self log: 'A - B = ', (apple - apricot) printString.
	self log: 'A * B = ', (apple * apricot) printString.
	self log: 'A / B = ', (apple / apricot) printString

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleDatabase [
	"Імітація бази даних у пам'яті: спільний екземпляр FruitTreeManager default"
	| db sameDb |
	self title: 'In-memory database'.
	FruitTreeManager reset.
	db := FruitTreeManager default.
	self sampleManager trees do: [ :tree | db addTree: tree ].

	sameDb := FruitTreeManager default.
	self log: 'Same instance on second access: ', (db == sameDb) printString.
	self log: 'Trees loaded from database: ', sameDb trees size printString.
	self log: sameDb.

	FruitTreeManager reset.
	self log: 'Trees after reset: ', FruitTreeManager default trees size printString.
	FruitTreeManager reset

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleDialog [
	"Додавання нового дерева через діалог. Не входить у runAll, бо чекає на введення"
	| manager tree |
	self title: 'Dialog input'.
	manager := self sampleManager.
	tree := manager addTreeFromDialog.
	tree ifNil: [ ^ self log: 'Input cancelled' ].
	self log: 'Added: ', tree printString.
	self log: manager

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleFiles [
	"Збереження у файли JSON і STON та завантаження з них"
	| manager jsonFile stonFile fromJson fromSton |
	self title: 'Files: JSON and STON'.
	manager := self sampleManager.
	jsonFile := FileLocator imageDirectory / 'fruit-trees-demo-output.json'.
	stonFile := FileLocator imageDirectory / 'fruit-trees-demo-output.ston'.
	jsonFile ensureDelete.
	stonFile ensureDelete.

	manager saveToJSONFile: jsonFile fullName.
	manager saveToSTON: stonFile fullName.
	self log: 'Saved: ', jsonFile fullName.
	self log: 'Saved: ', stonFile fullName.

	fromJson := FruitTreeManager new.
	fromJson loadFromJSONFile: jsonFile fullName.
	self log: 'Loaded from JSON:'.
	self log: fromJson.

	fromSton := FruitTreeManager new.
	fromSton loadFromSTON: stonFile fullName.
	self log: 'Loaded from STON:'.
	self log: fromSton

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleGrowth [
	"Ріст усіх дерев на один і на два роки"
	| manager |
	self title: 'Growth'.
	manager := self sampleManager.
	self log: 'Initial state:'.
	self log: manager.
	manager growAllOneYear.
	self log: 'After 1 year:'.
	self log: manager.
	manager growAllTwoYears.
	self log: 'After 2 more years:'.
	self log: manager

]

{ #category : 'examples' }
FruitTreeDemo class >> exampleTrees [
	"Створення дерев, особливості яблуні та абрикоса"
	| apple apricot |
	self title: 'Creating trees'.
	apple := self appleAge: 4 height: 2.0 yield: 18 color: 'Red'.
	apricot := self apricotAge: 5 height: 3.1 yield: 25 frost: true.

	self log: apple.
	self log: 'Fruit color: ', apple fruitColor.
	self log: 'Apple bears fruit at age 4: ', apple canBearFruit printString.
	apple growOneYear.
	self log: 'Apple bears fruit at age 5: ', apple canBearFruit printString.

	self log: apricot.
	self log: 'Frost during flowering: ', apricot hadFrostDuringFlowering printString.
	self log: 'Apricot harvest with frost (-80%): ', apricot currentHarvest printString, ' kg'.
	apricot hadFrostDuringFlowering: false.
	self log: 'Apricot harvest without frost: ', apricot currentHarvest printString, ' kg'

]

{ #category : 'printing' }
FruitTreeDemo class >> log: anObject [
	"Виводить об'єкт у Transcript окремим рядком"
	Transcript show: anObject asString; cr

]

{ #category : 'examples' }
FruitTreeDemo class >> runAll [
	"Запускає всі неінтерактивні приклади"
	self exampleTrees.
	self exampleComparison.
	self exampleCollection.
	self exampleGrowth.
	self exampleFiles.
	self exampleDatabase

]

{ #category : 'instance creation' }
FruitTreeDemo class >> sampleManager [
	"Колекція з двох яблунь і двох абрикосів, спільна для всіх прикладів"
	| manager |
	manager := FruitTreeManager new.
	manager addTree: (self appleAge: 5 height: 2.5 yield: 20 color: 'Green').
	manager addTree: (self appleAge: 3 height: 1.8 yield: 12 color: 'Red').
	manager addTree: (self apricotAge: 4 height: 3.2 yield: 25 frost: false).
	manager addTree: (self apricotAge: 2 height: 1.5 yield: 8 frost: true).
	^ manager

]

{ #category : 'printing' }
FruitTreeDemo class >> title: aString [
	"Виводить заголовок прикладу"
	Transcript cr; show: '=== ', aString, ' ==='; cr

]
