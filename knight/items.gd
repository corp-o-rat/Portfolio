extends Node
const BOOTS = preload("uid://0hiswprf5qiq")
const HELMET = preload("uid://dgtt44lfjpfha")
const LEGGINGS = preload("uid://bswi2i8xdnjib")

const CHESTPLATE = preload("uid://dh46rxrvss0ed")
const GAUNTLET = preload("uid://lscvwtjatmge")

const SWORDITEM = preload("uid://bfmhla4d4fr1m")



var helmet = [HELMET, ["head"], 1, "A shiny Hat"]
var gauntlets = [GAUNTLET, ["body/bicep/forearm", "body/bicep2/forearm2"], 1, "Shiny gloves"]
var chestplate = [CHESTPLATE, ["body", "body/bicep", "body/bicep2"], 1, "A shiny shirt"]
var leggings = [LEGGINGS, ["quad", "quad2"], 1, "Shiny pants"]
var boots = [BOOTS, ["calf", "calf2"], 1, "Shiny shoes"]
var item = [SWORDITEM, ["body/bicep/forearm/Sword"], 0, "Shiny blade"]

var empty_helmet = [null, ["head"], 0, null]
var empty_gauntlets = [null, ["body/bicep/forearm", "body/bicep2/forearm2"], 0, null]
var empty_chestplate = [null, ["body", "body/bicep", "body/bicep2"], 0, null]
var empty_leggings = [null, ["quad", "quad2"], 0, null]
var empty_boots = [null, ["calf", "calf2"], 0, null]
var empty_item = [null, ["body/bicep/forearm/Sword"], 1, null]
