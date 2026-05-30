class_name CageData
extends Resource


var table: TableData
var sinner: SinnerData
var type: Bozo.Tooltip = Bozo.Tooltip.CAGE
var coord: Vector2i

var status: Bozo.Cage = Bozo.Cage.NONE:
	set(value_):
		status = value_
		
		#sinner.soul.reset_blur()
		#var traits = Catalog.cage_to_traits[status]
		#
		#for _trait in traits:
			#sinner.soul.select_trait(_trait)

var col: CatenaData
var row: CatenaData
var contribution: ContributionData


func _init(table_: TableData, coord_: Vector2i):
	table = table_
	coord = coord_ 
