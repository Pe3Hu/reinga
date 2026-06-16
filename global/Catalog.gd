extends Node


#region cage
const JAIL_CAGE_GRID = Vector2i(3, 3)
const CAGE_SIZE = Vector2(206, 230)#Vector2(188, 212) (214, 238)
const CAGE_OFFSET = Vector2(16, 16)
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
	Bozo.Cage.CENTER: "bottom",
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

const trait_to_margin = {
	Bozo.Trait.FEAR: [1, 2, 0, 2],
	Bozo.Trait.HORROR: [2, 1, 2, 0],
	Bozo.Trait.GUILT: [0, 2, 1, 2],
	Bozo.Trait.REPOSE: [2, 0, 2, 1],
}

const TRAIT_MARGIN_OFFSET = -16
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

const sin_to_amber = {
	Bozo.Sin.ANGER: Bozo.Amber.ANGER,
	Bozo.Sin.ENVY: Bozo.Amber.ENVY,
	Bozo.Sin.GREED: Bozo.Amber.GREED,
	Bozo.Sin.GLUTTONY: Bozo.Amber.GLUTTONY,
	Bozo.Sin.LUST: Bozo.Amber.LUST,
	Bozo.Sin.PRIDE: Bozo.Amber.PRIDE,
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

const special_fates = [
	Bozo.Fate.FRIEND,
	Bozo.Fate.TRAITOR,
	Bozo.Fate.HERO,
	Bozo.Fate.VILLAIN,
]

const trust_fates = [
	Bozo.Fate.FRIEND,
	Bozo.Fate.TRAITOR,
]

const hope_fates = [
	Bozo.Fate.HERO,
	Bozo.Fate.VILLAIN,
]

const special_factions = [
	Bozo.Faction.TRUST,
	Bozo.Faction.HOPE
]

const enemy_fates = [
	Bozo.Fate.TRAITOR,
	Bozo.Fate.VILLAIN
]

const ally_fates = [
	Bozo.Fate.FRIEND,
	Bozo.Fate.HERO
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
	Bozo.Faction.HOPE: "hope",
	Bozo.Faction.TRUST: "trust",
	#Bozo.Faction.ALLY: "ally",
	#Bozo.Faction.ENEMY: "enemy",
}

const faction_to_direction = {
	Bozo.Faction.ARTISAN: 1,
	Bozo.Faction.NOBILITY: 2,
	Bozo.Faction.RIFFRAFF: 3,
	Bozo.Faction.TRUST: 0,
	Bozo.Faction.HOPE: 0,
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
	Bozo.Fate.FRIEND: Bozo.Faction.TRUST,
	Bozo.Fate.TRAITOR: Bozo.Faction.TRUST,
	Bozo.Fate.HERO: Bozo.Faction.HOPE,
	Bozo.Fate.VILLAIN: Bozo.Faction.HOPE,
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
	Bozo.Fate.FRIEND: "friend",
	Bozo.Fate.TRAITOR: "traitor",
	Bozo.Fate.HERO: "hero",
	Bozo.Fate.VILLAIN: "villain",
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
	Bozo.Fate.FRIEND: [
		Bozo.Sin.ANGER,
		Bozo.Sin.ENVY,
		Bozo.Sin.GREED,
		Bozo.Sin.GLUTTONY,
		Bozo.Sin.LUST,
		Bozo.Sin.PRIDE,
	],
	Bozo.Fate.TRAITOR: [
		Bozo.Sin.ANGER,
		Bozo.Sin.ENVY,
		Bozo.Sin.GREED,
		Bozo.Sin.GLUTTONY,
		Bozo.Sin.LUST,
		Bozo.Sin.PRIDE,
	],
	Bozo.Fate.HERO: [
		Bozo.Sin.ANGER,
		Bozo.Sin.ENVY,
		Bozo.Sin.GREED,
		Bozo.Sin.GLUTTONY,
		Bozo.Sin.LUST,
		Bozo.Sin.PRIDE,
	],
	Bozo.Fate.VILLAIN: [
		Bozo.Sin.ANGER,
		Bozo.Sin.ENVY,
		Bozo.Sin.GREED,
		Bozo.Sin.GLUTTONY,
		Bozo.Sin.LUST,
		Bozo.Sin.PRIDE,
	],
}

const faction_to_color = {
	Bozo.Faction.NOBILITY: Color.AQUA,
	Bozo.Faction.ARTISAN: Color.LIME,#Color.OLIVE,
	Bozo.Faction.RIFFRAFF: Color.CRIMSON,#Color.PURPLE,
	Bozo.Faction.TRUST: Color.GRAY,
	Bozo.Faction.HOPE: Color.GRAY,
}

const relationship_to_color = {
	Bozo.Relationship.ALLY: Color.GRAY,
	Bozo.Relationship.ENEMY: Color.BLACK
}

const relationship_to_sign = {
	Bozo.Relationship.ALLY: 1,
	Bozo.Relationship.ENEMY: -1
}

const fate_to_relationship = {
	Bozo.Fate.FRIEND: Bozo.Relationship.ALLY,
	Bozo.Fate.HERO: Bozo.Relationship.ALLY,
	Bozo.Fate.TRAITOR: Bozo.Relationship.ENEMY,
	Bozo.Fate.VILLAIN: Bozo.Relationship.ENEMY,
}

const faction_to_association = {
	Bozo.Faction.HOPE: Bozo.Association.BROTHERHOOD,
	Bozo.Faction.TRUST: Bozo.Association.GUILD
}

const association_to_string = {
	Bozo.Association.BROTHERHOOD: "brotherhood",
	Bozo.Association.GUILD: "guild",
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
	Bozo.Faction.TRUST: {
		Bozo.Trial.THEATER: 1,
		Bozo.Trial.BATTLE: 1,
		Bozo.Trial.FEAST: 1,
		Bozo.Trial.AUCTION: 1,
		Bozo.Trial.MASQUERADE: 1,
	},
	Bozo.Faction.HOPE: {
		Bozo.Trial.THEATER: 1,
		Bozo.Trial.BATTLE: 1,
		Bozo.Trial.FEAST: 1,
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

const flame_to_baggage = {
	1: 0,
	2: 15,
	3: 35,
	4: 60
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

const special_to_trait = {
	Bozo.Fate.FRIEND: [
		Bozo.Trait.FEAR,
		Bozo.Trait.HORROR
	],
	Bozo.Fate.TRAITOR: [
		Bozo.Trait.FEAR,
		Bozo.Trait.HORROR
	],
	Bozo.Fate.HERO: [
		Bozo.Trait.GUILT,
		Bozo.Trait.REPOSE
	],
	Bozo.Fate.VILLAIN: [
		Bozo.Trait.GUILT,
		Bozo.Trait.REPOSE
	],
}

const combination_to_weight = {
	0: 5,
	1: 3,
	2: 2,
}

const rank_combinations = [
	[0, 0, 0, 1],
	[-1, 0, 1, 1],
	[-1, 0, 0, 2]
]

const special_rank_combinations = [
	[2, 2, 2, 2],
	#[3, 3, 3, 3],
	#[4, 4, 4, 4],
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
	#Bozo.Destiny.LEADER: [Bozo.Windrose.NE],
	#Bozo.Destiny.GENIUS: [Bozo.Windrose.SW],
	#Bozo.Destiny.LAYMAN: [Bozo.Windrose.NW],
	#Bozo.Destiny.EXILE: [Bozo.Windrose.SE],
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

const attitude_to_baggage = {
	Bozo.Attitude.RAPTURE: 5,
	Bozo.Attitude.FAVOR: 2,
	Bozo.Attitude.INDIFFERENCE: 0,
	Bozo.Attitude.DISFAVOR: -2,
	Bozo.Attitude.SCORN: -5,
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

const blob_to_shift = {
	Bozo.Blob.PLUS: 1,
	Bozo.Blob.MINUS: -1,
}

const blob_to_header = {
	Bozo.Blob.MINUS: "Curse",
	Bozo.Blob.PLUS: "Bless",
}

const blob_to_flag = {
	Bozo.Blob.MINUS: false,
	Bozo.Blob.PLUS: true,
}

const blob_to_color = {
	Bozo.Blob.MINUS: Color.WHITE,
	Bozo.Blob.PLUS: Color.BLACK,
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
const SPECTACLE_AMBER_DURATION: float = 0.8#0.5

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
	Bozo.Desire.SWORD: 135.0,
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

#region gate
const GATE_FATE_SIZE = 9
const GATE_FATE_MAX = 2
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
	Bozo.Token.MADNESS: Color.DEEP_PINK,
	Bozo.Amber.PRIDE: Color.from_hsv(0.75, 0.9, 0.9),
	Bozo.Amber.ENVY: Color.from_hsv(0.08, 0.9, 0.9),
	Bozo.Amber.ANGER: Color.from_hsv(0.0, 0.9, 0.9),
	Bozo.Amber.LUST: Color.from_hsv(0.6, 0.9, 0.9),
	Bozo.Amber.GREED: Color.from_hsv(0.15, 0.9, 0.9),
	Bozo.Amber.GLUTTONY: Color.from_hsv(0.4, 0.9, 0.9),
	Bozo.Amber.INDOLENCE: Color.from_hsv(0.0, 0.0, 0.9),
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
	Bozo.Frame.PLATFORM: "platform",
	Bozo.Frame.SANCTUARY: "sanctuary",
	Bozo.Frame.TORTURE: "torture",
	Bozo.Frame.HERALD: "herald",
}

const frame_to_region = {
	Bozo.Frame.TOOLTIP: 18,
	Bozo.Frame.TRIAL: 120,
	Bozo.Frame.CAGE: 84,
	Bozo.Frame.HELL: 200,
	Bozo.Frame.BANK: 72,
	Bozo.Frame.SHELTER: 128,
	Bozo.Frame.MARKET: 128,
	Bozo.Frame.CONTRIBUTION: 36,
	Bozo.Frame.DEAL: 36,
	Bozo.Frame.PLATFORM: 136,
	Bozo.Frame.SANCTUARY: 124,
	Bozo.Frame.TORTURE: 84,
	Bozo.Frame.HERALD: 128,
}

const frame_to_patch = {
	Bozo.Frame.TOOLTIP: 6,
	Bozo.Frame.TRIAL: 40,
	Bozo.Frame.CAGE: 21,
	Bozo.Frame.HELL: 68,
	Bozo.Frame.BANK: 34,#not 44,
	Bozo.Frame.SHELTER: 48,
	Bozo.Frame.MARKET: 60,
	Bozo.Frame.CONTRIBUTION: 12,
	Bozo.Frame.DEAL: 12,
	Bozo.Frame.PLATFORM: 66,
	Bozo.Frame.SANCTUARY: 60,
	Bozo.Frame.TORTURE: 21,
	Bozo.Frame.HERALD: 62,
}
#endregion

#region transition
const TRANSITION_DURATION: float = 0.1#1.5

const layer_to_string = {
	Bozo.Layer.HELL: "hell",
	Bozo.Layer.GATE: "gate",
	Bozo.Layer.ABYSS: "abyss",
	Bozo.Layer.SANCTUARY: "sanctuary",
	Bozo.Layer.MUSEUM: "museum",
	Bozo.Layer.HERALD: "herald",
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

#region omen
const omens = [
	Bozo.Omen.FAMILY,
	Bozo.Omen.DESTINY
]

const subtype_to_omen = {
	Bozo.Destiny.GENIUS: Bozo.Omen.DESTINY,
	Bozo.Destiny.EXILE: Bozo.Omen.DESTINY,
	Bozo.Destiny.LAYMAN: Bozo.Omen.DESTINY,
	Bozo.Destiny.LEADER: Bozo.Omen.DESTINY,
	Bozo.Family.PARENT: Bozo.Omen.FAMILY,
	Bozo.Family.CHILD: Bozo.Omen.FAMILY,
}

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
	Bozo.Family.PARENT: "parent",
	Bozo.Family.CHILD: "child",
	Bozo.Family.MOTHER: "mother",
	Bozo.Family.FATHER: "father",
	Bozo.Family.SON: "son",
	Bozo.Family.DAUGHTER: "daughter",
	Bozo.Destiny.LEADER: "leader",
	Bozo.Destiny.GENIUS: "genius",
	Bozo.Destiny.LAYMAN: "layman",
	Bozo.Destiny.EXILE: "exile",
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

const status_to_sign = {
	Bozo.Status.ON: 1,
	Bozo.Status.OFF: -1,
}

const friend_to_sign = {
	Bozo.Status.ON: 1,
	Bozo.Status.OFF: -1,
}

const status_to_next = {
	Bozo.Status.ON: Bozo.Status.OFF,
	Bozo.Status.OFF: Bozo.Status.ON
}

#endregion

#region indexs
const indexs = [0, 1, 2, 3, 4, 5, 6, 7, 8]
const left_indexs = [0, 1, 3, 4, 6, 7]
const right_indexs = [1, 2, 4, 5, 7, 8]
#endregion

#region spectacle
const catena_to_spectacle = {
	Bozo.Catena.ROW: Bozo.Spectacle.PUPPETRY,
	Bozo.Catena.COL: Bozo.Spectacle.BALLET,
	Bozo.Catena.DIAGONAL: Bozo.Spectacle.OPERA,
}

const spectacles = [
	Bozo.Spectacle.BALLET,
	Bozo.Spectacle.PUPPETRY,
	Bozo.Spectacle.OPERA,
]

const spectacle_to_string = {
	Bozo.Spectacle.BALLET: "ballet",
	Bozo.Spectacle.PUPPETRY: "puppetry",
	Bozo.Spectacle.OPERA: "opera",
}

const spectacle_to_basic = {
	Bozo.Spectacle.BALLET: 5,
	Bozo.Spectacle.PUPPETRY: 1,
	Bozo.Spectacle.OPERA: 6,
}

const fruit_to_state = {
	Bozo.Fruit.ROTTEN: 0,
	Bozo.Fruit.RIPE: 1,
	Bozo.Fruit.FRESH: 2,
	Bozo.Fruit.IMMATURE: 3,
}
#endregion

#region overlord
const OVERLORD_MAX_RANK: int = 6
const OVERLORD_MIN_RANK: int = -6

const CALTHEX_LAW_COUNT: int = 2

const AMBER_SHIFT: int = 5
const ATTITUDE_SHIFT: int = 1
const FLAME_SHIFT: int = 6

const overlords = [
	Bozo.Overlord.CALTHEX,
	Bozo.Overlord.KHARZEN,
	Bozo.Overlord.VIRELLO,
	Bozo.Overlord.XALVORR,
	Bozo.Overlord.SIREXIL,
]

const overlord_to_trial = {
	Bozo.Overlord.CALTHEX: Bozo.Trial.THEATER,
	Bozo.Overlord.KHARZEN: Bozo.Trial.BATTLE,
	Bozo.Overlord.VIRELLO: Bozo.Trial.AUCTION,
	Bozo.Overlord.XALVORR: Bozo.Trial.FEAST,
	Bozo.Overlord.SIREXIL: Bozo.Trial.MASQUERADE,
}

const trial_to_overlord = {
	Bozo.Trial.THEATER: Bozo.Overlord.CALTHEX,
	Bozo.Trial.BATTLE: Bozo.Overlord.KHARZEN,
	Bozo.Trial.AUCTION: Bozo.Overlord.VIRELLO,
	Bozo.Trial.FEAST: Bozo.Overlord.XALVORR,
	Bozo.Trial.MASQUERADE: Bozo.Overlord.SIREXIL,
}

const overlord_to_string = {
	Bozo.Overlord.CALTHEX: "calthex",
	Bozo.Overlord.KHARZEN: "kharzen",
	Bozo.Overlord.VIRELLO: "virello",
	Bozo.Overlord.XALVORR: "xalvorr",
	Bozo.Overlord.SIREXIL: "sirexil",
	Bozo.Overlord.MARVONE: "marvone"
}

const overlord_to_modifier = {
	Bozo.Overlord.XALVORR: [
		Bozo.Modifier.MISS,
		Bozo.Modifier.CRIT,
		Bozo.Modifier.MEGACRIT,
		Bozo.Modifier.ULTRACRIT,
	],
	Bozo.Overlord.VIRELLO: [
		Bozo.Modifier.SIN,
		Bozo.Modifier.AMBER,
	],
	Bozo.Overlord.KHARZEN: [
		Bozo.Modifier.TRUST,
	],
	Bozo.Overlord.CALTHEX: [
		Bozo.Modifier.BALLET,
		Bozo.Modifier.PUPPETRY,
		Bozo.Modifier.OPERA,
	],
	Bozo.Overlord.SIREXIL: [
		Bozo.Modifier.HOPE,
	],
	Bozo.Overlord.MARVONE: [
		Bozo.Modifier.GENIUS,
		Bozo.Modifier.EXILE,
		Bozo.Modifier.LAYMAN,
		Bozo.Modifier.LEADER,
		Bozo.Modifier.PARENT,
		Bozo.Modifier.CHILD,
	]
}

const modifier_to_overlord = {
	Bozo.Modifier.MISS: Bozo.Overlord.XALVORR,
	Bozo.Modifier.CRIT: Bozo.Overlord.XALVORR,
	Bozo.Modifier.MEGACRIT: Bozo.Overlord.XALVORR,
	Bozo.Modifier.ULTRACRIT: Bozo.Overlord.XALVORR,
	Bozo.Modifier.SIN: Bozo.Overlord.VIRELLO,
	Bozo.Modifier.AMBER: Bozo.Overlord.VIRELLO,
	Bozo.Modifier.TRUST: Bozo.Overlord.KHARZEN,
	Bozo.Modifier.BALLET: Bozo.Overlord.CALTHEX,
	Bozo.Modifier.PUPPETRY: Bozo.Overlord.CALTHEX,
	Bozo.Modifier.OPERA: Bozo.Overlord.CALTHEX,
	Bozo.Modifier.HOPE: Bozo.Overlord.SIREXIL,
	Bozo.Modifier.GENIUS: Bozo.Overlord.MARVONE,
	Bozo.Modifier.EXILE: Bozo.Overlord.MARVONE,
	Bozo.Modifier.LAYMAN: Bozo.Overlord.MARVONE,
	Bozo.Modifier.LEADER: Bozo.Overlord.MARVONE,
	Bozo.Modifier.PARENT: Bozo.Overlord.MARVONE,
	Bozo.Modifier.CHILD: Bozo.Overlord.MARVONE,
}

const overlord_to_hue = {
	Bozo.Overlord.CALTHEX: 0.75,
	Bozo.Overlord.KHARZEN: 0.95,
	Bozo.Overlord.VIRELLO: 0.15,
	Bozo.Overlord.XALVORR: 0.35,
	Bozo.Overlord.SIREXIL: 0.55,
	Bozo.Overlord.MARVONE: 0.0,
}

var overlord_to_pallete = [
	Color.from_hsv(0.0, 1.0, 0.2),
	Color.from_hsv(0.0416, 0.6, 0.7),
	Color.from_hsv(0.0416, 0.8, 1.0),
]

const modifier_to_rank_to_value = {
	Bozo.Modifier.MISS: [56, 42, 28, 19, 10, 7, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0],
	Bozo.Modifier.CRIT: [1, 2, 3, 4, 5, 5, 6, 6, 9, 12, 15, 20, 25, 30, 25, 5],
	Bozo.Modifier.MEGACRIT: [0, 0, 0, 0, 0, 1, 1, 3, 6, 10, 15, 20, 26, 30, 25, 15],
	Bozo.Modifier.ULTRACRIT: [0, 0, 0, 0, 0, 0, 0, 2, 4, 7, 11, 16, 22, 31, 50, 80],
	Bozo.Modifier.AMBER: [2, 3, 3, 4, 4, 5, 5, 5, 6, 6, 7, 7, 8],
	Bozo.Modifier.SIN: [10, 10, 9, 9, 8, 8, 7, 6, 6, 5, 5, 4, 4],
	Bozo.Modifier.SPECTACLE: [-9, -7, -5, -3, -1, 1, 3, 5, 7, 9, 11, 13, 15],
	Bozo.Modifier.BALLET: [-25, -20, -15, -10, -5, 0, 5, 5, 10, 15, 20, 25, 30],
	Bozo.Modifier.PUPPETRY: [-5, -4, -3, -2, -1, 0, 1, 1, 2, 3, 4, 5, 6],
	Bozo.Modifier.OPERA: [-30, -24, -18, -12, -6, 0, 6, 6, 12, 18, 24, 30, 36],
}

var deal_scope: int = 1
#endregion

#region modifier
const PRESSURE_OFFSET_L = 16

const modifiers = [
	Bozo.Modifier.MISS,
	Bozo.Modifier.CRIT,
	Bozo.Modifier.MEGACRIT,
	Bozo.Modifier.ULTRACRIT,
	Bozo.Modifier.SIN,
	Bozo.Modifier.AMBER,
	Bozo.Modifier.GENIUS,
	Bozo.Modifier.EXILE,
	Bozo.Modifier.LAYMAN,
	Bozo.Modifier.LEADER,
	Bozo.Modifier.PARENT,
	Bozo.Modifier.CHILD,
	Bozo.Modifier.BALLET,
	Bozo.Modifier.PUPPETRY,
	Bozo.Modifier.OPERA,
	Bozo.Modifier.TRUST,
	Bozo.Modifier.HOPE,
]

const modifier_to_string = {
	Bozo.Modifier.NONE: "none",
	Bozo.Modifier.MISS: "miss",
	Bozo.Modifier.CRIT: "crit",
	Bozo.Modifier.MEGACRIT: "megacrit",
	Bozo.Modifier.ULTRACRIT: "ultracrit",
	Bozo.Modifier.SIN: "sin",
	Bozo.Modifier.AMBER: "amber",
	Bozo.Modifier.GENIUS: "genius",
	Bozo.Modifier.EXILE: "exile",
	Bozo.Modifier.LAYMAN: "layman",
	Bozo.Modifier.LEADER: "leader",
	Bozo.Modifier.PARENT: "parent",
	Bozo.Modifier.CHILD: "child",
	Bozo.Modifier.BALLET: "ballet",
	Bozo.Modifier.PUPPETRY: "puppetry",
	Bozo.Modifier.OPERA: "opera",
	Bozo.Modifier.TRUST: "trust",
	Bozo.Modifier.HOPE: "hope",
	#Bozo.Modifier.: "",
}

const TRUST_LIMIT: int = 2
const HOPE_LIMIT: int = 5


const omen_to_percent = {
	Bozo.Modifier.PARENT: 15,
	Bozo.Modifier.CHILD: 10,
	Bozo.Modifier.LEADER: 11,
	Bozo.Modifier.GENIUS: 11,
	Bozo.Modifier.LAYMAN: 44,
	Bozo.Modifier.EXILE: 44,
}

const modifier_to_factor = {
	Bozo.Modifier.MISS: 0,
	Bozo.Modifier.NONE: 1,
	Bozo.Modifier.CRIT: 2,
	Bozo.Modifier.MEGACRIT: 3,
	Bozo.Modifier.ULTRACRIT: 4,
}

const modifier_to_tooltip = {
	Bozo.Modifier.MISS: Bozo.Tooltip.MOD_MISS,
	Bozo.Modifier.CRIT: Bozo.Tooltip.MOD_CRIT,
	Bozo.Modifier.MEGACRIT: Bozo.Tooltip.MOD_MEGACRIT,
	Bozo.Modifier.ULTRACRIT: Bozo.Tooltip.MOD_ULTRACRIT,
	Bozo.Modifier.SIN: Bozo.Tooltip.MOD_SIN,
	Bozo.Modifier.AMBER: Bozo.Tooltip.MOD_AMBER,
	Bozo.Modifier.GENIUS: Bozo.Tooltip.MOD_GENIUS,
	Bozo.Modifier.EXILE: Bozo.Tooltip.MOD_EXILE,
	Bozo.Modifier.LAYMAN: Bozo.Tooltip.MOD_LAYMAN,
	Bozo.Modifier.LEADER: Bozo.Tooltip.MOD_LEADER,
	Bozo.Modifier.PARENT: Bozo.Tooltip.MOD_PARENT,
	Bozo.Modifier.CHILD: Bozo.Tooltip.MOD_CHILD,
	Bozo.Modifier.BALLET: Bozo.Tooltip.MOD_BALLET,
	Bozo.Modifier.PUPPETRY: Bozo.Tooltip.MOD_PUPPETRY,
	Bozo.Modifier.OPERA: Bozo.Tooltip.MOD_OPERA,
	Bozo.Modifier.TRUST: Bozo.Tooltip.MOD_TRUST,
	Bozo.Modifier.HOPE: Bozo.Tooltip.MOD_HOPE,
}

const spectacle_to_modifier = {
	Bozo.Spectacle.BALLET: Bozo.Modifier.BALLET,
	Bozo.Spectacle.PUPPETRY: Bozo.Modifier.PUPPETRY,
	Bozo.Spectacle.OPERA: Bozo.Modifier.OPERA,
}
#endregion

#region tooltip
const TOOLTIP_DURATION: float = 10.0

const string_to_tooltip = {
	"sin": Bozo.Tooltip.SIN,
	"amber": Bozo.Tooltip.AMBER,
	"essence": Bozo.Tooltip.ESSENCE,
	"attitude": Bozo.Tooltip.ATTITUIDE,
	"overlord": Bozo.Tooltip.OVERLORD,
	"flame": Bozo.Tooltip.FLAME,
	"tribute": Bozo.Tooltip.TRIBUTE,
	"claim": Bozo.Tooltip.CLAIM,
	"desire": Bozo.Tooltip.DESIRE,
	"faction": Bozo.Tooltip.FACTION,
	"soul": Bozo.Tooltip.SOUL,
	"fate": Bozo.Tooltip.FATE,
	"cage": Bozo.Tooltip.CAGE,
	"treasury": Bozo.Tooltip.BANK,
	"market": Bozo.Tooltip.MARKET,
	"contribution": Bozo.Tooltip.CONTRIBUTION,
	"scene": Bozo.Tooltip.PLATFORM,
	"spectacle": Bozo.Tooltip.SPECTACLE,
	"omen": Bozo.Tooltip.OMEN,
	"sinner": Bozo.Tooltip.SINNER,
	"cloak": Bozo.Tooltip.CLOAK,
	"madness": Bozo.Tooltip.MADNESS,
	"oblivion": Bozo.Tooltip.OBLIVION,
	"deal": Bozo.Tooltip.DEAL,
	"layman": Bozo.Tooltip.LAYMAN,
	"genius": Bozo.Tooltip.GENIUS,
	"leader": Bozo.Tooltip.LEADER,
	"exile": Bozo.Tooltip.EXILE,
	"child": Bozo.Tooltip.CHILD,
	"parent": Bozo.Tooltip.PARENT,
	"neighbor": Bozo.Tooltip.NEIGHBOR,
	"ballet": Bozo.Tooltip.BALLET,
	"puppetry": Bozo.Tooltip.PUPPETRY,
	"opera": Bozo.Tooltip.OPERA,
	"trait": Bozo.Tooltip.TRAIT,
	"fear": Bozo.Tooltip.FEAR,
	"repose": Bozo.Tooltip.REPOSE,
	"horror": Bozo.Tooltip.HORROR,
	"guilt": Bozo.Tooltip.GUILT,
	"catena": Bozo.Tooltip.CATENA,
	"chain": Bozo.Tooltip.CATENA,
	"torture": Bozo.Tooltip.TORTURE,
	"permanent": Bozo.Tooltip.PERMANENT,
	"transient": Bozo.Tooltip.TRANSIENT,
	"eclipse": Bozo.Tooltip.ECLIPSE,
	"guild": Bozo.Tooltip.GUILD,
	"brotherhood": Bozo.Tooltip.BROTHERHOOD,
	"family": Bozo.Tooltip.FAMILY,
	"destiny": Bozo.Tooltip.DESTINY,
	"judgment": Bozo.Tooltip.JUDGMENT,
	"useful": Bozo.Tooltip.USEFUL,
	"tax": Bozo.Tooltip.TAX,
	
	"miss (mod)": Bozo.Tooltip.MOD_MISS,
	"crit (mod)": Bozo.Tooltip.MOD_CRIT,
	"megacrit (mod)": Bozo.Tooltip.MOD_MEGACRIT,
	"ultracrit (mod)": Bozo.Tooltip.MOD_ULTRACRIT,
	"sin (mod)": Bozo.Tooltip.MOD_SIN,
	"amber (mod)": Bozo.Tooltip.MOD_AMBER,
	"genius (mod)": Bozo.Tooltip.MOD_GENIUS,
	"exile (mod)": Bozo.Tooltip.MOD_EXILE,
	"layman (mod)": Bozo.Tooltip.MOD_LAYMAN,
	"leader (mod)": Bozo.Tooltip.MOD_LEADER,
	"parent (mod)": Bozo.Tooltip.MOD_PARENT,
	"child (mod)": Bozo.Tooltip.MOD_CHILD,
	"ballet (mod)": Bozo.Tooltip.MOD_BALLET,
	"puppetry (mod)": Bozo.Tooltip.MOD_PUPPETRY,
	"opera (mod)": Bozo.Tooltip.MOD_OPERA,
	"trust (mod)": Bozo.Tooltip.MOD_TRUST,
	"hope (mod)": Bozo.Tooltip.MOD_HOPE,


	#"": Bozo.Tooltip.,
}

var tooltip_to_template = {
	Bozo.Tooltip.SIN: "[ghost][meta transient]Transient[/meta][/ghost] [meta essence]%s[/meta]",
	Bozo.Tooltip.AMBER: "[ghost][meta permanent]Permanent[/meta][/ghost] [meta essence]%s[/meta], can complement [ghost][meta contribution]Contribution[/meta][/ghost]",
	Bozo.Tooltip.ESSENCE: "Primal hell currency",
	Bozo.Tooltip.MADNESS: "Makes the game more difficult",
	Bozo.Tooltip.OBLIVION: "Sacrifices [ghost][meta sinner]Sinner[/meta][/ghost] to obtain [ghost][meta amber]Amber[/meta][/ghost]",
	Bozo.Tooltip.TRIBUTE: "Changes [ghost][meta attitude]Attitude[/meta][/ghost]",
	Bozo.Tooltip.ATTITUIDE: "Shows relationship with [ghost][meta overlord]Overlord[/meta][/ghost]",
	Bozo.Tooltip.OVERLORD: "Uses [ghost][meta trial]Trial[/meta][/ghost] to collect [ghost][meta essence]Essence[/meta][/ghost]",
	Bozo.Tooltip.TRIAL: "[ghost][meta overlord]Overlord[/meta][/ghost] domain is formed from [ghost][meta claim]Claim[/meta][/ghost], [ghost][meta flame]Flame[/meta][/ghost] and [ghost][meta attitude]Attitude[/meta][/ghost]",
	Bozo.Tooltip.FLAME: "Raises [ghost][meta claim]Claim[/meta][/ghost] size, grows from [ghost][meta desire]Desire[/meta][/ghost]",
	Bozo.Tooltip.CLAIM: "[ghost][meta overlord]Overlord's[/melayer_to_stringta][/ghost] requirements, for now",
	Bozo.Tooltip.DESIRE: "Raises [ghost][meta flame]Flame[/meta][/ghost] when occupying [ghost][meta cage]Cage[/meta][/ghost], depends on [ghost][meta faction]Faction[/meta][/ghost]",
	Bozo.Tooltip.FATE: "Forms [ghost][meta guild]Guild[/meta][/ghost], defines [ghost][meta faction]Faction[/meta][/ghost] and [ghost][meta soul]Soul[/meta][/ghost]",
	Bozo.Tooltip.SOUL: "Set of [ghost][meta sin]Sin[/meta][/ghost], [ghost][meta madness]Madness[/meta][/ghost], [ghost][meta oblivion]Oblivion[/meta][/ghost]",
	Bozo.Tooltip.FACTION: "Forms [ghost][meta brotherhood]Brotherhood[/meta][/ghost], defines [ghost][meta desire]Desire[/meta][/ghost]",
	Bozo.Tooltip.CAGE: "Contains [ghost][meta sinner]Sinner[/meta][/ghost] and [ghost][meta cloak]Cloak[/meta][/ghost]",
	Bozo.Tooltip.SINNER: "Shows [ghost][meta fate]Fate[/meta][/ghost], [ghost][meta faction]Faction[/meta][/ghost] and [ghost][meta soul]Soul[/meta][/ghost] as frontside",
	Bozo.Tooltip.CLOAK: "Shows [ghost][meta desire]Desires[/meta][/ghost] as backside",
	Bozo.Tooltip.BANK: "Stores [ghost][meta amber]Amber[/meta][/ghost], [ghost][meta madness]Madness[/meta][/ghost] and [ghost][meta oblivion]Oblivion[/meta][/ghost]",
	Bozo.Tooltip.MARKET: "List of [ghost][meta deal]Deals[/meta][/ghost], wrapped at [ghost][meta eclipse]Eclipse[/meta][/ghost]",
	Bozo.Tooltip.CONTRIBUTION: "Produces [ghost][meta amber]Amber[/meta][/ghost], [ghost][meta madness]Madness[/meta][/ghost] and [ghost][meta oblivion]Oblivion[/meta][/ghost], depends on [ghost][meta torture]Torture[/meta][/ghost]",
	Bozo.Tooltip.PLATFORM: "Chronicle of previous [ghost][meta torture]Tortures[/meta][/ghost], organizes [ghost][meta spectacle]Spectacles[/meta][/ghost]",
	Bozo.Tooltip.SPECTACLE: "[ghost][meta trigger]Triggers[/meta][/ghost], if [ghost][meta catena]Chain[/meta][/ghost] is finished",
	Bozo.Tooltip.OMEN: "%s, produces [ghost][meta sin]Sin[/meta][/ghost] when [ghost][meta trigger]Triggered[/meta][/ghost]",
	Bozo.Tooltip.DEAL: "[ghost][meta transient]Transient[/meta][/ghost] proposal to process [ghost][meta sin]Sin[/meta][/ghost] into [ghost][meta amber]Amber[/meta][/ghost]",
	Bozo.Tooltip.LAYMAN: "[ghost][meta cage]Cage[/meta][/ghost] surrounded by exactly 3 [ghost][meta neighbor]Neighbors[/meta][/ghost]",
	Bozo.Tooltip.GENIUS: "[ghost][meta cage]Cage[/meta][/ghost] was [ghost][meta torture]Torture[/meta][/ghost] before [ghost][meta eclipse]Eclipse[/meta][/ghost]",
	Bozo.Tooltip.LEADER: "[ghost][meta cage]Cage[/meta][/ghost] surrounded by exactly 4 [ghost][meta neighbor]Neighbors[/meta][/ghost]",
	Bozo.Tooltip.EXILE: "[ghost][meta cage]Cage[/meta][/ghost] surrounded by exactly 2 [ghost][meta neighbor]Neighbors[/meta][/ghost]",
	Bozo.Tooltip.CHILD: "There are at least 1 [ghost][meta neighbor]Neighbor[/meta][/ghost] with same [ghost][meta fate]Fate[/meta][/ghost]",
	Bozo.Tooltip.PARENT: "There are at least 2 [ghost][meta neighbor]Neighbors[/meta][/ghost] with same [ghost][meta faction]Faction[/meta][ghost]",
	Bozo.Tooltip.NEIGHBOR: "Orthogonally linked [ghost][meta cage]Cage[/meta][/ghost]",
	Bozo.Tooltip.BALLET: "Produces [meta amber][color=white]Indolence[/color][/meta]",
	Bozo.Tooltip.PUPPETRY: "Improves better [ghost][meta attitude]Attitude[/meta][/ghost]",
	Bozo.Tooltip.OPERA: "Extinguishes hottest [ghost][meta flame]Flame[/meta][/ghost]",
	Bozo.Tooltip.TRAIT: "%s part of [ghost][meta soul]Soul[/meta][/ghost], that will be [ghost][meta trigger]Triggered[/meta][/ghost] by [ghost][meta torture]Torture[/meta][/ghost]",
	Bozo.Tooltip.FEAR: "[ghost][meta cage]Cage[/meta][/ghost] is on [ghost][meta catena]Col[/meta][/ghost] and [ghost][meta catena]Row[/meta][/ghost]",#"Specializes in medium volume [ghost][meta sin]Sin[/meta][/ghost]",
	Bozo.Tooltip.REPOSE: "[ghost][meta cage]Cage[/meta][/ghost] is on left of [ghost][meta catena]Col[/meta][/ghost]",#"Specializes in [ghost][meta oblivion]Oblivion[/meta][/ghost]",
	Bozo.Tooltip.HORROR: "[ghost][meta cage]Cage[/meta][/ghost] is on right of [ghost][meta catena]Col[/meta][/ghost]",#"Specializes in big volume [ghost][meta sin]Sin[/meta][/ghost] and [ghost][meta madness]Madness[/meta][/ghost]",
	Bozo.Tooltip.GUILT: "[ghost][meta cage]Cage[/meta][/ghost] is at intersection of [ghost][meta catena]Col[/meta][/ghost] and [ghost][meta catena]Row[/meta][/ghost]",#"Specializes in small volume [ghost][meta sin]Sin[/meta][/ghost]",
	Bozo.Tooltip.CATENA: "Set of 3 [ghost][meta cage]Cage[/meta][/ghost]",
	Bozo.Tooltip.TORTURE: "Intersection of [ghost][meta catena]Col[/meta][/ghost] and [ghost][meta catena]Row[/meta][/ghost]",
	Bozo.Tooltip.PERMANENT: "Will remain after [ghost][meta eclipse]Eclipse[/meta][/ghost]",
	Bozo.Tooltip.TRANSIENT: "Will disappear at [ghost][meta eclipse]Eclipse[/meta][/ghost]",
	Bozo.Tooltip.ECLIPSE: "The end of the turn",
	Bozo.Tooltip.GUILD: "Coalition of [ghost][meta sinner]Sinner[/meta][/ghost] based on [ghost][meta fate]Fate[/meta][/ghost]",
	Bozo.Tooltip.BROTHERHOOD: "Coalition of [ghost][meta sinner]Sinner[/meta][/ghost] based on [ghost][meta faction]Faction[/meta][ghost]",
	Bozo.Tooltip.FAMILY: "NE: [ghost][meta parent]Parent[/meta][/ghost]\nSE: [ghost][meta child]Child[/meta][/ghost]\nSW: [ghost][meta parent]Parent[/meta][/ghost]\nNW: [ghost][meta child]Child[/meta][/ghost]",
	Bozo.Tooltip.DESTINY: "NE: [ghost][meta layman]Layman[/meta][/ghost]\nSE: [ghost][meta genius]Genius[/meta][/ghost]\nSW: [ghost][meta exile]Exile[/meta][/ghost]\nNW: [ghost][meta leader]Leader[/meta][/ghost]",
	Bozo.Tooltip.JUDGMENT: "Amount of [ghost][meta useful]Useful[/meta][/ghost] [ghost][meta sin]Sin[/meta][/ghost] released upon [ghost][meta torture]Torture[/meta][/ghost]",
	Bozo.Tooltip.USEFUL: "Can be used for [ghost][meta tribute]Tribute[/meta][/ghost] or [ghost][meta deal]Deals[/meta][/ghost]",
	Bozo.Tooltip.TAX: "Amount of [ghost][meta sin]Sins[/meta][/ghost] that will be added to [ghost][meta claim]Claim[/meta][/ghost] after [ghost][meta eclipse]Eclipse[/meta][/ghost], determined by [ghost][meta flame]Flame[/meta][/ghost]",
	
	Bozo.Tooltip.MOD_MISS: "Chance to get 0 [ghost][meta essence]Essence[/meta][/ghost] when [ghost][meta torture]Tortured[/meta][/ghost]",
	Bozo.Tooltip.MOD_CRIT: "Chance to get x2 [ghost][meta essence]Essence[/meta][/ghost] when [ghost][meta torture]Tortured[/meta][/ghost]",
	Bozo.Tooltip.MOD_MEGACRIT: "Chance to get x3 [ghost][meta essence]Essence[/meta][/ghost] when [ghost][meta torture]Tortured[/meta][/ghost]",
	Bozo.Tooltip.MOD_ULTRACRIT: "Chance to get x4 [ghost][meta essence]Essence[/meta][/ghost] when [ghost][meta torture]Tortured[/meta][/ghost]",
	Bozo.Tooltip.MOD_LAYMAN: "Chance to occupy [ghost][meta cage]Cage[/meta][/ghost] surrounded by 3 [ghost][meta neighbor]Neighbors[/meta][/ghost]",
	Bozo.Tooltip.MOD_GENIUS: "Chance to occupy [ghost][meta cage]Cage[/meta][/ghost] that was [ghost][meta torture]Torture[/meta][/ghost] before [ghost][meta eclipse]Eclipse[/meta][/ghost]",
	Bozo.Tooltip.MOD_LEADER: "Chance to occupy [ghost][meta cage]Cage[/meta][/ghost] surrounded by 4 [ghost][meta neighbor]Neighbors[/meta][/ghost]",
	Bozo.Tooltip.MOD_EXILE: "Chance to occupy [ghost][meta cage]Cage[/meta][/ghost] surrounded by 2 [ghost][meta neighbor]Neighbors[/meta][/ghost]",
	Bozo.Tooltip.MOD_CHILD: "Chance to have 1 [ghost][meta neighbor]Neighbor[/meta][/ghost] with same [ghost][meta fate]Fate[/meta][/ghost]",
	Bozo.Tooltip.MOD_PARENT: "Chance to have 2 [ghost][meta neighbor]Neighbors[/meta][/ghost] with same [ghost][meta faction]Faction[/meta][/ghost]",
	Bozo.Tooltip.MOD_HOPE: "Amount of same [ghost][meta faction]Factions[/meta][/ghost] required to form [ghost][meta brotherhood]Brotherhood[/meta][/ghost]",
	Bozo.Tooltip.MOD_TRUST: "Amount of same [ghost][meta fate]Fates[/meta][/ghost] required to form [ghost][meta guild]Guild[/meta][/ghost]",
	Bozo.Tooltip.MOD_SIN: "Min and max amount of [ghost][meta sin]Sin[/meta][/ghost] required to conclude [ghost][meta deal]Deal[/meta][/ghost]",
	Bozo.Tooltip.MOD_AMBER: "Min and max amount of [ghost][meta amber]Amber[/meta][/ghost] received upon conclusion of [ghost][meta deal]Deal[/meta][/ghost]",
	Bozo.Tooltip.MOD_BALLET: "Amount of [ghost][meta amber]Indolence[/meta][/ghost] produces when [ghost][meta ballet]Ballet[/meta][/ghost] is finished",
	Bozo.Tooltip.MOD_PUPPETRY: "Amount of change of mind for better [ghost][meta attitude]Attitude[/meta][/ghost] when [ghost][meta puppetry]Puppetry[/meta][/ghost] is finished",
	Bozo.Tooltip.MOD_OPERA: "Amount of heat extinguished from hottest [ghost][meta flame]Flame[/meta][/ghost] when [ghost][meta opera]Opera[/meta][/ghost] is finished",
}

var tooltip_to_string = {
	Bozo.Tooltip.OVERLORD: "overlord",
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
	Bozo.Tooltip.AMBER: "amber",
	Bozo.Tooltip.BANK: "treasury",
	Bozo.Tooltip.MARKET: "market",
	Bozo.Tooltip.CONTRIBUTION: "contribution",
	Bozo.Tooltip.PLATFORM: "scene",
	Bozo.Tooltip.SPECTACLE: "spectacle",
	Bozo.Tooltip.OMEN: "omen",
	Bozo.Tooltip.DEAL: "deal",
	Bozo.Tooltip.LAYMAN: "layman",
	Bozo.Tooltip.GENIUS: "genius",
	Bozo.Tooltip.LEADER: "leader",
	Bozo.Tooltip.EXILE: "exile",
	Bozo.Tooltip.CHILD: "child",
	Bozo.Tooltip.PARENT: "parent",
	Bozo.Tooltip.NEIGHBOR: "neighbor",
	Bozo.Tooltip.BALLET: "ballet",
	Bozo.Tooltip.PUPPETRY: "puppetry",
	Bozo.Tooltip.OPERA: "opera",
	Bozo.Tooltip.TRAIT: "trait",
	Bozo.Tooltip.FEAR: "fear",
	Bozo.Tooltip.REPOSE: "repose",
	Bozo.Tooltip.HORROR: "horror",
	Bozo.Tooltip.GUILT: "guilt",
	Bozo.Tooltip.CATENA: "chain",
	Bozo.Tooltip.TORTURE: "torture",
	Bozo.Tooltip.PERMANENT: "permanent",
	Bozo.Tooltip.TRANSIENT: "transient",
	Bozo.Tooltip.ECLIPSE: "eclipse",
	Bozo.Tooltip.GUILD: "guild",
	Bozo.Tooltip.BROTHERHOOD: "brotherhood",
	Bozo.Tooltip.FAMILY: "family",
	Bozo.Tooltip.DESTINY: "destiny",
	Bozo.Tooltip.JUDGMENT: "judgment",
	Bozo.Tooltip.USEFUL: "useful",
	Bozo.Tooltip.TAX: "tax",
	
	Bozo.Tooltip.MOD_MISS: "miss (mod)",
	Bozo.Tooltip.MOD_CRIT: "crit (mod)",
	Bozo.Tooltip.MOD_MEGACRIT: "megacrit (mod)",
	Bozo.Tooltip.MOD_ULTRACRIT: "ultracrit (mod)",
	Bozo.Tooltip.MOD_SIN: "sin (mod)",
	Bozo.Tooltip.MOD_AMBER: "amber (mod)",
	Bozo.Tooltip.MOD_GENIUS: "genius (mod)",
	Bozo.Tooltip.MOD_EXILE: "exile (mod)",
	Bozo.Tooltip.MOD_LAYMAN: "layman (mod)",
	Bozo.Tooltip.MOD_LEADER: "leader (mod)",
	Bozo.Tooltip.MOD_PARENT: "parent (mod)",
	Bozo.Tooltip.MOD_CHILD: "child (mod)",
	Bozo.Tooltip.MOD_BALLET: "ballet (mod)",
	Bozo.Tooltip.MOD_PUPPETRY: "puppetry (mod)",
	Bozo.Tooltip.MOD_OPERA: "opera (mod)",
	Bozo.Tooltip.MOD_TRUST: "trust (mod)",
	Bozo.Tooltip.MOD_HOPE: "hope (mod)",
}

const tooltip_to_suffix = {
	Bozo.Tooltip.MOD_MISS: ", percent",
	Bozo.Tooltip.MOD_CRIT: ", percent",
	Bozo.Tooltip.MOD_MEGACRIT: ", percent",
	Bozo.Tooltip.MOD_ULTRACRIT: ", percent",
	Bozo.Tooltip.MOD_LAYMAN: ", percent",
	Bozo.Tooltip.MOD_GENIUS: ", percent",
	Bozo.Tooltip.MOD_LEADER: ", percent",
	Bozo.Tooltip.MOD_EXILE: ", percent",
	Bozo.Tooltip.MOD_CHILD: ", percent",
	Bozo.Tooltip.MOD_PARENT: ", percent",
	Bozo.Tooltip.MOD_HOPE: ", limit",
	Bozo.Tooltip.MOD_TRUST: ", limit",
	Bozo.Tooltip.MOD_SIN: ", scope",
	Bozo.Tooltip.MOD_AMBER: ", scope",
	Bozo.Tooltip.MOD_BALLET: ", shift",
	Bozo.Tooltip.MOD_PUPPETRY: ", shift",
	Bozo.Tooltip.MOD_OPERA: ", shift"
}
#endregion

#region weather
const weather_to_next = {
	Bozo.Weather.SUN: Bozo.Weather.MOON,
	Bozo.Weather.MOON: Bozo.Weather.SUN,
}
#endregion

#region sacrifice
const SACRIFICE_AMBER_COUNT: int = 2
const SACRIFICE_AMBER_DURATION: float = 1.0 
#endregion

#region museum
const MUSEUM_CAGE_COUNT: int = 3

const exhibit_windroses = [
	Bozo.Windrose.N,
	Bozo.Windrose.S
]

const museum_omens = [
	Bozo.Destiny.GENIUS,
	Bozo.Destiny.EXILE,
	Bozo.Destiny.LAYMAN,
	Bozo.Destiny.LEADER,
	Bozo.Family.PARENT,
	Bozo.Family.CHILD
]
#endregion
