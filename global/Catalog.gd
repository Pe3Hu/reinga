extends Node


#region cage
const JAIL_CAGE_SIZE = Vector2i(3, 3)
const CAGE_SPRITE_SIZE = Vector2(188, 212)
const SINNER_PANEL_SIZE = Vector2(172, 196)

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
	Bozo.Faction.NOBILITY: Color.DARK_SLATE_BLUE,
	Bozo.Faction.ARTISAN: Color.SADDLE_BROWN,
	Bozo.Faction.RIFFRAFF: Color.WEB_PURPLE,
}

#endregion

#region nightmare
const nightmare_to_color = {
	Bozo.Nightmare.THEATER: Color.MEDIUM_PURPLE,
	Bozo.Nightmare.BATTLE: Color.INDIAN_RED,
	Bozo.Nightmare.AUCTION: Color.KHAKI,
	Bozo.Nightmare.FEAST: Color.PALE_GREEN,
	Bozo.Nightmare.MASQUERADE: Color.SKY_BLUE,
}

const nightmare_to_sin = {
	Bozo.Nightmare.THEATER: {
		Bozo.Sin.PRIDE: 2,
		Bozo.Sin.ENVY: 2,
		Bozo.Sin.LUST: 2,
	},
	Bozo.Nightmare.BATTLE: {
		Bozo.Sin.PRIDE: 1,
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.ANGER: 3,
		Bozo.Sin.LUST: 1,
	},
	Bozo.Nightmare.AUCTION: {
		Bozo.Sin.PRIDE: 1,
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.GREED: 3,
		Bozo.Sin.GLUTTONY: 1,
	},
	Bozo.Nightmare.FEAST: {
		Bozo.Sin.PRIDE: 1,
		Bozo.Sin.ENVY: 1,
		Bozo.Sin.ANGER: 1,
		Bozo.Sin.GLUTTONY: 3,
	},
	Bozo.Nightmare.MASQUERADE: {
		Bozo.Sin.ANGER: 1,
		Bozo.Sin.LUST: 2,
		Bozo.Sin.GREED: 2,
		Bozo.Sin.GLUTTONY: 1,
	},
}

const fate_to_nightmare = {
	Bozo.Fate.HEIR: Bozo.Nightmare.THEATER,
	Bozo.Fate.COLLECTOR: Bozo.Nightmare.AUCTION,
	Bozo.Fate.GOURMET: Bozo.Nightmare.FEAST,
	Bozo.Fate.DUELIST: Bozo.Nightmare.BATTLE,
	Bozo.Fate.MASHER: Bozo.Nightmare.MASQUERADE,
	Bozo.Fate.ACTOR: Bozo.Nightmare.THEATER,
	Bozo.Fate.BLACKSMITH: Bozo.Nightmare.BATTLE,
	Bozo.Fate.TAILOR: Bozo.Nightmare.THEATER,
	Bozo.Fate.COOK: Bozo.Nightmare.FEAST,
	Bozo.Fate.HUCKSTER: Bozo.Nightmare.AUCTION,
	Bozo.Fate.EXECUTIONER: Bozo.Nightmare.BATTLE,
	Bozo.Fate.THIEF: Bozo.Nightmare.AUCTION,
	Bozo.Fate.SHARPIE: Bozo.Nightmare.MASQUERADE,
	Bozo.Fate.DRUNKARD: Bozo.Nightmare.FEAST,
	Bozo.Fate.COURTESAN: Bozo.Nightmare.MASQUERADE,
}

const faction_to_nightmare = {
	Bozo.Faction.NOBILITY: {
		Bozo.Nightmare.THEATER: 1,
		Bozo.Nightmare.FEAST: 1,
		Bozo.Nightmare.AUCTION: 3,
		Bozo.Nightmare.MASQUERADE: 2,
	},
	Bozo.Faction.ARTISAN: {
		Bozo.Nightmare.BATTLE: 3,
		Bozo.Nightmare.FEAST: 2,
		Bozo.Nightmare.MASQUERADE: 1,
	},
	Bozo.Faction.RIFFRAFF: {
		Bozo.Nightmare.THEATER: 3,
		Bozo.Nightmare.BATTLE: 1,
		Bozo.Nightmare.FEAST: 2,
		Bozo.Nightmare.AUCTION: 1,
		Bozo.Nightmare.MASQUERADE: 1,
	},
}
#endregion

#region rank
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


var tribute_windroses = [
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

var windrose_to_indexs = {
	Bozo.Windrose.NW: [0, 1, 2, 3, 6],
	Bozo.Windrose.N: [0, 1, 2, 4, 7],
	Bozo.Windrose.NE: [0, 1, 2, 5, 8],
	Bozo.Windrose.W: [0, 3, 4, 5, 6],
	Bozo.Windrose.ESWN: [1, 3, 4, 5, 7],
	Bozo.Windrose.E: [2, 3, 4, 5, 8],
	Bozo.Windrose.SW: [0, 3, 6, 6, 7, 8],
	Bozo.Windrose.S: [1, 4, 6, 7, 8],
	Bozo.Windrose.SE: [2, 5, 6, 7, 8],
}
