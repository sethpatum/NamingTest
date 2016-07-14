//
//  SetupImages.swift
//  CNToolkit
//
//  Created by saman on 7/10/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation

var namingImages = [String]()
var namingImageGroups = [[String]]()


func getImages(){
    
    namingImages = []
    
    //6 New, 3 Original
    
//    let groupWords:[String] = ["two", "address", "whole", "eye", "again", "enough", "already", "cough", "fuel", "climb", "most", "excitement", "mosquito", "decorate", "fierce", "plumb", "knead", "vengeance", "gnat", "prestigious", "amphitheater", "lacuna", "iridescent", "lieu", "wily", "aesthetic", "equestrian", "porpoise", "subtle", "palatable", "homily", "ogre", "liason", "xenophobia", "dichotomy", "menagerie", "umbrage", "fecund", "scurrilous", "heinous", "obfuscate", "plethora", "exigency", "lascivious", "paradigm", "cretonne", "vicissitude", "ethereal", "uxorious", "lugubrious", "piquant", "perspicuity", "ubiquitous", "hyperbole", "facetious", "treatise", "picot", "macabre", "anechoic", "acquiesce", "dilettante", "eyrir", "misogyny", "vertiginous", "hegemony", "insouciant", "vide", "chthonic", "vivace", "celidh" ]
    
    let group1:[String] = ["can", "hand", "saw", "heart", "watch", "key", "bed", "tree", "pencil"].shuffle()
    let group2:[String] = ["star", "rose", "chair", "scale", "baseball", "train", "house", "whistle", "scissors"].shuffle()
    let group3:[String] = ["moon", "bridge", "ring", "bell", "eggs", "cat", "comb", "flower", "saw"].shuffle()
    let group4:[String] = ["bottle", "fan", "corn", "tie", "knife", "garlic", "toothbrush", "helicopter", "broom"].shuffle()
    let group5:[String] = ["stairs", "glasses", "tank", "cloud", "anchor", "button", "octopus", "mushroom", "hanger"].shuffle()
    let group6:[String] = ["piano", "crown", "pipe", "log", "shoe", "ice cream", "wheelchair", "camel", "mask"].shuffle()
    let group7:[String] = ["sheep", "fork", "basket", "pitcher", "duck", "envelope", "pretzel", "bench", "racquet"].shuffle()
    let group8:[String] = ["toilet", "airplane", "sword", "hammer", "lion", "drill", "snail", "volcano", "seahorse"].shuffle()
    let group9:[String] = ["elbow", "vacuum", "ladder", "helmet", "lamp", "pillow", "dart", "canoe", "globe"].shuffle()
    let group10:[String] = ["doll", "whale", "needle", "dragon", "drum", "cane", "wreath", "beaver", "harmonica"].shuffle()
    let group11:[String] = ["glove", "shark", "whisk", "banana", "rainbow", "screw", "rhinocerous", "acorn", "igloo"].shuffle()
    let group12:[String] = ["coral", "arrow", "bee", "pumpkin", "candle", "triangle", "stilts", "dominoes", "cactus"].shuffle()
    let group13:[String] = ["microphone", "butterfly", "necklace", "grapes", "flashlight", "cannon", "escalator", "harp", "hammock"].shuffle()
    let group14:[String] = ["nut", "frog", "binoculars", "lobster", "owl", "volleyball", "knocker", "penguin", "stethoscope"].shuffle()
    let group15:[String] = ["violin", "oyster", "skeleton", "razor", "briefcase", "tractor", "pyramid", "muzzle", "unicorn"].shuffle()
    let group16:[String] = ["shovel", "spur", "eyebrow", "stapler", "scissors", "penguin", "funnel", "accordian", "noose"].shuffle()
    let group17:[String] = ["pear", "pupil", "pineapple", "broom", "lighthouse", "slippers", "asparagus", "compass", "latch"].shuffle()
    let group18:[String] = ["chimney", "sock", "dolphin", "axe", "kite", "goggles", "tripod", "scroll", "tongs"].shuffle()
    let group19:[String] = ["grenade", "wrench", "rake", "zipper", "hinge", "punt", "sphinx", "yoke", "trellis"].shuffle()
    let group20:[String] = ["dynamite", "mop", "spatula", "yarn", "syringe", "peacock", "palette", "protractor", "abacus"].shuffle()
    
    //Original BNT done; all new BNT from here
    
    let group21:[String] = ["spade", "zebra", "clover", "mermaid", "horseshoe", "panda", "artichoke", "ladle"].shuffle()
    let group22:[String] = ["clasp", "sickle", "pail", "moustache", "pliers", "cleats", "wheelbarrow", "cupcake", "gavel"].shuffle()
    let group23:[String] = ["ostrich", "anvil", "quill pen", "llama", "corkscrew", "catapult", "lightbulb", "hourglass", "antler"].shuffle()
    let group24:[String] = ["tuba", "trowel", "chalice", "flippers", "obelisk", "slingshot", "pegasus", "tusk", "cupola"].shuffle()
    let group25:[String] = ["pestle", "oboe", "scythe", "hashtag", "centaur", "matador", "seashell", "tambourine", "thimble"].shuffle()
    let group26:[String] = ["xylophone", "lyre", "awl", "palmette", "hexagon", "unicycle", "uvula", "ampersand", "treble clef"].shuffle()
    let group27:[String] = ["asymptote", "caduceus", "tilde", "aglet", "colander", "windrose"].shuffle()
    
    /*
     let group1:[String] = ["Abacus", "Accordian", "Acorn", "Asparagus", "Beaver"].shuffle()
     let group2:[String] = ["Bed", "Bench", "Broom", "Cactus", "Camel"].shuffle()
     let group3:[String] = ["Canoe", "Comb", "Compass", "Dart", "Domino"].shuffle()
     let group4:[String] = ["Escalator", "Flower", "Funnel", "Globe", "Hammock"].shuffle()
     */
    
    namingImageGroups = [group1, group2, group3, group4, group5, group6, group7, group8, group9, group10, group11, group12, group13, group14, group15, group16, group17, group18, group19, group20, group21, group22, group23, group24, group25, group26, group27]
    
    
    for(var k=0; k<namingImageGroups.count; k++){
        namingImages += namingImageGroups[k]
    }
    
    print(namingImages)
    
}
 