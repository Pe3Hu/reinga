extends Node


#region cage
const JAIL_CAGE_GRID = Vector2i(3, 3)
const CAGE_SIZE = Vector2(188, 212)
const SINNER_PANEL_SIZE = Vector2(172, 196)

const JAIL_SIZE = Vector2(548, 632)

const cage_to_color = {
	Bozo.Cage.NONE: Color.WHITE,
	Bozo.Cage.MIDDLE: Color.WHITE,
	Bozo.Cage.LEFT: Color.SLATE_GRAY,
	Bozo.Cage.RIGHT: Color.DEEP_PINK,
	Bozo.Cage.CENTER: Color.WHITE,
}

const cage_to_string = {
	Bozo.Cage.NONE: "none",
	Bozo.Cage.MIDDLE: "top",
	Bozo.Cage.LEFT: "left",
	Bozo.Cage.RIGHT: "right",
	Bozo.Cage.CENTER: "bot",
}

const trait_to_string = {
	Bozo.Triat.FEAR: "fear",
	Bozo.Triat.HORROR: "horror",
	Bozo.Triat.GUILT: "guilt",
	Bozo.Triat.REPOSE: "repose"
}

const trait_to_cage = {
	null: Bozo.Cage.NONE,
	Bozo.Triat.FEAR: Bozo.Cage.MIDDLE,
	Bozo.Triat.HORROR: Bozo.Cage.RIGHT,
	Bozo.Triat.GUILT: Bozo.Cage.CENTER,
	Bozo.Triat.REPOSE: Bozo.Cage.LEFT
}

const cage_to_traits = {
	Bozo.Cage.NONE: [Bozo.Triat.FEAR, Bozo.Triat.HORROR, Bozo.Triat.GUILT, Bozo.Triat.REPOSE],
	Bozo.Cage.MIDDLE: [Bozo.Triat.FEAR],
	Bozo.Cage.RIGHT: [Bozo.Triat.HORROR],
	Bozo.Cage.CENTER: [Bozo.Triat.GUILT, Bozo.Triat.FEAR],
	Bozo.Cage.LEFT: [Bozo.Triat.REPOSE]
}
#endregion

#region sin
const sins = [
	Bozo.Sin.ANGER,
	Bozo.Sin.ENVY,
	Bozo.Sin.GREED,
	Bozo.Sin.GLUTTONY,
	Bozo.Sin.LUST,
	Bozo.Sin.PRIDE,
]

const sin_to_color = {
	Bozo.Sin.PRIDE: Color.REBECCA_PURPLE,
	Bozo.Sin.ENVY: Color.DARK_ORANGE,
	Bozo.Sin.ANGER: Color.CRIMSON,
	Bozo.Sin.LUST: Color.ROYAL_BLUE,
	Bozo.Sin.GREED: Color.GOLD,
	Bozo.Sin.GLUTTONY: Color.SEA_GREEN,
}

const sin_to_string = {
	Bozo.Sin.PRIDE: "pride",
	Bozo.Sin.ENVY: "envy",
	Bozo.Sin.ANGER: "anger",
	Bozo.Sin.LUST: "lust",
	Bozo.Sin.GREED: "greed",
	Bozo.Sin.GLUTTONY: "gluttony",
}
#endregion

#region fate
const GYRE_HEREAFTER_SINNER_SIZE: int = 18
const GYRE_ACTUAL_SINNER_SIZE: int = 9

const fates = [
	Bozo.Fate.HEIR,
	Bozo.Fate.COLLECTOR,
	Bozo.Fate.GOURMET,
	Bozo.Fate.DUELIST,
	Bozo.Fate.MASHER,
	Bozo.Fate.ACTOR,
	Bozo.Fate.BLACKSMITH,
	Bozo.Fate.TAILOR,
	Bozo.Fate.COOK,
	Bozo.Fate.HUCKSTER,
	Bozo.Fate.EXECUTIONER,
	Bozo.Fate.THIEF,
	Bozo.Fate.SHARPIE,
	Bozo.Fate.DRUNKARD,
	Bozo.Fate.COURTESAN,
]

const faction_to_fate = {
	Bozo.Faction.NOBILITY: [
		Bozo.Fate.HEIR,
		Bozo.Fate.COLLECTOR,
		Bozo.Fate.GOURMET,
		Bozo.Fate.DUELIST,
		Bozo.Fate.MASHER,
	],
	Bozo.Faction.ARTISAN: [
		Bozo.Fate.ACTOR,
		Bozo.Fate.BLACKSMITH,
		Bozo.Fate.TAILOR,
		Bozo.Fate.COOK,
		Bozo.Fate.HUCKSTER,
	],
	Bozo.Faction.RIFFRAFF: [
		Bozo.Fate.EXECUTIONER,
		Bozo.Fate.THIEF,
		Bozo.Fate.SHARPIE,
		Bozo.Fate.DRUNKARD,
		Bozo.Fate.COURTESAN,
	],
}

const fate_to_faction = {
	Bozo.Fate.HEIR: Bozo.Faction.NOBILITY,
	Bozo.Fate.COLLECTOR: Bozo.Faction.NOBILITY,
	Bozo.Fate.GOURMET: Bozo.Faction.NOBILITY,
	Bozo.Fate.DUELIST: Bozo.Faction.NOBILITY,
	Bozo.Fate.MASHER: Bozo.Faction.NOBILITY,
	Bozo.Fate.ACTOR: Bozo.Faction.ARTISAN,
	Bozo.Fate.BLACKSMITH: Bozo.Faction.ARTISAN,
	Bozo.Fate.TAILOR: Bozo.Faction.ARTISAN,
	Bozo.Fate.COOK: Bozo.Faction.ARTISAN,
	Bozo.Fate.HUCKSTER: Bozo.Faction.ARTISAN,
	Bozo.Fate.EXECUTIONER: Bozo.Faction.RIFFRAFF,
	Bozo.Fate.THIEF: Bozo.Faction.RIFFRAFF,
	Bozo.Fate.SHARPIE: Bozo.Faction.RIFFRAFF,
	Bozo.Fate.DRUNKARD: Bozo.Faction.RIFFRAFF,
	Bozo.Fate.COURTESAN: Bozo.Faction.RIFFRAFF,
}

const fate_to_string = {
	Bozo.Fate.HEIR: "heir",
	Bozo.Fate.COLLECTOR: "collector",
	Bozo.Fate.GOURMET: "gourmet",
	Bozo.Fate.DUELIST: "duelist",
	Bozo.Fate.MASHER: "masher",
	Bozo.Fate.ACTOR: "actor",
	Bozo.Fate.BLACKSMITH: "blacksmith",
	Bozo.Fate.TAILOR: "tailor",
	Bozo.Fate.COOK: "cook",
	Bozo.Fate.HUCKSTER: "huckster",
	Bozo.Fate.EXECUTIONER: "executioner",
	Bozo.Fate.THIEF: "thief",
	Bozo.Fate.SHARPIE: "sharpie",
	Bozo.Fate.DRUNKARD: "drunkard",
	Bozo.Fate.COURTESAN: "courtesan",
}

const fate_to_sin = {
	Bozo.Fate.HEIR: [Bozo.Sin.PRIDE, Bozo.Sin.ENVY],
	Bozo.Fate.COLLECTOR: [Bozo.Sin.PRIDE, Bozo.Sin.GREED],
	Bozo.Fate.GOURMET: [Bozo.Sin.PRIDE, Bozo.Sin.GLUTTONY],
	Bozo.Fate.DUELIST: [Bozo.Sin.ANGER, Bozo.Sin.LUST],
	Bozo.Fate.MASHER: [Bozo.Sin.LUST, Bozo.Sin.GLUTTONY],
	Bozo.Fate.ACTOR: [Bozo.Sin.PRIDE, Bozo.Sin.LUST],
	Bozo.Fate.BLACKSMITH: [Bozo.Sin.ENVY, Bozo.Sin.ANGER],
	Bozo.Fate.TAILOR: [Bozo.Sin.ENVY, Bozo.Sin.LUST],
	Bozo.Fate.COOK: [Bozo.Sin.ENVY, Bozo.Sin.GLUTTONY],
	Bozo.Fate.HUCKSTER: [Bozo.Sin.GREED, Bozo.Sin.GLUTTONY],
	Bozo.Fate.EXECUTIONER: [Bozo.Sin.PRIDE, Bozo.Sin.ANGER],
	Bozo.Fate.THIEF: [Bozo.Sin.ENVY, Bozo.Sin.GREED],
	Bozo.Fate.SHARPIE: [Bozo.Sin.ANGER, Bozo.Sin.GREED],
	Bozo.Fate.DRUNKARD: [Bozo.Sin.ANGER, Bozo.Sin.GLUTTONY],
	Bozo.Fate.COURTESAN: [Bozo.Sin.LUST, Bozo.Sin.GREED],
}

const faction_to_color = {
	Bozo.Faction.NOBILITY: Color.AQUA,
	Bozo.Faction.ARTISAN: Color.OLIVE,
	Bozo.Faction.RIFFRAFF: Color.WEB_PURPLE,
}

#endregion

#region trial
const trials = [
	Bozo.Trial.BATTLE,
	Bozo.Trial.AUCTION,
	Bozo.Trial.FEAST,
	Bozo.Trial.MASQUERADE,
	Bozo.Trial.THEATER,
]

const trial_to_string = {
	Bozo.Trial.BATTLE: "battle",
	Bozo.Trial.AUCTION: "auction",
	Bozo.Trial.FEAST: "feast",
	Bozo.Trial.MASQUERADE: "masquerade",
	Bozo.Trial.THEATER: "theater",
}

const trial_to_color = {
	Bozo.Trial.BATTLE: Color.INDIAN_RED,
	Bozo.Trial.AUCTION: Color.KHAKI,
	Bozo.Trial.FEAST: Color.PALE_GREEN,
	Bozo.Trial.MASQUERADE: Color.SKY_BLUE,
	Bozo.Trial.THEATER: Color.MEDIUM_PURPLE,
}

const trial_to_sin = {
	Bozo.Trial.BATTLE: {
		Bozo.Sin.ANGER: 3,
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.LUST: 1,
		Bozo.Sin.PRIDE: 1,
	},
	Bozo.Trial.AUCTION: {
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.GREED: 3,
		Bozo.Sin.GLUTTONY: 1,
		Bozo.Sin.PRIDE: 1,
	},
	Bozo.Trial.FEAST: {
		Bozo.Sin.ANGER: 1,
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.GLUTTONY: 3,
		Bozo.Sin.PRIDE: 1,
	},
	Bozo.Trial.MASQUERADE: {
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.GREED: 1,
		Bozo.Sin.GLUTTONY: 1,
		Bozo.Sin.LUST: 3,
	},
	Bozo.Trial.THEATER: {
		Bozo.Sin.ANGER: 1,
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.GREED: 1,
		Bozo.Sin.LUST: 1,
		Bozo.Sin.PRIDE: 2,
	},
}

const fate_to_trial = {
	Bozo.Fate.HEIR: Bozo.Trial.THEATER,
	Bozo.Fate.COLLECTOR: Bozo.Trial.AUCTION,
	Bozo.Fate.GOURMET: Bozo.Trial.FEAST,
	Bozo.Fate.DUELIST: Bozo.Trial.BATTLE,
	Bozo.Fate.MASHER: Bozo.Trial.MASQUERADE,
	Bozo.Fate.ACTOR: Bozo.Trial.THEATER,
	Bozo.Fate.BLACKSMITH: Bozo.Trial.BATTLE,
	Bozo.Fate.TAILOR: Bozo.Trial.THEATER,
	Bozo.Fate.COOK: Bozo.Trial.FEAST,
	Bozo.Fate.HUCKSTER: Bozo.Trial.AUCTION,
	Bozo.Fate.EXECUTIONER: Bozo.Trial.BATTLE,
	Bozo.Fate.THIEF: Bozo.Trial.AUCTION,
	Bozo.Fate.SHARPIE: Bozo.Trial.MASQUERADE,
	Bozo.Fate.DRUNKARD: Bozo.Trial.FEAST,
	Bozo.Fate.COURTESAN: Bozo.Trial.MASQUERADE,
}

const faction_to_trial = {
	Bozo.Faction.NOBILITY: {
		Bozo.Trial.THEATER: 1,
		Bozo.Trial.FEAST: 1,
		Bozo.Trial.AUCTION: 3,
		Bozo.Trial.MASQUERADE: 2,
	},
	Bozo.Faction.ARTISAN: {
		Bozo.Trial.BATTLE: 3,
		Bozo.Trial.FEAST: 2,
		Bozo.Trial.MASQUERADE: 1,
	},
	Bozo.Faction.RIFFRAFF: {
		Bozo.Trial.THEATER: 3,
		Bozo.Trial.BATTLE: 1,
		Bozo.Trial.FEAST: 2,
		Bozo.Trial.AUCTION: 1,
		Bozo.Trial.MASQUERADE: 1,
	},
}

const sin_to_trial = {
	Bozo.Sin.ANGER: [Bozo.Trial.BATTLE, Bozo.Trial.FEAST, Bozo.Trial.THEATER],
	Bozo.Sin.ENVY: [Bozo.Trial.BATTLE, Bozo.Trial.AUCTION, Bozo.Trial.FEAST, Bozo.Trial.MASQUERADE, Bozo.Trial.THEATER],
	Bozo.Sin.GREED: [Bozo.Trial.AUCTION, Bozo.Trial.FEAST, Bozo.Trial.THEATER],
	Bozo.Sin.GLUTTONY: [Bozo.Trial.AUCTION, Bozo.Trial.FEAST, Bozo.Trial.MASQUERADE],
	Bozo.Sin.LUST: [Bozo.Trial.BATTLE, Bozo.Trial.MASQUERADE, Bozo.Trial.THEATER],
	Bozo.Sin.PRIDE: [Bozo.Trial.BATTLE, Bozo.Trial.AUCTION, Bozo.Trial.FEAST, Bozo.Trial.THEATER]
}

var trial_sin_requirements: Array[int] = [2, 3, 5]
var trial_sin_amounts: Array[int] = [1, 1, 1, 2, 2, 3]

const TRIAL_MIN_SIN_AMOUNT: int = 2
#endregion

#region rank
const judgment_to_string = {
	Bozo.Judgment.RANK: "rank"
}

const traits = [
	Bozo.Triat.FEAR,
	Bozo.Triat.HORROR,
	Bozo.Triat.GUILT,
	Bozo.Triat.REPOSE
]

const rank_to_trait_to_amount = {
	-1: {
		Bozo.Triat.FEAR: [[1, 1], [2]],
		Bozo.Triat.HORROR: [[2, 2], [4]],
		Bozo.Triat.GUILT: [[0]],
		Bozo.Triat.REPOSE: [[0]],
	},
	0: {
		Bozo.Triat.FEAR: [[2, 1], [3]],
		Bozo.Triat.HORROR: [[3, 3], [4, 2]],
		Bozo.Triat.GUILT: [[1]],
		Bozo.Triat.REPOSE: [[1]],
	},
	1: {
		Bozo.Triat.FEAR: [[2, 2], [4]],
		Bozo.Triat.HORROR: [[4, 4], [6, 2]],
		Bozo.Triat.GUILT: [[2]],
		Bozo.Triat.REPOSE: [[2]],
	},
	2: {
		Bozo.Triat.FEAR: [[3, 2], [5]],
		Bozo.Triat.HORROR: [[5, 5], [7, 3]],
		Bozo.Triat.GUILT: [[3]],
		Bozo.Triat.REPOSE: [[3]],
	},
}

const combination_to_weight = {
	0: 5,
	1: 3,
	2: 2,
}

var rank_combinations = [
	[0, 0, 0, 1],
	[-1, 0, 1, 1],
	[-1, 0, 0, 2]
]
#endregion

#region posture
const posture_to_string = {
	Bozo.Posture.OBLIVION: "oblivion",
	Bozo.Posture.MADNESS: "madness"
}

const posture_to_color = {
	Bozo.Posture.OBLIVION: Color.SLATE_GRAY,
	Bozo.Posture.MADNESS: Color.DEEP_PINK
}
#endregion

#region windrose
var windroses = [
	Bozo.Windrose.NW,
	Bozo.Windrose.N,
	Bozo.Windrose.NE,
	Bozo.Windrose.W,
	Bozo.Windrose.ESWN,
	Bozo.Windrose.E,
	Bozo.Windrose.SW,
	Bozo.Windrose.S,
	Bozo.Windrose.SE,
]

var tribute_windroses = [
	Bozo.Windrose.NW,
	Bozo.Windrose.W,
	Bozo.Windrose.SW,
	Bozo.Windrose.N,
	Bozo.Windrose.ESWN,
	Bozo.Windrose.S,
	Bozo.Windrose.NE,
	Bozo.Windrose.E,
	Bozo.Windrose.SE,
]

var windrose_to_trait_to_indexs = {
	Bozo.Triat.FEAR: {
		Bozo.Windrose.NW: [0, 1, 2, 3, 6],
		Bozo.Windrose.N: [0, 1, 2, 4, 7],
		Bozo.Windrose.NE: [0, 1, 2, 5, 8],
		Bozo.Windrose.W: [0, 3, 4, 5, 6],
		Bozo.Windrose.ESWN: [1, 3, 4, 5, 7],
		Bozo.Windrose.E: [2, 3, 4, 5, 8],
		Bozo.Windrose.SW: [0, 3, 6, 6, 7, 8],
		Bozo.Windrose.S: [1, 4, 6, 7, 8],
		Bozo.Windrose.SE: [2, 5, 6, 7, 8],
	},
	Bozo.Triat.HORROR: {
		Bozo.Windrose.NW: [4, 5, 7, 8],
		Bozo.Windrose.W: [1, 2, 7, 8],
		Bozo.Windrose.SW: [1, 2, 4, 5],
		Bozo.Windrose.N: [5, 8],
		Bozo.Windrose.ESWN: [2, 8],
		Bozo.Windrose.S: [2, 5],
		Bozo.Windrose.NE: [],
		Bozo.Windrose.E: [],
		Bozo.Windrose.SE: [],
	},
	Bozo.Triat.REPOSE:{
		Bozo.Windrose.NW: [],
		Bozo.Windrose.W: [],
		Bozo.Windrose.SW: [],
		Bozo.Windrose.N: [3, 6],
		Bozo.Windrose.ESWN: [0, 6],
		Bozo.Windrose.S: [0, 3],
		Bozo.Windrose.NE: [3, 4, 6, 7],
		Bozo.Windrose.E: [0, 1, 6, 7],
		Bozo.Windrose.SE: [0, 1, 3, 4],
	},
	Bozo.Triat.GUILT: {
		Bozo.Windrose.NW: [0],
		Bozo.Windrose.W: [3],
		Bozo.Windrose.SW: [6],
		Bozo.Windrose.N: [1],
		Bozo.Windrose.ESWN: [4],
		Bozo.Windrose.S: [7],
		Bozo.Windrose.NE: [2],
		Bozo.Windrose.E: [5],
		Bozo.Windrose.SE: [8],
	}
}
#endregion

#region volcano
const VOLCANO_SPRITE_SIZE = Vector2(48, 48)
const DEFAULT_ERUPTION_COUNT: int = 100
const DEFAULT_SPLASH_COUNT: int = 100
const ERUPTION_OFFSET_L: float = 4

const ERUPTION_DURATION: float = 0.8
const TRAIL_DURATION: float =  0.4
const VOLCANO_BURST_DURATION: float =  0.8
#endregion

#region blob
const blob_to_string = {
	Bozo.Blob.PLUS: "plus",
	Bozo.Blob.MINUS: "minus"
}

const blob_default_color = Color.LIGHT_SLATE_GRAY
#endregion

#region progression
const attitude_to_string = {
	Bozo.Attitude.RAPTURE: "rapture",
	Bozo.Attitude.FAVOR: "favor",
	Bozo.Attitude.INDIFFERENCE: "indifference",
	Bozo.Attitude.DISFAVOR: "disfavor",
	Bozo.Attitude.SCORN: "scorn",
}

const half_to_string = {
	Bozo.Half.LESS: "less",
	Bozo.Half.MORE: "more",
	Bozo.Half.DOUBLE: "double",
}
#endregion

#region desire
const PRIMARY_DESIRE_COUNT: int = 2
const SECONDARY_DESIRE_COUNT: int = 1
const DESIRE_DISSOLVE_DURATION: float = 0.2#1.2
const SPASH_DURATION: float = 0.2#0.5

const desires = [
	Bozo.Desire.SWORD,
	Bozo.Desire.COIN,
	Bozo.Desire.WINE,
	Bozo.Desire.MASK,
	Bozo.Desire.SCROLL,
]

const desire_to_string = {
	Bozo.Desire.SWORD: "sword",
	Bozo.Desire.COIN: "coin",
	Bozo.Desire.WINE: "wine",
	Bozo.Desire.MASK: "mask",
	Bozo.Desire.SCROLL: "scroll",
}

const desire_to_trial = {
	Bozo.Desire.SWORD: Bozo.Trial.BATTLE,
	Bozo.Desire.COIN: Bozo.Trial.AUCTION,
	Bozo.Desire.WINE: Bozo.Trial.FEAST,
	Bozo.Desire.MASK: Bozo.Trial.MASQUERADE,
	Bozo.Desire.SCROLL: Bozo.Trial.THEATER,
}

const trial_to_desire = {
	Bozo.Trial.BATTLE: Bozo.Desire.SWORD,
	Bozo.Trial.AUCTION: Bozo.Desire.COIN,
	Bozo.Trial.FEAST: Bozo.Desire.WINE,
	Bozo.Trial.MASQUERADE: Bozo.Desire.MASK,
	Bozo.Trial.THEATER: Bozo.Desire.SCROLL,
}

const desire_to_angle = {
	Bozo.Desire.SWORD: -45.0,
	Bozo.Desire.COIN: 45,
	Bozo.Desire.WINE: 90,
	Bozo.Desire.MASK: 0,
	Bozo.Desire.SCROLL: 180,
}

const desire_to_color = {
	Bozo.Desire.SWORD: Color(0.812, 0.157, 0.157),
	Bozo.Desire.COIN: Color(0.941, 0.859, 0.137),
	Bozo.Desire.WINE: Color(0.145, 0.871, 0.145),
	Bozo.Desire.MASK: Color(0.188, 0.714, 0.922),
	Bozo.Desire.SCROLL: Color(0.42, 0.184, 0.89),
}
#endregion


const phases = [
	Bozo.Phase.ENDOWMENT,
	Bozo.Phase.REPLENISHMENT,
	Bozo.Phase.PAYMENT,
	Bozo.Phase.APPRAISEMENT,
	Bozo.Phase.DISBURSEMENT,
	Bozo.Phase.INVESTMENT,
]

const phase_to_next = {
	Bozo.Phase.ENDOWMENT: Bozo.Phase.REPLENISHMENT,
	Bozo.Phase.REPLENISHMENT: Bozo.Phase.PAYMENT,
	Bozo.Phase.PAYMENT: Bozo.Phase.APPRAISEMENT,
	Bozo.Phase.APPRAISEMENT: Bozo.Phase.DISBURSEMENT,
	Bozo.Phase.DISBURSEMENT: Bozo.Phase.INVESTMENT,
	Bozo.Phase.INVESTMENT: Bozo.Phase.REPLENISHMENT
}

var type_to_tooltip = {
	Bozo.Sin.ANGER: Bozo.Tooltip.SIN,
	Bozo.Sin.ENVY: Bozo.Tooltip.SIN,
	Bozo.Sin.GREED: Bozo.Tooltip.SIN,
	Bozo.Sin.GLUTTONY: Bozo.Tooltip.SIN,
	Bozo.Sin.LUST: Bozo.Tooltip.SIN,
	Bozo.Sin.PRIDE: Bozo.Tooltip.SIN,
	Bozo.Posture.MADNESS: Bozo.Tooltip.MADNESS,
	Bozo.Posture.OBLIVION: Bozo.Tooltip.OBLIVION,
	Bozo.Half.LESS: Bozo.Tooltip.ACTIVITY,
	Bozo.Half.MORE: Bozo.Tooltip.ACTIVITY,
	Bozo.Half.DOUBLE: Bozo.Tooltip.ACTIVITY,
	Bozo.Attitude.RAPTURE: Bozo.Tooltip.ATTITUIDE,
	Bozo.Attitude.FAVOR: Bozo.Tooltip.ATTITUIDE,
	Bozo.Attitude.INDIFFERENCE: Bozo.Tooltip.ATTITUIDE,
	Bozo.Attitude.DISFAVOR: Bozo.Tooltip.ATTITUIDE,
	Bozo.Attitude.SCORN: Bozo.Tooltip.ATTITUIDE,
	Bozo.Trial.BATTLE: Bozo.Tooltip.TRIAL,
	Bozo.Trial.AUCTION: Bozo.Tooltip.TRIAL,
	Bozo.Trial.FEAST: Bozo.Tooltip.TRIAL,
	Bozo.Trial.MASQUERADE: Bozo.Tooltip.TRIAL,
	Bozo.Trial.THEATER: Bozo.Tooltip.TRIAL,
	Bozo.Tooltip.FLAME: Bozo.Tooltip.FLAME,
	Bozo.Faction.NOBILITY: Bozo.Tooltip.FACTION,
	Bozo.Faction.RIFFRAFF: Bozo.Tooltip.FACTION,
	Bozo.Faction.ARTISAN: Bozo.Tooltip.FACTION,
	Bozo.Fate.HEIR: Bozo.Tooltip.FATE,
	Bozo.Fate.COLLECTOR: Bozo.Tooltip.FATE,
	Bozo.Fate.GOURMET: Bozo.Tooltip.FATE,
	Bozo.Fate.DUELIST: Bozo.Tooltip.FATE,
	Bozo.Fate.MASHER: Bozo.Tooltip.FATE,
	Bozo.Fate.ACTOR: Bozo.Tooltip.FATE,
	Bozo.Fate.BLACKSMITH: Bozo.Tooltip.FATE,
	Bozo.Fate.TAILOR: Bozo.Tooltip.FATE,
	Bozo.Fate.COOK: Bozo.Tooltip.FATE,
	Bozo.Fate.HUCKSTER: Bozo.Tooltip.FATE,
	Bozo.Fate.EXECUTIONER: Bozo.Tooltip.FATE,
	Bozo.Fate.THIEF: Bozo.Tooltip.FATE,
	Bozo.Fate.SHARPIE: Bozo.Tooltip.FATE,
	Bozo.Fate.DRUNKARD: Bozo.Tooltip.FATE,
	Bozo.Fate.COURTESAN: Bozo.Tooltip.FATE,
	Bozo.Tooltip.CAGE: Bozo.Tooltip.CAGE,
	Bozo.Tooltip.SOUL: Bozo.Tooltip.SOUL,
	Bozo.Tooltip.SINNER: Bozo.Tooltip.SINNER,
	Bozo.Tooltip.CLOAK: Bozo.Tooltip.CLOAK,
	Bozo.Desire.SWORD: Bozo.Tooltip.DESIRE,
	Bozo.Desire.COIN: Bozo.Tooltip.DESIRE,
	Bozo.Desire.WINE: Bozo.Tooltip.DESIRE,
	Bozo.Desire.MASK: Bozo.Tooltip.DESIRE,
	Bozo.Desire.SCROLL: Bozo.Tooltip.DESIRE,
}

const string_to_tooltip = {
	"essense": Bozo.Tooltip.ESSENCE,
	"attitude": Bozo.Tooltip.ATTITUIDE,
	"overlord": Bozo.Tooltip.OVERLORD,
	"flame": Bozo.Tooltip.FLAME,
	"activity": Bozo.Tooltip.ACTIVITY,
	"claim": Bozo.Tooltip.CLAIM,
	"desire": Bozo.Tooltip.DESIRE,
	"faction": Bozo.Tooltip.FACTION,
	"soul": Bozo.Tooltip.SOUL,
	"fate": Bozo.Tooltip.FATE,
	"cage": Bozo.Tooltip.CAGE
}

var tooltip_to_template = {
	Bozo.Tooltip.SIN: "Produces %s [ghost][meta essense]Essense[/meta][/ghost]",
	Bozo.Tooltip.ESSENCE: "Primal hell currency",
	Bozo.Tooltip.MADNESS: "Makes the game more difficult",
	Bozo.Tooltip.OBLIVION: "Makes the game easier",
	Bozo.Tooltip.ACTIVITY: "Changes [ghost][meta attitude]Attitude[/meta][/ghost]",
	Bozo.Tooltip.ATTITUIDE: "Shows relationship with [ghost][meta overlord]Overlord[/meta][/ghost]",
	Bozo.Tooltip.OVERLORD: "Uses [ghost][meta trial]Trial[/meta][/ghost] to collect [ghost][meta essense]Essence[/meta][/ghost]",
	Bozo.Tooltip.TRIAL: "[ghost][meta overlord]Overlord[/meta][/ghost] domain is formed from [ghost][meta claim]Claim[/meta][/ghost], [ghost][meta flame]Flame[/meta][/ghost] and [ghost][meta attitude]Attitude[/meta][/ghost]",
	Bozo.Tooltip.FLAME: "Raises [ghost][meta claim]Claim[/meta][/ghost], grows from [ghost][meta desire]Desire[/meta][/ghost]",
	Bozo.Tooltip.CLAIM: "Offerings for [ghost][meta overlord]Overlord[/meta][/ghost] this round",
	Bozo.Tooltip.DESIRE: "Raises [ghost][meta flame]Flame[/meta][/ghost] when occupying a [ghost][meta cage]Cage[/meta][/ghost], depends on [ghost][meta faction]Faction[/meta][/ghost]",
	Bozo.Tooltip.FATE: "Defines [ghost][meta faction]Faction[/meta][/ghost] and [ghost][meta soul]Soul[/meta][/ghost]",
	Bozo.Tooltip.SOUL: "Specifies a set of [ghost][meta sin]Sin[/meta][/ghost]",
	Bozo.Tooltip.FACTION: "Unites sinners, defines [ghost][meta desire]Desire[/meta][/ghost]",
	Bozo.Tooltip.CAGE: "Contains [ghost][meta sinner]Sinner[/meta][/ghost] and [ghost][meta cloak]Cloak[/meta][/ghost]",
	Bozo.Tooltip.SINNER: "Shows [ghost][meta fate]Fate[/meta][/ghost], [ghost][meta faction]Faction[/meta][/ghost] and [ghost][meta soul]Soul[/meta][/ghost] as frontside",
	Bozo.Tooltip.CLOAK: "Shows [ghost][meta desire]Desire[/meta][/ghost] as backside",
}

var tooltip_to_string = {
	Bozo.Tooltip.SIN: "sin",
	Bozo.Tooltip.ESSENCE: "essence",
	Bozo.Tooltip.MADNESS: "madness",
	Bozo.Tooltip.OBLIVION: "oblivion",
	Bozo.Tooltip.ACTIVITY: "activity",
	Bozo.Tooltip.ATTITUIDE: "attitude",
	Bozo.Tooltip.TRIAL: "trial",
	Bozo.Tooltip.FLAME: "flame",
	Bozo.Tooltip.CLAIM: "claim",
	Bozo.Tooltip.DESIRE: "desire",
	Bozo.Tooltip.FACTION: "faction",
	Bozo.Tooltip.SOUL: "soul",
	Bozo.Tooltip.FATE: "fate",
	Bozo.Tooltip.CAGE: "cage",
	Bozo.Tooltip.SINNER: "sinner",
	Bozo.Tooltip.CLOAK: "cloak",
}
