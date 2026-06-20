extends Node

var tempo: int = 0

const tooltips: Array[float] = [10.0, 10.0]
const amber_sacrifices: Array[float] = [1.0, 1.0]

const eruptions: Array[float] = [0.4, 0.8]
const volcano_bursts: Array[float] = [0.4, 0.8]
const deal_bursts: Array[float] = [0.4, 0.8]
const pressures: Array[float] = [0.8, 0.8]

const trails: Array[float] = [0.4, 0.4]
const trail_intervals: Array[float] = [0.012, 0.012]

const catena_mins: Array[float] = [0.4, 0.4]
const catena_maxs: Array[float] = [0.8, 0.8]

const transitions: Array[float] = [0.2, 1.1]

const desire_dissolves: Array[float] = [0.5, 1.2]
const splashs: Array[float] = [0.4, 0.5]
const spectacle_ambers: Array[float] = [0.8, 0.5]

const simulates: Array[float] = [0.4, 1]
const privileges: Array[float] = [0.5, 1]


#const TOOLTIP_DURATION: float = 10.0
#const SACRIFICE_AMBER_DURATION: float = 1.0 
#
#const ERUPTION_DURATION: float = 0.4#0.8
#const TRAIL_DURATION: float =  0.4#
#const VOLCANO_BURST_DURATION: float =  0.4#0.8
#const DEAL_BURST_DURATION: float =  0.4#0.8
#const PRESSURE_DURATION: float =  0.8#0.8
#const TRAIL_INTERVAL: float = 0.012
#
#const CATENA_DURATION_MIN: float = 0.4
#const CATENA_DURATION_MAX: float = 0.8
#
#const TRANSITION_DURATION: float = 0.1#1.5
#
#const DESIRE_DISSOLVE_DURATION: float = 0.5#1.2
#const SPASH_DURATION: float = 0.4#0.5
#const SPECTACLE_AMBER_DURATION: float = 0.8#0.5
