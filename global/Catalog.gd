extends Node


#region cage
const JAIL_CAGE_GRID = Vector2i(3, 3)
const CAGE_SIZE = Vector2(214, 238)#Vector2(188, 212)
const SINNER_PANEL_SIZE = Vector2(172, 196)

const JAIL_SIZE = Vector2(650, 722)#Vector2(548, 632)

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
	Bozo.Trait.FEAR: "fear",
	Bozo.Trait.HORROR: "horror",
	Bozo.Trait.GUILT: "guilt",
	Bozo.Trait.REPOSE: "repose"
}

const trait_to_cage = {
	null: Bozo.Cage.NONE,
	Bozo.Trait.FEAR: Bozo.Cage.MIDDLE,
	Bozo.Trait.HORROR: Bozo.Cage.RIGHT,
	Bozo.Trait.GUILT: Bozo.Cage.CENTER,
	Bozo.Trait.REPOSE: Bozo.Cage.LEFT
}

const cage_to_traits = {
	Bozo.Cage.NONE: [Bozo.Trait.FEAR, Bozo.Trait.HORROR, Bozo.Trait.GUILT, Bozo.Trait.REPOSE],
	Bozo.Cage.MIDDLE: [Bozo.Trait.FEAR],
	Bozo.Cage.RIGHT: [Bozo.Trait.HORROR],
	Bozo.Cage.CENTER: [Bozo.Trait.GUILT, Bozo.Trait.FEAR],
	Bozo.Cage.LEFT: [Bozo.Trait.REPOSE]
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

var sin_to_color = {
	Bozo.Sin.PRIDE: Color.from_hsv(0.75, 0.9, 0.9),
	Bozo.Sin.ENVY: Color.from_hsv(0.08, 0.9, 0.9),
	Bozo.Sin.ANGER: Color.from_hsv(0.0, 0.9, 0.9),
	Bozo.Sin.LUST: Color.from_hsv(0.6, 0.9, 0.9),
	Bozo.Sin.GREED: Color.from_hsv(0.15, 0.9, 0.9),
	Bozo.Sin.GLUTTONY: Color.from_hsv(0.4, 0.9, 0.9),
}

const sin_to_string = {
	Bozo.Sin.PRIDE: "pride",
	Bozo.Sin.ENVY: "envy",
	Bozo.Sin.ANGER: "anger",
	Bozo.Sin.LUST: "lust",
	Bozo.Sin.GREED: "greed",
	Bozo.Sin.GLUTTONY: "gluttony",
}

const ambers = [
	Bozo.Amber.ANGER,
	Bozo.Amber.ENVY,
	Bozo.Amber.GREED,
	Bozo.Amber.GLUTTONY,
	Bozo.Amber.LUST,
	Bozo.Amber.PRIDE,
	Bozo.Amber.INDOLENCE,
]

const deal_ambers = [
	Bozo.Amber.ANGER,
	Bozo.Amber.ENVY,
	Bozo.Amber.GREED,
	Bozo.Amber.GLUTTONY,
	Bozo.Amber.LUST,
	Bozo.Amber.PRIDE,
]

var amber_to_color = {
	Bozo.Amber.PRIDE: Color.from_hsv(0.75, 0.7, 0.6),
	Bozo.Amber.ENVY: Color.from_hsv(0.08, 0.7, 0.6),
	Bozo.Amber.ANGER: Color.from_hsv(0.0, 0.7, 0.6),
	Bozo.Amber.LUST: Color.from_hsv(0.6, 0.7, 0.6),
	Bozo.Amber.GREED: Color.from_hsv(0.15, 0.7, 0.6),
	Bozo.Amber.GLUTTONY: Color.from_hsv(0.4, 0.7, 0.6),
	Bozo.Amber.INDOLENCE: Color.from_hsv(1.0, 0.0, 1.0)
}

const amber_to_string = {
	Bozo.Amber.PRIDE: "pride",
	Bozo.Amber.ENVY: "envy",
	Bozo.Amber.ANGER: "anger",
	Bozo.Amber.LUST: "lust",
	Bozo.Amber.GREED: "greed",
	Bozo.Amber.GLUTTONY: "gluttony",
	Bozo.Amber.INDOLENCE: "indolence",
}

const amber_to_sin = {
	Bozo.Amber.ANGER: Bozo.Sin.ANGER,
	Bozo.Amber.ENVY: Bozo.Sin.ENVY,
	Bozo.Amber.GREED: Bozo.Sin.GREED,
	Bozo.Amber.GLUTTONY: Bozo.Sin.GLUTTONY,
	Bozo.Amber.LUST: Bozo.Sin.LUST,
	Bozo.Amber.PRIDE: Bozo.Sin.PRIDE,
}

const sin_to_token = {
	Bozo.Sin.ANGER: Bozo.Token.ANGER,
	Bozo.Sin.ENVY: Bozo.Token.ENVY,
	Bozo.Sin.GREED: Bozo.Token.GREED,
	Bozo.Sin.GLUTTONY: Bozo.Token.GLUTTONY,
	Bozo.Sin.LUST: Bozo.Token.LUST,
	Bozo.Sin.PRIDE: Bozo.Token.PRIDE,
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
	Bozo.Fate.ADULTERER,
	Bozo.Fate.ACTOR,
	Bozo.Fate.BLACKSMITH,
	Bozo.Fate.TAILOR,
	Bozo.Fate.COOK,
	Bozo.Fate.MONGER,
	Bozo.Fate.EXECUTIONER,
	Bozo.Fate.THIEF,
	Bozo.Fate.SHARPIE,
	Bozo.Fate.DRUNKARD,
	Bozo.Fate.COURTESAN,
]

const factions = [
	Bozo.Faction.ARTISAN,
	Bozo.Faction.NOBILITY,
	Bozo.Faction.RIFFRAFF,
]


const faction_to_string = {
	Bozo.Faction.NOBILITY: "nobility",
	Bozo.Faction.ARTISAN: "artisan",
	Bozo.Faction.RIFFRAFF: "riffraff",
}

const faction_to_direction = {
	Bozo.Faction.ARTISAN: 1,
	Bozo.Faction.NOBILITY: 2,
	Bozo.Faction.RIFFRAFF: 3,
}

const faction_to_fate = {
	Bozo.Faction.NOBILITY: [
		Bozo.Fate.HEIR,
		Bozo.Fate.COLLECTOR,
		Bozo.Fate.GOURMET,
		Bozo.Fate.DUELIST,
		Bozo.Fate.ADULTERER,
	],
	Bozo.Faction.ARTISAN: [
		Bozo.Fate.ACTOR,
		Bozo.Fate.BLACKSMITH,
		Bozo.Fate.TAILOR,
		Bozo.Fate.COOK,
		Bozo.Fate.MONGER,
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
	Bozo.Fate.ADULTERER: Bozo.Faction.NOBILITY,
	Bozo.Fate.ACTOR: Bozo.Faction.ARTISAN,
	Bozo.Fate.BLACKSMITH: Bozo.Faction.ARTISAN,
	Bozo.Fate.TAILOR: Bozo.Faction.ARTISAN,
	Bozo.Fate.COOK: Bozo.Faction.ARTISAN,
	Bozo.Fate.MONGER: Bozo.Faction.ARTISAN,
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
	Bozo.Fate.ADULTERER: "adulterer",
	Bozo.Fate.ACTOR: "actor",
	Bozo.Fate.BLACKSMITH: "blacksmith",
	Bozo.Fate.TAILOR: "tailor",
	Bozo.Fate.COOK: "cook",
	Bozo.Fate.MONGER: "monger",
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
	Bozo.Fate.ADULTERER: [Bozo.Sin.LUST, Bozo.Sin.GLUTTONY],
	Bozo.Fate.ACTOR: [Bozo.Sin.PRIDE, Bozo.Sin.LUST],
	Bozo.Fate.BLACKSMITH: [Bozo.Sin.ENVY, Bozo.Sin.ANGER],
	Bozo.Fate.TAILOR: [Bozo.Sin.ENVY, Bozo.Sin.LUST],
	Bozo.Fate.COOK: [Bozo.Sin.ENVY, Bozo.Sin.GLUTTONY],
	Bozo.Fate.MONGER: [Bozo.Sin.GREED, Bozo.Sin.GLUTTONY],
	Bozo.Fate.EXECUTIONER: [Bozo.Sin.PRIDE, Bozo.Sin.ANGER],
	Bozo.Fate.THIEF: [Bozo.Sin.ENVY, Bozo.Sin.GREED],
	Bozo.Fate.SHARPIE: [Bozo.Sin.ANGER, Bozo.Sin.GREED],
	Bozo.Fate.DRUNKARD: [Bozo.Sin.ANGER, Bozo.Sin.GLUTTONY],
	Bozo.Fate.COURTESAN: [Bozo.Sin.LUST, Bozo.Sin.GREED],
}

const faction_to_color = {
	Bozo.Faction.NOBILITY: Color.AQUA,
	Bozo.Faction.ARTISAN: Color.LIME,#Color.OLIVE,
	Bozo.Faction.RIFFRAFF: Color.CRIMSON#Color.PURPLE,
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
	Bozo.Fate.ADULTERER: Bozo.Trial.MASQUERADE,
	Bozo.Fate.ACTOR: Bozo.Trial.THEATER,
	Bozo.Fate.BLACKSMITH: Bozo.Trial.BATTLE,
	Bozo.Fate.TAILOR: Bozo.Trial.THEATER,
	Bozo.Fate.COOK: Bozo.Trial.FEAST,
	Bozo.Fate.MONGER: Bozo.Trial.AUCTION,
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

const trial_to_eruption = {
	Bozo.Trial.BATTLE: Bozo.Eruption.BATTLE,
	Bozo.Trial.AUCTION: Bozo.Eruption.AUCTION,
	Bozo.Trial.FEAST: Bozo.Eruption.FEAST,
	Bozo.Trial.MASQUERADE: Bozo.Eruption.MASQUERADE,
	Bozo.Trial.THEATER: Bozo.Eruption.THEATER,
}

var trial_sin_requirements: Array[int] = [2, 3, 5]
var trial_sin_amounts: Array[int] = [1, 1, 1, 2, 2, 3]

const TRIAL_MIN_SIN_AMOUNT: int = 2
#endregion

#region flame
const flame_to_claim = {
	1: [5, 3, 2],
	2: [8, 5, 3],
	3: [13, 8, 5],
	4: [21, 13, 8]
}

const flame_to_heat = {
	1: 15,
	2: 20,
	3: 25,
	4: 30
}
#endregion

#region rank
const judgment_to_string = {
	Bozo.Judgment.RANK: "rank",
	Bozo.Judgment.TRIBUTE: "tribute"
}

const judgment_to_color = {
	Bozo.Judgment.TRIBUTE: Color.DARK_SLATE_GRAY
}


const traits = [
	Bozo.Trait.FEAR,
	Bozo.Trait.HORROR,
	Bozo.Trait.GUILT,
	Bozo.Trait.REPOSE
]

const rank_to_trait_to_amount = {
	-1: {
		Bozo.Trait.FEAR: [[1, 1], [2]],
		Bozo.Trait.HORROR: [[2, 2], [4]],
		Bozo.Trait.GUILT: [[0]],
		Bozo.Trait.REPOSE: [[0]],
	},
	0: {
		Bozo.Trait.FEAR: [[2, 1], [3]],
		Bozo.Trait.HORROR: [[3, 3], [4, 2]],
		Bozo.Trait.GUILT: [[1]],
		Bozo.Trait.REPOSE: [[1]],
	},
	1: {
		Bozo.Trait.FEAR: [[2, 2], [4]],
		Bozo.Trait.HORROR: [[4, 4], [6, 2]],
		Bozo.Trait.GUILT: [[2]],
		Bozo.Trait.REPOSE: [[2]],
	},
	2: {
		Bozo.Trait.FEAR: [[3, 2], [5]],
		Bozo.Trait.HORROR: [[5, 5], [7, 3]],
		Bozo.Trait.GUILT: [[3]],
		Bozo.Trait.REPOSE: [[3]],
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
const postures = [
	Bozo.Posture.OBLIVION,
	Bozo.Posture.MADNESS
]
const posture_to_string = {
	Bozo.Posture.OBLIVION: "oblivion",
	Bozo.Posture.MADNESS: "madness"
}

const posture_to_color = {
	Bozo.Posture.OBLIVION: Color.SLATE_GRAY,
	Bozo.Posture.MADNESS: Color.DEEP_PINK
}
const posture_to_token = {
	Bozo.Posture.OBLIVION: Bozo.Token.OBLIVION,
	Bozo.Posture.MADNESS: Bozo.Token.MADNESS
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

var contribution_windroses = [
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
	Bozo.Trait.FEAR: {
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
	Bozo.Trait.HORROR: {
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
	Bozo.Trait.REPOSE:{
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
	Bozo.Trait.GUILT: {
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

const neighbours_coords = [
	Vector2i(0, -1),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
]

const omen_to_windroses = {
	Bozo.Family.PARENT: [
		Bozo.Windrose.NE,
		Bozo.Windrose.SW,
	],
	Bozo.Family.CHILD: [
		Bozo.Windrose.SE,
		Bozo.Windrose.NW,
	],
	Bozo.Destiny.LEADER: [Bozo.Windrose.NW],
	Bozo.Destiny.GENIUS: [Bozo.Windrose.SE],
	Bozo.Destiny.LAYMAN: [Bozo.Windrose.NE],
	Bozo.Destiny.EXILE: [Bozo.Windrose.SW],
}

const windrose_to_anchor = {
	Bozo.Windrose.NE: [
		Control.SIZE_SHRINK_END,
		Control.SIZE_SHRINK_BEGIN
	],
	Bozo.Windrose.SE: [
		Control.SIZE_SHRINK_END,
		Control.SIZE_SHRINK_END
	],
	Bozo.Windrose.SW: [
		Control.SIZE_SHRINK_BEGIN,
		Control.SIZE_SHRINK_END
	],
	Bozo.Windrose.NW: [
		Control.SIZE_SHRINK_BEGIN,
		Control.SIZE_SHRINK_BEGIN
	],
	Bozo.Windrose.N: [
		Control.SIZE_SHRINK_CENTER,
		Control.SIZE_SHRINK_BEGIN
	],
	Bozo.Windrose.E: [
		Control.SIZE_SHRINK_END,
		Control.SIZE_SHRINK_CENTER
	],
	Bozo.Windrose.S: [
		Control.SIZE_SHRINK_CENTER,
		Control.SIZE_SHRINK_END
	],
	Bozo.Windrose.W: [
		Control.SIZE_SHRINK_BEGIN,
		Control.SIZE_SHRINK_CENTER
	],
	Bozo.Windrose.ESWN: [
		Control.SIZE_SHRINK_CENTER,
		Control.SIZE_SHRINK_CENTER
	],
}

const windrose_to_state = {
	Bozo.Windrose.NW: 0,
	Bozo.Windrose.N: 1,
	Bozo.Windrose.NE: 0,
	Bozo.Windrose.W: 4,
	Bozo.Windrose.ESWN: 0,
	Bozo.Windrose.E: 2,
	Bozo.Windrose.SW: 0,
	Bozo.Windrose.S: 3,
	Bozo.Windrose.SE: 0,
	
}
#endregion

#region volcano
const VOLCANO_SPRITE_SIZE = Vector2(48, 48)
const DEFAULT_ERUPTION_COUNT: int = 100
const DEFAULT_TRAIL_COUNT: int = 1500
const DEFAULT_PRESSURE_COUNT: int = 10
const DEFAULT_SPLASH_COUNT: int = 100
const ERUPTION_OFFSET_L: float = 4

const ERUPTION_DURATION: float = 0.4#0.8
const TRAIL_DURATION: float =  0.4#
const VOLCANO_BURST_DURATION: float =  0.4#0.8
const DEAL_BURST_DURATION: float =  0.4#0.8
const PRESSURE_DURATION: float =  0.8#0.8
const TRAIL_INTERVAL: float = 0.012
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

const attitude_to_factor = {
	Bozo.Attitude.RAPTURE: 1,
	Bozo.Attitude.FAVOR: 2,
	Bozo.Attitude.INDIFFERENCE: 3,
	Bozo.Attitude.DISFAVOR: 2,
	Bozo.Attitude.SCORN: 1,
}

const attitude_to_blob_to_attitude = {
	Bozo.Attitude.RAPTURE: {
		Bozo.Blob.PLUS: Bozo.Attitude.INDIFFERENCE,
		Bozo.Blob.MINUS: Bozo.Attitude.FAVOR
	},
	Bozo.Attitude.FAVOR: {
		Bozo.Blob.PLUS: Bozo.Attitude.RAPTURE,
		Bozo.Blob.MINUS: Bozo.Attitude.INDIFFERENCE
	},
	Bozo.Attitude.INDIFFERENCE: {
		Bozo.Blob.PLUS: Bozo.Attitude.FAVOR,
		Bozo.Blob.MINUS: Bozo.Attitude.DISFAVOR
	},
	Bozo.Attitude.DISFAVOR: {
		Bozo.Blob.PLUS: Bozo.Attitude.INDIFFERENCE,
		Bozo.Blob.MINUS: Bozo.Attitude.SCORN
	},
	Bozo.Attitude.SCORN: {
		Bozo.Blob.PLUS: Bozo.Attitude.DISFAVOR,
		Bozo.Blob.MINUS: Bozo.Attitude.INDIFFERENCE
	},
}

const BOWL_LIMIT: int = 6

const half_to_string = {
	Bozo.Half.LESS: "less",
	Bozo.Half.MORE: "more",
	Bozo.Half.DOUBLE: "double",
}

const half_to_shift = {
	Bozo.Half.LESS: -1,
	Bozo.Half.MORE: 1,
	Bozo.Half.DOUBLE: 2
}

const WORST_TRIBUTE_SHIFT = -1
const BEST_TRIBUTE_SHIFT = 1

const DRAIN_TICK = 0.1
const REPLETION_TICK = 0.25
#endregion

#region desire
#const PRIMARY_DESIRE_COUNT: int = 2
#const SECONDARY_DESIRE_COUNT: int = 1
const DESIRE_DISSOLVE_DURATION: float = 0.5#1.2
const SPASH_DURATION: float = 0.4#0.5
const DESIRE_PROGRESS_LIMIT: float = 1.6

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

const guild_level_to_index = {
	-3: [0, 1, 2],
	-2: [0, 2],
	-1: [0],
	0: [],
	1: [0],
	2: [0, 2],
	3: [0, 1, 2]
}
#endregion

#region shelter
const PRESSURE_OFFSET_L = 16

const modifiers = [
	Bozo.Modifier.MISS,
	Bozo.Modifier.CRIT,
	Bozo.Modifier.MEGACRIT,
	Bozo.Modifier.ULTRACRIT,
]

const modifier_to_string = {
	Bozo.Modifier.NONE: "none",
	Bozo.Modifier.MISS: "miss",
	Bozo.Modifier.CRIT: "crit",
	Bozo.Modifier.MEGACRIT: "megacrit",
	Bozo.Modifier.ULTRACRIT: "ultracrit",
}

const level_modifier_to_percent = {
	1: {
		Bozo.Modifier.MISS: 3,
		Bozo.Modifier.CRIT: 5,
		Bozo.Modifier.MEGACRIT: 1,
		Bozo.Modifier.ULTRACRIT: 0,
		Bozo.Modifier.NONE: 91,
	}
}

const modifier_to_factor = {
	Bozo.Modifier.MISS: 0,
	Bozo.Modifier.NONE: 1,
	Bozo.Modifier.CRIT: 2,
	Bozo.Modifier.MEGACRIT: 3,
	Bozo.Modifier.ULTRACRIT: 4,
	
}
#endregion

#region phase
const phases = [
	Bozo.Phase.ENDOWMENT,
	Bozo.Phase.REPLENISHMENT,
	Bozo.Phase.PAYMENT,
	Bozo.Phase.APPRAISEMENT,
	Bozo.Phase.DISBURSEMENT,
	Bozo.Phase.DEVELOPMENT,
	Bozo.Phase.INVESTMENT,
]

const phase_to_next = {
	Bozo.Phase.ENDOWMENT: Bozo.Phase.REPLENISHMENT,
	Bozo.Phase.REPLENISHMENT: Bozo.Phase.PAYMENT,
	Bozo.Phase.PAYMENT: Bozo.Phase.APPRAISEMENT,
	Bozo.Phase.APPRAISEMENT: Bozo.Phase.DISBURSEMENT,
	Bozo.Phase.DISBURSEMENT: Bozo.Phase.DEVELOPMENT,
	Bozo.Phase.DEVELOPMENT: Bozo.Phase.INVESTMENT,
	Bozo.Phase.INVESTMENT: Bozo.Phase.REPLENISHMENT
}

const phase_to_string = {
	Bozo.Phase.ENDOWMENT: "ENDOWMENT",
	Bozo.Phase.PAYMENT: "PAYMENT",
	Bozo.Phase.APPRAISEMENT: "APPRAISEMENT",
	Bozo.Phase.DISBURSEMENT: "DISBURSEMENT",
	Bozo.Phase.DEVELOPMENT: "DEVELOPMENT",
	Bozo.Phase.INVESTMENT: "INVESTMENT",
	Bozo.Phase.REPLENISHMENT: "REPLENISHMENT"
}
#endregion

#region tooltip
var type_to_tooltip = {
	Bozo.Sin.ANGER: Bozo.Tooltip.SIN,
	Bozo.Sin.ENVY: Bozo.Tooltip.SIN,
	Bozo.Sin.GREED: Bozo.Tooltip.SIN,
	Bozo.Sin.GLUTTONY: Bozo.Tooltip.SIN,
	Bozo.Sin.LUST: Bozo.Tooltip.SIN,
	Bozo.Sin.PRIDE: Bozo.Tooltip.SIN,
	Bozo.Posture.MADNESS: Bozo.Tooltip.MADNESS,
	Bozo.Posture.OBLIVION: Bozo.Tooltip.OBLIVION,
	Bozo.Half.LESS: Bozo.Tooltip.TRIBUTE,
	Bozo.Half.MORE: Bozo.Tooltip.TRIBUTE,
	Bozo.Half.DOUBLE: Bozo.Tooltip.TRIBUTE,
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
	Bozo.Fate.ADULTERER: Bozo.Tooltip.FATE,
	Bozo.Fate.ACTOR: Bozo.Tooltip.FATE,
	Bozo.Fate.BLACKSMITH: Bozo.Tooltip.FATE,
	Bozo.Fate.TAILOR: Bozo.Tooltip.FATE,
	Bozo.Fate.COOK: Bozo.Tooltip.FATE,
	Bozo.Fate.MONGER: Bozo.Tooltip.FATE,
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
	"sin": Bozo.Tooltip.SIN,
	"essense": Bozo.Tooltip.ESSENCE,
	"attitude": Bozo.Tooltip.ATTITUIDE,
	"overlord": Bozo.Tooltip.OVERLORD,
	"flame": Bozo.Tooltip.FLAME,
	"tribute": Bozo.Tooltip.TRIBUTE,
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
	Bozo.Tooltip.TRIBUTE: "Changes [ghost][meta attitude]Attitude[/meta][/ghost]",
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
	Bozo.Tooltip.TRIBUTE: "tribute",
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
#endregion

#region gate
const GATE_FATE_SIZE = 9
const GATE_FATE_MAX = 2
#endregion

#region market
const market_in_range = {
	1: [1, 1]#[8, 10]
}

const market_out_range = {
	1: [4, 6]
}
#endregion

#region token
var token_to_color = {
	Bozo.Token.PRIDE: Color.from_hsv(0.75, 0.9, 0.9),
	Bozo.Token.ENVY: Color.from_hsv(0.08, 0.9, 0.9),
	Bozo.Token.ANGER: Color.from_hsv(0.0, 0.9, 0.9),
	Bozo.Token.LUST: Color.from_hsv(0.6, 0.9, 0.9),
	Bozo.Token.GREED: Color.from_hsv(0.15, 0.9, 0.9),
	Bozo.Token.GLUTTONY: Color.from_hsv(0.4, 0.9, 0.9),
	Bozo.Token.OBLIVION: Color.SLATE_GRAY,
	Bozo.Token.MADNESS: Color.DEEP_PINK
}
#endregion

#region frame
const frame_to_string = {
	Bozo.Frame.TOOLTIP: "tooltip",
	Bozo.Frame.TRIAL: "trial",
	Bozo.Frame.CAGE: "cage",
	Bozo.Frame.HELL: "hell",
	Bozo.Frame.JAIL: "jail",
	Bozo.Frame.BANK: "bank",
	Bozo.Frame.SHELTER: "shelter",
	Bozo.Frame.TREASURY: "treasury",
	Bozo.Frame.MARKET: "market",
	Bozo.Frame.MODIFIER: "modifier",
	Bozo.Frame.CONTRIBUTION: "contribution",
	Bozo.Frame.DEAL: "deal",
}

const frame_to_region = {
	Bozo.Frame.TOOLTIP: 18,
	Bozo.Frame.TRIAL: 120,
	Bozo.Frame.CAGE: 84,
	Bozo.Frame.HELL: 200,
	#Bozo.Frame.JAIL: ,
	Bozo.Frame.BANK: 72,
	Bozo.Frame.SHELTER: 128,
	#Bozo.Frame.TREASURY: 240,
	Bozo.Frame.MARKET: 128,
	#Bozo.Frame.MODIFIER: ,
	Bozo.Frame.CONTRIBUTION: 36,
	Bozo.Frame.DEAL: 36,
}

const frame_to_patch = {
	Bozo.Frame.TOOLTIP: 6,
	Bozo.Frame.TRIAL: 40,
	Bozo.Frame.CAGE: 21,
	Bozo.Frame.HELL: 68,
	#Bozo.Frame.JAIL: ,
	Bozo.Frame.BANK: 34,#not 44,
	Bozo.Frame.SHELTER: 48,
	#Bozo.Frame.TREASURY: 78,
	Bozo.Frame.MARKET: 60,
	#Bozo.Frame.MODIFIER: ,
	Bozo.Frame.CONTRIBUTION: 12,
	Bozo.Frame.DEAL: 12,
}
#endregion

#region transition
const TRANSITION_DURATION: float = 0.1#1.5

const layer_to_string = {
	Bozo.Layer.HELL: "hell",
	Bozo.Layer.GATE: "gate",
	Bozo.Layer.SANCTUARY: "sanctuary"
}
#endregion

#region catena
const CATENA_DURATION_MIN: float = 0.4
const CATENA_DURATION_MAX: float = 0.8
const CATENA_Z_INDEX_DEFAULT: int = 1

var active_to_color = {
	true: Color.from_rgba8(0, 0, 0, 170),#230
	false: Color.from_rgba8(0, 0, 0, 135)
}
#endregion

#region plaza
const PLAZA_FATE_LIMIT: int = 2
const PLAZA_FACTION_LIMIT: int = 5
#endregion

#region omen
const omens = [
	Bozo.Omen.FAMILY,
	Bozo.Omen.DESTINY
]

const family_to_family = {
	Bozo.Family.MOTHER: Bozo.Family.PARENT,
	Bozo.Family.FATHER: Bozo.Family.PARENT,
	Bozo.Family.SON: Bozo.Family.CHILD,
	Bozo.Family.DAUGHTER: Bozo.Family.CHILD,
}

const faction_to_destiny = {
	Bozo.Faction.NOBILITY: {
		Bozo.Destiny.LAYMAN: 1,
		Bozo.Destiny.GENIUS: 1,
		Bozo.Destiny.LEADER: 2
	},
	Bozo.Faction.RIFFRAFF: {
		Bozo.Destiny.LAYMAN: 1,
		Bozo.Destiny.EXILE: 2,
		Bozo.Destiny.LEADER: 1
	},
	Bozo.Faction.ARTISAN: {
		Bozo.Destiny.LAYMAN: 1,
		Bozo.Destiny.EXILE: 1,
		Bozo.Destiny.GENIUS: 2,
	},
}

const fate_to_family = {
	Bozo.Fate.HEIR: {
		Bozo.Family.SON: 7,
		Bozo.Family.DAUGHTER: 3
	},
	Bozo.Fate.COLLECTOR: {
		Bozo.Family.MOTHER: 3,
		Bozo.Family.FATHER: 4,
		Bozo.Family.SON: 2,
		Bozo.Family.DAUGHTER: 1
	},
	Bozo.Fate.GOURMET: {
		Bozo.Family.FATHER: 3,
		Bozo.Family.DAUGHTER: 7
	},
	Bozo.Fate.DUELIST: {
		Bozo.Family.FATHER: 4,
		Bozo.Family.SON: 6,
	},
	Bozo.Fate.ADULTERER: {
		Bozo.Family.MOTHER: 1,
		Bozo.Family.FATHER: 2,
		Bozo.Family.SON: 4,
		Bozo.Family.DAUGHTER: 3
	},
	Bozo.Fate.ACTOR: {
		Bozo.Family.MOTHER: 4,
		Bozo.Family.FATHER: 3,
		Bozo.Family.SON: 1,
		Bozo.Family.DAUGHTER: 2
	},
	Bozo.Fate.BLACKSMITH: {
		Bozo.Family.FATHER: 5,
		Bozo.Family.SON: 5,
	},
	Bozo.Fate.TAILOR: {
		Bozo.Family.MOTHER: 5,
		Bozo.Family.DAUGHTER: 5
	},
	Bozo.Fate.COOK: {
		Bozo.Family.MOTHER: 7,
		Bozo.Family.DAUGHTER: 3
	},
	Bozo.Fate.MONGER: {
		Bozo.Family.MOTHER: 3,
		Bozo.Family.FATHER: 7,
	},
	Bozo.Fate.EXECUTIONER: {
		Bozo.Family.FATHER: 7,
		Bozo.Family.SON: 3
	},
	Bozo.Fate.THIEF: {
		Bozo.Family.MOTHER: 2,
		Bozo.Family.SON: 5,
		Bozo.Family.DAUGHTER: 3
	},
	Bozo.Fate.SHARPIE: {
		Bozo.Family.FATHER: 3,
		Bozo.Family.SON: 7,
	},
	Bozo.Fate.DRUNKARD: {
		Bozo.Family.MOTHER: 3,
		Bozo.Family.FATHER: 5,
		Bozo.Family.SON: 2,
	},
	Bozo.Fate.COURTESAN: {
		Bozo.Family.MOTHER: 6,
		Bozo.Family.FATHER: 0,
		Bozo.Family.SON: 0,
		Bozo.Family.DAUGHTER: 4
	},
}

const neighbour_to_destiny = {
	2: Bozo.Destiny.EXILE,
	3: Bozo.Destiny.LAYMAN,
	4: Bozo.Destiny.LEADER,
}

const destiny_to_neighbour = {
	Bozo.Destiny.EXILE: 2,
	Bozo.Destiny.LAYMAN: 3,
	Bozo.Destiny.LEADER: 4
	#Bozo.Destiny.LEADER: [
		#Vector2i(1, 1)
	#],
	#Bozo.Destiny.LAYMAN: [
		#Vector2i(1, 0),
		#Vector2i(0, 1),
		#Vector2i(-1, 0),
		#Vector2i(0, -1),
	#],
	#Bozo.Destiny.EXILE: [
		#Vector2i(0, 0),
		#Vector2i(0, 2),
		#Vector2i(2, 2),
		#Vector2i(2, 0),
	#],
}

const family_to_success = {
	Bozo.Family.PARENT: 2,
	Bozo.Family.CHILD: 1
}

const omen_to_string = {
	Bozo.Omen.FAMILY: "family",
	Bozo.Omen.DESTINY: "destiny",
}

const family_to_string = {
	Bozo.Family.PARENT: "parent",
	Bozo.Family.CHILD: "child",
	Bozo.Family.MOTHER: "mother",
	Bozo.Family.FATHER: "father",
	Bozo.Family.SON: "son",
	Bozo.Family.DAUGHTER: "daughter",
}

const destiny_to_string = {
	Bozo.Destiny.LEADER: "leader",
	Bozo.Destiny.GENIUS: "genius",
	Bozo.Destiny.LAYMAN: "layman",
	Bozo.Destiny.EXILE: "exile",
}

const omen_to_omen = {
	Bozo.Family.PARENT: [
		Bozo.Destiny.LAYMAN,
		Bozo.Destiny.EXILE
	],
	Bozo.Family.CHILD: [
		Bozo.Destiny.LEADER,
		Bozo.Destiny.GENIUS
	],
	Bozo.Destiny.LAYMAN: [
		Bozo.Family.PARENT,
		Bozo.Family.MOTHER,
		Bozo.Family.FATHER
	],
	Bozo.Destiny.GENIUS: [
		Bozo.Family.CHILD,
		Bozo.Family.SON,
		Bozo.Family.DAUGHTER
	],
	Bozo.Destiny.EXILE: [
		Bozo.Family.PARENT,
		Bozo.Family.MOTHER,
		Bozo.Family.FATHER
	],
	Bozo.Destiny.LEADER: [
		Bozo.Family.CHILD,
		Bozo.Family.SON,
		Bozo.Family.DAUGHTER
	],
}

const bool_to_status = {
	true: Bozo.Status.ON,
	false: Bozo.Status.OFF
}

const status_to_bool = {
	Bozo.Status.ON: true,
	Bozo.Status.OFF: false
}

const status_to_string = {
	Bozo.Status.ON: "on",
	Bozo.Status.OFF: "off"
}
#endregion
