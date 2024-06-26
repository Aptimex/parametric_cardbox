/*
* Copyright (c) 2024 Adam Merrill
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, version 3.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

/*
ADDITIONAL LICENSE NOTE: To enable the use of some online Customizers, a few functions are copy-pasted from the
MCAD/2Dshapes.scad library into the end of this file. That code is licensed under the LGPL license.
See https://github.com/openscad/MCAD for more info
*/

use <./OptimusPrinceps.ttf>
use <./OptimusPrincepsSemiBold.ttf>
use <./EPISODE1.ttf>
use <./norwester.otf>
use <./Orbitron-Bold.ttf>
//use <MCAD/2Dshapes.scad>


/* [Required] */

//Text to deboss into the top of the lid
lidText = "Tst";
//Font size for the lid text
lidTextFontSize = 20;
//How many cards go in each slot; RIGHT->LEFT
cards = [10,60];
//Label of each slot (in same order as cards array)
titles = ["Far Right", "Left"];
//Prefix for each slot (in same order as cards array)
prefix = ["0", "5"];

//Width of cards (or sleeves on cards)
cardOrSleeveWidth = 60;
//Extra slot width; make at least 2-3mm for cards to insert easily
slotExtraWidth = 2;
//Height of cards (or sleeves on cards)
cardOrSleeveHeight = 94;
//Extra space between top of cards/sleeves and the lid
cardExtraHeight = 2;
slotVerticalSpace = cardOrSleeveHeight + cardExtraHeight;

//How thick each individual card is
cardThickness = 0.3;
//Listed thickness of card sleeve material (one side of sleeve)
sleeveThickness = .04;
//Extra space to add to each [sleeved] card thickness to account for manufacturing variability
cardAdditionalThickness = 0.02;
//Extra slot wiggle room in the direction of the card stack. <2 will require cards to be tightly compressed and may be too tight to easily insert all at once.
slotExtraThickness = 2;
THICK = cardThickness + sleeveThickness*2 + cardAdditionalThickness;

//How tall to make the divider compartments; ~75% of card height is a good rule of thumb, and making them shorter won't reduce print time/material significantly if printing with a lid.
dividerHeight = 70;




/* [Text Options] */

//Space between the top of the box and the start of label text (including prefixes)
textTopOffset = 5;
//Desired width of text when vertical; this is just the font "size," and may not reflect actual width
labelTextWidth = 5;
//How deep to deboss the lid text; should be a multiple of layer height
lidTextDepth = 1.2;
//Diameter of prefix circle (if using inset prefixes)
prefixShapeSize = 5;
//Size of prefix text; adjust as needed to fit in space
prefixTextWidth = 5;
//Distance from textTopOffset to start of the label text (to make space for prefixes); Set to 0 if not using prefixes
labelPrefixSpace = 8;
//If generating separated side labels, this tweaks how much extra base material above/below the text is generated
labelExtraBaseWidth = 3;


prefixFont = "Norwester";
labelFont = "Orbitron";
lidFont = "EPISODE I";



/* [Optional (basic)] */

//Make a multiple of layer height
bottomThickness = 1.8;
//The 4 sides of the box; should be a multiple of nozzle size
outerWallThickness = 1.6;
//Less than 4mm will probably make it more flexible than rigid
lidThickness = 4;


//How deep the alternating slots should be offset from the outer side (mm)
slotSpacerDepth = 15;
//Thickness of walls separating card groups; thinner than 1.2 might cause bridging issues
dividerThickness = 1.2;
//How much the dividers should overlap the cards; less than 2mm may cause cards to partially slip into adjascent slots during insertion. Set (>= card width) to eliminate cutouts entirely.
dividerCardOverlap = 2;


//Width of the lid support shelf
topWidth = 15;
//How far the lid support taper overlaps with the box side; smaller values may lead to weak spot where lid support connects to top of box
topOverlap = 20;

//How wide to make the lid clips
clipWidth = 12;
//How tall the clips should be; smaller depths result in a stiffer (but more brittle) clip
clipDepth = 20;
//How much the clip shelf sticks out past the clip body; less than 2 will make lid more prone to popping off; more than 3 will make clips difficult to engage
clipShelf = 2.5;
//Generate slots in lid (instead of in-place clip) so clips printed separately (for increased strength) can be easily glued on in the right place
//lidClipsSeparate = 1; // [0:No, 1:Yes]


/* [Optional (advanced)] */

topChamferX = slotSpacerDepth;
topChamferZ = slotSpacerDepth/2;
//How much vertical wall should be on the top of each slot offset
topChamferEdge = 15;
topCfrX = (topChamferX <= slotSpacerDepth) ? topChamferX : slotSpacerDepth;
//X value of sloped wall on bottom of each slot offset
bottomChamferX = 2;
//Z value of sloped wall on bottom of each slot offset
bottomChamferZ = 5;
//How much vertical wall should be on the bottom of each slot offset
bottomChamferEdge = 10;
bottomCfrX = (bottomChamferX <= slotSpacerDepth) ? bottomChamferX : slotSpacerDepth;

/* [Components to generate] */

//Generate the main box
makeBox = 1; // [0:No, 1:Yes]
//Make embossed lebels for each slot
makeSideLabels = 1; // [0:No, 1:Yes]
//Generate side labels as sparate parts to make multi-color printing easier. Requires makeSideLabels
separatedSideLabels = 1; // [0:No, 1:Yes]
//Emboss a circle in the prefix location and deboss the prefix text within it
prefixInset = 0; // [0:No, 1:Yes]
//Generate the lid shelf; turn off if you don't need a lid and want JUST the organizer box
makeLidShelf = 1; // [0:No, 1:Yes]
//Generate a lid on top of the box; DO NOT PRINT LIKE THIS; only used to visualize the fit
lidOnTop = 0; // [0:No, 1:Yes]
//Generate the lid on the side (upside-down) for printing
lidOnSide = 1; // [0:No, 1:Yes]
//lidDeconstructed = false; //TODO
//Generate sides for the lid so everything is fully enclosed
makeLidSides = 1; // [0:No, 1:Yes]
//Generate text debossed into the top of the lid
makeLidText = 1; // [0:No, 1:Yes]
//Instead of debossed text, generate a text surface that can be easily painted a different color in the slicer. Requires makeLidText
makeLidTextMulticolor = 0; // [0:No, 1:Yes]
//Generate efficient supports for in-place lid clips so the slicer doesn't have to generate any
//makeClipSupport = 0; // [0:No, 1:Yes]
//Print angles on top of dividers to make it easer to slide in cards (from the right side) without getting caught on the dividers.
dividerTriangles = 1; // [0:No, 1:Yes]
//Generates the separated lid clips in a print orientation that will make them much stronger than an in-place print. Make sure to print two of them.
//separatedClips = 1; // [0:No, 1:Yes]

//Dummy module disables Customizer parsing of user-facing variables
module dummy() {}

//Auto-calculated values
slotWidth = cardOrSleeveWidth+slotExtraWidth;
innerWidth = slotWidth+slotSpacerDepth;
outerWidth = innerWidth + outerWallThickness*2;
upperHeight = slotVerticalSpace-dividerHeight;
cutoutWidth = innerWidth-2*slotSpacerDepth-slotExtraWidth-dividerCardOverlap;
initialOffset = outerWallThickness-dividerThickness;

e = 0.01 + 0;
separatedClips = 1 + 0;
makeClipSupport = 0 + 0;


generate(lidText, cards, titles, prefix, 0, initialOffset);
//dominionBase();

//Dominion 2e base cards
module dominionBase() {
    lidText = "Base";
    cards = [60,40,30,24,12,12,30];
    titles = ["Copper", "Silver", "Gold", "Estate", "Duchy", "Province", "Curse"];
    prefix = ["0", "3", "6", "2", "5", "8", "0"];
    generate(lidText, cards, titles, prefix, 0, initialOffset);
    
}

//Dominion 2e standalone base cards
module dominionStandaloneBase() {
    lidText = "Base (All)";
    cards = [60,40,30,12,16,24,12,12,30];
    titles = ["Copper", "Silver", "Gold", "Platinum", "Potion", "Estate", "Duchy", "Province", "Curse"];
    prefix = ["0", "3", "6", "9", "4", "2", "5", "8", "0"];
    generate(lidText, cards, titles, prefix, 0, initialOffset);
    
}

//Dominion 2e kingdom cards
module dominion2e() {
    lidText = "Dominion";
    cards = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,26];
    titles = ["Artisan", "Bandit", "Bureaucrat", "Cellar", "Chapel", "Council Room", "Festival", "Harbinger", "Laboratory", "Library", "Market", "Merchant", "Militia", "Mine", "Moat", "Moneylender", "Poacher", "Remodel", "Sentry", "Smithy", "Throne Room", "Vassal", "Village", "Witch", "Workshop", "Gardens", "Randomizer"];
    prefix = ["6",5,4,2,2,5,5,3,5,5,5,3,4,5,2,4,4,4,5,4,4,3,3,5,3,4,"   "];
    generate(lidText, cards, titles, prefix, 0, initialOffset);
    
}

//Make Everything
module generate(boxTitle, cardArray, titleArray, prefixArray, i, offset, flip=false) {
    
    //Iterate over the array of card numbers
    if (i < len(cardArray)) {
        //Space allotted for all cards in this slot
        thickness = cardArray[i]*THICK+slotExtraThickness;
        
        //Alternate generating front and back slots
        if (flip) {
            
            //Slot (back)
            if (makeBox) translate([outerWallThickness,offset,0]) slotB(cardArray[i]);
            
            //Label Text
            if (makeSideLabels && makeBox) {
                makeLabel(prefixArray, titleArray, i, offset, thickness);
            }
            
            nextOffset = offset+thickness+dividerThickness;
            flip=false;
            //echo(i);
            generate(boxTitle, cardArray, titleArray, prefixArray, i+1, nextOffset, flip);
        } else {
            
            //Slot (front)
            if (makeBox) translate([outerWallThickness,offset,0]) slotF(cardArray[i]);
            
            //Label Text
            if (makeSideLabels && makeBox) {
                makeLabel(prefixArray, titleArray, i, offset, thickness);
            }
            
            
            nextOffset = offset+thickness+dividerThickness;
            flip=true;
            //echo(i);
            generate(boxTitle, cardArray, titleArray, prefixArray, i+1, nextOffset, flip);
        }
    } else { //Final touches after main storage done
        //Account for the final wall in total length
        finalLength = offset + outerWallThickness;
        
        if (makeBox) {
            //Generate bottom and outer side walls
            sides(finalLength);
            
            //Generate end supports for the lid
            if (makeLidShelf) endTops(finalLength);
        }
        
        //Generate the lid on top to verify fit
        if (lidOnTop) translate([0,-topWidth,dividerHeight]) lid(finalLength, boxTitle);
        
        //Generate the lid on the floor for printing
        if (lidOnSide) translate([outerWidth*2+5,-topWidth,upperHeight+lidThickness-bottomThickness]) rotate([0,180,0]) lid(finalLength, boxTitle);
        
        if (separatedClips) {
            translate([outerWidth*2+20,5,-bottomThickness]) {
                uClip();
            }
        
            
        }
    }
}

//Generate all the outer sides based on the final inner length
module sides(length=50) {
    //Front
    cube([outerWallThickness,length,dividerHeight]);
    
    //Back
    translate([innerWidth+outerWallThickness,0,0]) cube([outerWallThickness,length,dividerHeight]);
    
    //Bottom
    translate([0,0,-bottomThickness]) cube([outerWidth,length,bottomThickness]);
    
    //Right side
    cube([outerWidth,outerWallThickness,dividerHeight]);
    translate([0,outerWallThickness,dividerHeight]) mirror([0,1,0]) tPrism(outerWidth, outerWallThickness, outerWallThickness);
    
    //Left side
    translate([0,length-outerWallThickness,0]) {
        cube([outerWidth,outerWallThickness,dividerHeight]);
        translate([0,0,dividerHeight]) tPrism(outerWidth, outerWallThickness, outerWallThickness);
    }
}

//Generate the side labels
module makeLabel(prefixArray, labelArray, i, offset, thickness) {
    //Calculate location of text centered on slot
    centerOffset = offset+dividerThickness+(labelTextWidth+thickness)/2;
    
    //Handle missing prefix or label gracefully
    thisPrefix = (prefixArray[i] == undef) ? "" : prefixArray[i];
    thisLabel = (labelArray[i] == undef) ? "" : labelArray[i];
    
    if (separatedSideLabels) {
        tagRenderSpace = 10;
        
        translate([-tagRenderSpace, centerOffset + labelExtraBaseWidth/2, 0])
        rotate([0, 0, 180])
        color([0,0,0])
        cube(size=[dividerHeight, labelTextWidth+labelExtraBaseWidth, 1.2], center=false);
        
        //Generate and move text onto individual tags
        translate([-textTopOffset-labelPrefixSpace-tagRenderSpace, centerOffset, 1.2-e])
        rotate([0,0,180])
        linear_extrude(height=1) {
            text(str(thisLabel), size=labelTextWidth, font=labelFont);
        }
        
        //rotate([0,-90,180])
        //translate([0, 0, -dividerHeight])
        makePrefix(thisPrefix, centerOffset);
        
        
    } else {
        /*
        translate([0, centerOffset, dividerHeight])
        rotate([0, 90, 180])
        color([255/255, 0/255, 0/255]) cube(size=[dividerHeight, labelTextWidth, .5], center=false);
        */
        
        //Generate and move text onto the box
        translate([0, centerOffset, dividerHeight-textTopOffset-labelPrefixSpace])
        rotate([0,90,180])
        linear_extrude(height=1) {
            text(str(thisLabel), size=labelTextWidth, font=labelFont);
        }
        makePrefix(thisPrefix, centerOffset);
    }
}

//Generate text (and/or a circle) to put before each slot label
module makePrefix(thisPrefix, centerOffset) {
    tagRenderSpace = 10;
    t = separatedSideLabels ? [-tagRenderSpace-textTopOffset,centerOffset,1.2-e] : [0, centerOffset, dividerHeight-textTopOffset];
    r = separatedSideLabels ? [0,0,180] : [0,90,180];
    
    translate(t) rotate(r)
    linear_extrude(height=1) {
        translate([labelTextWidth/2,labelTextWidth/2,0]) {
            
            if (prefixInset) difference() {
                circle(d=prefixShapeSize, $fn=20);
                text(str(thisPrefix), size=prefixTextWidth, font=prefixFont, halign="center", valign="center");
                
            } else {
                text(str(thisPrefix), size=prefixTextWidth, font=prefixFont, halign="center", valign="center");
            }
            
        }
        
    }
}

//Generate a wall and front slot spacer to hold cards
module slotF(numCards=10) {
    if (dividerTriangles) translate([0,0,dividerHeight]) {
        translate([0,dividerThickness,0]) mirror([0,1,0]) tPrism(innerWidth,dividerThickness,dividerThickness);
    }
    
    difference() {
        cube([innerWidth,dividerThickness,dividerHeight]);
        translate([(innerWidth-cutoutWidth)/2,0,5]) wallCutout(cutoutWidth);
    }
    
    translate([slotWidth,dividerThickness,0]) {
        spacer(false, numCards);
    }
}

//Generate a wall and back slot spacer to hold cards
module slotB(numCards=10) {
    if (dividerTriangles) translate([0,0,dividerHeight]) {
        translate([0,dividerThickness,0]) mirror([0,1,0]) tPrism(innerWidth,dividerThickness,dividerThickness);
    }
    
    //Cutout some of the middle of the spacer to save plastic/time
    difference() {
        cube([innerWidth,dividerThickness,dividerHeight]);
        translate([(innerWidth-cutoutWidth)/2,0,5]) wallCutout(cutoutWidth);
    }
    
    translate([0,dividerThickness,0]) {
        spacer(true, numCards);
    }
}

module wallCutout(width) {
    /* Reference: System of equations to calculate maximum centered cuttout width (card touches edge)
    
    side = (outerWidth - cutoutWidth)/2;
    side + cutoutWidth[max] = cardWidth;
    ->
    (outerWidth - cutoutWidth)/2 + cutoutWidth = cardWidth
    1/2cutoutWidth = cardWidth - 1/2*outerWidth
    cutoutWidth = 2*cardWidth - outerWidth
    */
    
    bevelX = 10;
    bevelZ = 10;
    
    difference() {
        cube([width,dividerThickness, dividerHeight-15]);
        
        //Bevel the edges to look nice
        translate([bevelX,0,0]) rotate([0,0,90]) tPrism(dividerThickness,bevelX,bevelZ);
        translate([width-bevelX,dividerThickness,0]) rotate([0,0,270]) tPrism(dividerThickness,bevelX,bevelZ);
        translate([bevelX,dividerThickness,dividerHeight-15]) rotate([0,180,90]) tPrism(dividerThickness,bevelX,bevelZ);
        translate([width-bevelX,0,dividerHeight-15]) rotate([0,180,270]) tPrism(dividerThickness,bevelX,bevelZ);
    }
    
}

module spacer(back=false, numCards=10) {
    thickness = numCards * THICK + slotExtraThickness;
    
    //Cutout some of the middle of the spacer to save plastic/time
    difference() {
        cube([slotSpacerDepth,thickness+e,dividerHeight]);
        
        if (back) {
            //Middle block cutout
            translate([0,0,bottomChamferEdge+bottomChamferZ]) cube([slotSpacerDepth,thickness,dividerHeight-topChamferEdge-bottomChamferEdge-topChamferZ-bottomChamferZ]);
            
            //Top+bottom bevels
            translate([slotSpacerDepth-bottomCfrX,0,bottomChamferEdge+bottomChamferZ]) rotate([180,0,90]) tPrism(thickness, bottomCfrX, bottomChamferZ);
            translate([slotSpacerDepth,0,dividerHeight-topChamferEdge]) rotate([270,0,90]) tPrism(thickness, topChamferZ, topCfrX);
        } else {
            //Middle block cutout
            translate([0,0,bottomChamferEdge+bottomChamferZ]) cube([slotSpacerDepth,thickness,dividerHeight-topChamferEdge-bottomChamferEdge-topChamferZ-bottomChamferZ]);
            
            //Top+bottom bevels
            translate([bottomCfrX,thickness,bottomChamferEdge+bottomChamferZ]) rotate([180,0,270]) tPrism(thickness, bottomCfrX, bottomChamferZ);
            translate([0,thickness,dividerHeight-topChamferEdge]) rotate([270,0,270]) tPrism(thickness, topChamferZ, topCfrX);
        }
        
    }
}

//Generate triangular prism (90 deg)
module tPrism(d, w, h){
       polyhedron(
           points=[[0,0,0], [d,0,0], [d,w,0], [0,w,0], [0,w,h], [d,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
       );
}

//Generate the top lid supports
module endTops(wallLength) {
    //Generate tops with clip holes and move into possition
    translate([0,-topWidth+e,dividerHeight-topOverlap]) endTopClip(wallLength);
    translate([0,wallLength-e+topWidth,dividerHeight-topOverlap]) mirror([0,1,0]) endTopClip(wallLength);
}

//Generate a single lid support with a clip hole
module endTopClip(wallLength) {
    difference() {
        cube([outerWidth, topWidth, upperHeight+topOverlap]);
        
        //Create taper (overextend to avoid ghost walls)
        translate([outerWidth+1,topWidth,0]) rotate([0,0,180]) tPrism(outerWidth+2,topWidth,topOverlap+upperHeight);
        
        //Add clip hole
        translate([(outerWidth-clipWidth-.5)/2, clipShelf, topOverlap+upperHeight+.5-25]) uClipHole();
        //Crappy old clip
        //translate([outerWidth/2-clipWidth/2, clipOffsetHoriz, topOverlap+upperHeight+.5-clipDepth-clipExtends-clipHoleExtraVert]) clipHole();
        
    }
}

//Generate the geometry for the uClip hole
module uClipHole() {
    cube([clipWidth+.5, 11, clipDepth+5]);
    translate([0,-topWidth,0]) cube([clipWidth+.5,topWidth,clipDepth+5-3]);
}

//Generate the geometry for the clip hole
module clipHole() {
    cube([clipWidth, clipThickness+clipHoleExtraHoriz, clipDepth+clipExtends+clipHoleExtraVert]);
    translate([0,-topWidth,0]) cube([clipWidth,topWidth,clipExtends+clipHoleExtraVert]);
}

//Generate the lid
module lid(wallLength, title="") {
    //Gap between the lid walls/sides and the box
    gap = 0.5;
    
    
    //top (with optional text)
    translate([0,0,upperHeight]) {
        difference() {
            cube([outerWidth, wallLength+topWidth*2, lidThickness]);
            if (makeLidText) {
                translate([outerWidth/2, wallLength/2+topWidth, lidThickness-lidTextDepth]) makeLidText(lidThickness, lidTextDepth, title);
            }
            
            //Clip spaces
            clipBaseDepth = 1.5;
            clipBaseWidth = clipWidth + .5;
            if (separatedClips) {
                translate([(outerWidth-clipBaseWidth)/2, -e, clipBaseDepth])
                mirror([0,0,1])
                cube([clipBaseWidth, 15+clipShelf+.5, lidThickness]);
            
                translate([(outerWidth-clipBaseWidth)/2, wallLength+topWidth*2-15-clipShelf-.5, clipBaseDepth])
                mirror([0,0,1])
                cube([clipBaseWidth, 15+clipShelf+.5+e, lidThickness]);
            }
        }
    }
    
    
    //sides
    if (makeLidSides) {
        
    translate([0,topWidth+gap,gap]) difference() {
        cube([outerWallThickness, wallLength-(gap*2), upperHeight+lidThickness-gap]);
        
        translate([0,outerWallThickness,0]) mirror([0,1,0]) tPrism(outerWallThickness,outerWallThickness,outerWallThickness);
        translate([0,wallLength-outerWallThickness-gap,0]) mirror([0,0,0]) tPrism(outerWallThickness,outerWallThickness,outerWallThickness);
    }
    
    translate([outerWidth-outerWallThickness,topWidth+gap,gap]) difference() {
        cube([outerWallThickness, wallLength-(gap*2), upperHeight+lidThickness-gap]);
        
        translate([0,outerWallThickness,0]) mirror([0,1,0]) tPrism(outerWallThickness,outerWallThickness,outerWallThickness);
        translate([0,wallLength-outerWallThickness-gap,0]) mirror([0,0,0]) tPrism(outerWallThickness,outerWallThickness,outerWallThickness);
    }
    }
    
    //clips
    if (!separatedClips) { //generate in place; prone to breaking
        translate([clipWidth+(outerWidth-clipWidth)/2,5+3+.1,upperHeight-15]) rotate([90,0,-90]) uClip();
        translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-5-3.1,upperHeight-15]) rotate([90,0,90]) uClip();
    }
    
    
    /*Old crappy clips translate([clipWidth+(outerWidth-clipWidth)/2,clipOffsetHoriz+clipThickness+.1,upperHeight-clipDepth-clipExtends]) rotate([0,0,180]) lidClip();
    //translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-outerWallThickness-clipOffsetHoriz-clipHoleExtraHoriz,upperHeight-clipDepth-clipExtends]) lidClip();
    translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-clipOffsetHoriz-clipThickness-.1,upperHeight-clipDepth-clipExtends]) lidClip();
    */
}

/*These are crap, don't use them
module lidClip() {
    cube([clipWidth, clipThickness, clipDepth+clipExtends]);
    translate([0,clipThickness+clipShelf,clipExtends]) rotate([180,0,0]) tPrism(clipWidth,clipShelf,clipExtends);
}
*/

//Vastly superior clips; minimal customization because they work well with these values (and not many others), so why would you change them?
module uClip() {
    mirror([0,1,0]) linear_extrude(height=clipWidth) donutSlice([3,3],[5,5],0,180,$fn=100);
    translate([-5,0,0]) cube([2,clipDepth-5,clipWidth]);
    translate([3,0,0]) {
        cube([2,clipDepth-6,clipWidth]); //movable end
        
        if (makeClipSupport) {
            //supports
            translate([0,14.2,0]) cube([2,1-.2,.8]);
            translate([0,14.2,(clipWidth-.8)/2]) cube([2,1-.2,.8]);
            translate([0,14.2,clipWidth-.8]) cube([2,1-.2,.8]);
            
            translate([1+clipShelf,12.2,0]) cube([1,3-.2,.8]);
            translate([1+clipShelf,12.2,clipWidth-.8]) cube([1,3-.2,.8]);
        }
    }
    
    translate([5,8.5,clipWidth]) rotate([0,90,0]) tPrism(clipWidth,3,clipShelf);
    
    //Base
    if (separatedClips) {
        translate([5+clipShelf+.5+.1,clipDepth-5,0]) mirror([1,0,0]) cube([clipShelf+15,1.5,clipWidth]);
    }
    
}

//Generate text to put on the lid
module makeLidText(lidThickness, depth, title="") {
    /*
    rotate([0,0,-90]) linear_extrude(height=depth) {
        text(title, size=lidTextFontSize, font=lidFont, halign="center", valign="center");
    }
    */
    
    rotate([0,0,-90])
    difference() {
        translate([0, 0, e])
        linear_extrude(height=depth) {
            text(title, size=lidTextFontSize, font=lidFont, halign="center", valign="center");
        }
        
        if (makeLidTextMulticolor) {
            linear_extrude(height=depth) {
                offset(delta = -.01)
                text(title, size=lidTextFontSize, font=lidFont, halign="center", valign="center");
            }
        }
        
    }
    
}

/*Debug stuff for clips
//translate([0,-20,-bottomThickness]) clipTest();
module clipTest() {
    lidOnSIde = true;
    translate([30,10,16.2]) rotate([-90,0,-90]) uClip();
    translate([30,10-5-clipShelf,0]) cube([clipWidth,15,1.2]);
    
    difference() {
        cube([18,15,10]);
        translate([3, clipShelf, -14.5]) uClipHole();
    }
}
*/


/*
ADDITIONAL LICENSE NOTE: To enable the use of some online Customizers, the below functions are copy-pasted from the
MCAD/2Dshapes.scad library. That library code is licensed under the LGPL license.
See https://github.com/openscad/MCAD for more info
*/

module donutSlice(innerSize,outerSize, start_angle, end_angle) {
    difference()
    {
        pieSlice(outerSize, start_angle, end_angle);

        if(is_list(innerSize) && len(innerSize) > 1)
             ellipse(innerSize[0]*2,innerSize[1]*2);
        else
            circle(innerSize);
    }
}

module pieSlice(size, start_angle, end_angle) { //size in radius(es)
    rx = (is_list(size) && len(size) > 1)? size[0] : size;
    ry = (is_list(size) && len(size) > 1)? size[1] : size;
    trx = rx* sqrt(2) + 1;
    try = ry* sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;

    if(end_angle > start_angle)
        intersection() {
        if(is_list(size) && len(size) > 1)
            ellipse(rx*2,ry*2);
        else
            circle(rx);
        polygon([
            [0,0],
            [trx * cos(a0), try * sin(a0)],
            [trx * cos(a1), try * sin(a1)],
            [trx * cos(a2), try * sin(a2)],
            [trx * cos(a3), try * sin(a3)],
            [trx * cos(a4), try * sin(a4)],
            [0,0]
        ]);
    }
}

module ellipse(width, height) {
    scale([1, height/width, 1])
    circle(r=width/2);
}
