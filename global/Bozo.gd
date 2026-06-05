extends Node


enum Sin {
	NONE = 0,
	ANGER = 1,
	ENVY = 2,
	GREED = 3, 
	GLUTTONY = 4,
	LUST = 5,
	PRIDE = 6,
}

enum Token {
	NONE = 0,
	ANGER = 1,
	ENVY = 2,
	GREED = 3, 
	GLUTTONY = 4,
	LUST = 5,
	PRIDE = 6,
	OBLIVION = 7,
	MADNESS = 8
}

enum Amber {
	NONE = 0,
	ANGER = 1,
	ENVY = 2,
	GREED = 3, 
	GLUTTONY = 4,
	LUST = 5,
	PRIDE = 6,
	INDOLENCE = -7,
}


enum Posture {
	NONE = 0,
	OBLIVION = 7,
	MADNESS = 8
}

enum Trial {
	NONE = 0,
	BATTLE = 9,
	AUCTION = 10,
	FEAST = 11,
	MASQUERADE = 12, 
	THEATER = 13,
}

enum Faction {
	NONE = 0,
	NOBILITY = 14,
	ARTISAN = 15,
	RIFFRAFF = 16,
}

enum Gyre {
	NONE = 0,
	HEREAFTER = 17,
	BYGONE = 18,
	ACTUAL = 19
}

enum Trait {
	NONE = 0,
	FEAR = 20,
	HORROR = 21,
	GUILT = 22,
	REPOSE = 23
}

enum Fate {
	NONE = 0,
	HEIR = 30,
	EXECUTIONER = 31,
	ACTOR = 32,
	COLLECTOR = 33,
	GOURMET = 34,
	BLACKSMITH= 35,
	TAILOR = 36,
	THIEF = 37,
	COOK = 38,
	DUELIST = 39,
	SHARPIE = 40,
	DRUNKARD = 41,
	COURTESAN = 42,
	ADULTERER = 43,
	HUCKSTER = 44,
}

enum Cage {
	NONE = 0,
	MIDDLE = 51,
	CENTER = 52,
	LEFT = 53,
	RIGHT = 54,
}

enum Catena {
	NONE = 0,
	ROW = 55,
	COL = 56,
	DIAGONAL = 57
}

enum Half {
	NONE = 0,
	LESS = 58,
	MORE = 59,
	DOUBLE = 60
}

enum Judgment {
	NONE = 0,
	RANK = 61,
	TRIBUTE = 62
}

enum Windrose {
	NONE = 0,
	E = 80, 
	SE = 81, 
	S = 82, 
	SW = 83, 
	W = 84, 
	NW = 85, 
	N = 86, 
	NE = 87, 
	ESWN = 88,
}

enum Blob {
	NONE = 0,
	PLUS = 90,
	MINUS = 91
}

enum Side {
	NONE = 0,
	LEFT = 92,
	RIGHT = 93
}

enum Attitude {
	NONE = 0,
	RAPTURE = 94,
	FAVOR = 95,
	INDIFFERENCE = 96,
	DISFAVOR = 97,
	SCORN = 98,
}

enum Desire {
	NONE = 0,
	SWORD = 100,
	COIN = 101,
	WINE = 102,
	MASK = 103,
	SCROLL = 104
}

enum Progression {
	NONE = 0,
	TRIBUTE = 105,
	FLAME = 106
}

enum Association {
	NONE = 0,
	BROTHERHOOD = 110,
	GUILD = 111,
}

enum Omen {
	NONE = 0,
	DESTINY = 112,
	FAMILY = 113,
}

enum Destiny {
	NONE = 0,
	LEADER = 114,
	GENIUS = 115,
	LAYMAN = 116,
	EXILE = 117,
}

enum Family {
	NONE = 0,
	PARENT = 118,
	CHILD = 119,
	MOTHER = 120,
	FATHER = 121,
	SON = 122,
	DAUGHTER = 123,
}

enum Status {
	NONE = 0,
	ON = 124,
	OFF  = 125
}






enum Phase {
	NONE = 0,
	ENDOWMENT = 200,
	REPLENISHMENT = 201,
	PAYMENT = 202,
	APPRAISEMENT = 203,
	DISBURSEMENT = 204,
	DEVELOPMENT = 205,
	INVESTMENT = 206,
}

enum Modifier {
	NONE = 0,
	MISS = 220,
	CRIT = 221,
	MEGACRIT = 222,
	ULTRACRIT = 223
}

enum Eruption {
	NONE = 0,
	BATTLE = 9,
	AUCTION = 10,
	FEAST = 11,
	MASQUERADE = 12, 
	THEATER = 13,
	BANK = 224,
	MARKET = 225
}

enum Layer {
	NONE = 0,
	HELL = 250,
	GATE = 251,
	SANCTUARY = 252
}

enum Tooltip {
	NONE = 0,
	OVERLORD = 298,
	ESSENCE = 299,
	SIN = 300,
	TRIAL = 301,
	FACTION = 302,
	FATE = 303,
	ATTITUIDE = 304,
	DESIRE = 305,
	CLAIM = 306,
	FLAME = 307,
	TRIBUTE = 308,
	SOUL = 309,
	OBLIVION = 310,
	MADNESS = 311,
	CAGE = 312,
	SINNER = 313,
	CLOAK = 314,
	POSTURE = 315,
	JUDGMENT = 316,
	OMEN = 317,
}

enum Frame {
	NONE = 0,
	TOOLTIP = 299,
	TRIAL = 301,
	CAGE = 312,
	SINNER = 313,
	CLOAK = 314,
	HELL = 330,
	JAIL = 331,
	BANK = 332,
	SHELTER = 333,
	TREASURY = 334,
	MARKET = 335,
	MODIFIER = 336,
	CONTRIBUTION = 337,
	DEAL = 338,
}
