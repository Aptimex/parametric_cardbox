use <./OptimusPrinceps.ttf>
use <./OptimusPrincepsSemiBold.ttf>
use <./EPISODE1.ttf>
use <./norwester.otf>
use <MCAD/2Dshapes.scad>
prefixFont = "OptimusPrinceps";
labelFont = "Norwester";
lidFont = "EPISODE I";

!clipTest();
module clipTest() {
    translate([30,0,16.2]) rotate([-90,0,-90]) uClip();
    translate([30,-5-clipShelf,0]) cube([clipWidth,15,1.2]);
    
    difference() {
        cube([18,15,10]);
        translate([3, clipShelf, -14.5]) uClipHole();
    }
}


bottomThickness = 1.8;
outerWallThickness = 1.5;
lidThickness = 4;

cardOrSleeveWidth = 60;

cardOrSleeveHeight = 94;
cardExtraHeight = 2;
slotVerticalSpace = cardOrSleeveHeight + cardExtraHeight;
slotExtraWidth = 2;
slotSpacerDepth = 15;

dividerThickness = 1.2; //0.8 is too thin for bridging
dividerHeight = 70; //making this shorter won't lower print time
dividerCardOverlap = 2;

slotWidth = cardOrSleeveWidth+slotExtraWidth;
innerWidth = slotWidth+slotSpacerDepth;
outerWidth = innerWidth + outerWallThickness*2;
upperHeight = slotVerticalSpace-dividerHeight;
cutoutWidth = innerWidth-2*slotSpacerDepth-slotExtraWidth-dividerCardOverlap;
initialOffset = outerWallThickness-dividerThickness;

cardThickness = 0.3;
sleeveThickness = .04;
cardAdditionalThickness = 0.02;
slotExtraThickness = 1;
THICK = cardThickness + sleeveThickness*2 + cardAdditionalThickness;

topChamferX = 15;
topChamferZ = 8;
topChamferEdge = 15;
topCfrX = (topChamferX <= slotSpacerDepth) ? topChamferX : slotSpacerDepth;

bottomChamferX = 2;
bottomChamferZ = 5;
bottomChamferEdge = 10;
bottomCfrX = (bottomChamferX <= slotSpacerDepth) ? bottomChamferX : slotSpacerDepth;

textTopOffset = 5;
cardTextWidth = 5;
lidTextDepth = 1.2;

//Width of the top shelf
topWidth = 15;
//How far the top taper overlaps with the box side
topOverlap = 20;

clipWidth = 12;
clipDepth = 20;
clipShelf = 2.5;


makeBox = true;
lidOnTop = true;
lidOnSide = true;
//lidDeconstructed = false;
makeSideLabels = true;
genLidText = true;

lidText = "Tmp";
lidTextHeight = 20;

cards = [60,10];
titles = ["Copper", "Kingdom"];
prefix = ["0"];
//labelPrefixSpacer = "  ";
labelPrefixSpace = 6; //including prefix space itself


generate(lidText, cards, titles, prefix, 0, initialOffset);
//dominion2e();

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
    prefix = [6,5,4,2,2,5,5,3,5,5,5,3,4,5,2,4,4,4,5,4,4,3,3,5,3,4,"   "];
    generate(lidText, cards, titles, prefix, 0, initialOffset);
    
}

//Make Everything
module generate(boxTitle, cardArray, titleArray, prefixArray, i, offset, flip=false) {
    //Space allotted all cards in this slot
    thickness = cardArray[i]*THICK+slotExtraThickness;
    
    //Iterate over the array of card numbers
    if (i < len(cardArray)) {
        
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
            generate(boxTitle, cardArray, titleArray, prefixArray, i+1, nextOffset, flip);
        }
    } else { //Final touches after main storage done
        //Account for the final wall in total length
        finalLength = offset + outerWallThickness;
        
        if (makeBox) {
            //Generate bottom and outer side walls
            sides(finalLength);
            
            //Generate end supports for the lid
            endTops(finalLength);
        }
        
        //Generate the lid on top to verify fit
        if (lidOnTop) translate([0,-topWidth,dividerHeight]) lid(finalLength, boxTitle);
        
        //Generate the lid on the floor for printing
        if (lidOnSide) translate([outerWidth*2+5,-topWidth,upperHeight+lidThickness-bottomThickness]) rotate([0,180,0]) lid(finalLength, boxTitle);
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
    
    //Left side
    translate([0,length-outerWallThickness,0]) cube([outerWidth,outerWallThickness,dividerHeight]);
}

//Generate the side labels
module makeLabel(prefixArray, labelArray, i, offset, thickness) {
    //Calculate location of text centered on slot
    centerOffset = offset+dividerThickness+(cardTextWidth+thickness)/2;
    
    //Handle missing prefix or label gracefully
    thisPrefix = (prefixArray[i] == undef) ? "" : prefixArray[i];
    thisLabel = (labelArray[i] == undef) ? "" : labelArray[i];
    
    //Generate and move text to that location
    translate([0, centerOffset, dividerHeight-textTopOffset-labelPrefixSpace]) rotate([0,90,180]) linear_extrude(height=1) {
        //text(str(thisPrefix,labelPrefixSpacer,thisLabel), size=cardTextWidth, font=labelFont);
        text(str(thisLabel), size=cardTextWidth, font=labelFont);
    }
    makePrefix(thisPrefix, centerOffset);
}

module makePrefix(thisPrefix, centerOffset) {
    translate([0, centerOffset, dividerHeight-textTopOffset]) rotate([0,90,180]) linear_extrude(height=1) {
        translate([cardTextWidth/2,cardTextWidth/2,0]) difference() {
            circle(d=cardTextWidth, $fn=20);
            text(str(thisPrefix), size=cardTextWidth, font=prefixFont, halign="center", valign="center");
        }
        
    }
}

//Generate a wall and front slot spacer to hold cards
module slotF(numCards=10) {
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
    
    difference() {
        cube([width,dividerThickness, dividerHeight-15]);
        
        //Bevel the edges to look nice
        translate([4,0,0]) rotate([0,0,90]) tPrism(dividerThickness,4,10);
        translate([width-4,dividerThickness,0]) rotate([0,0,270]) tPrism(dividerThickness,4,10);
        translate([4,dividerThickness,dividerHeight-15]) rotate([0,180,90]) tPrism(dividerThickness,4,10);
        translate([width-4,0,dividerHeight-15]) rotate([0,180,270]) tPrism(dividerThickness,4,10);
    }
    
}

module spacer(back=false, numCards=10) {
    thickness = numCards * THICK + slotExtraThickness;
    
    //Cutout some of the middle of the spacer to save plastic/time
    difference() {
        cube([slotSpacerDepth,thickness,dividerHeight]);
        
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

//Generate triangular prism
module tPrism(d, w, h){
       polyhedron(
           points=[[0,0,0], [d,0,0], [d,w,0], [0,w,0], [0,w,h], [d,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
       );
}

//Generate the top lid supports
module endTops(wallLength) {
    //Generate tops with clip holes and move into possition
    translate([0,-topWidth,dividerHeight-topOverlap]) endTopClip(wallLength);
    translate([0,wallLength+topWidth,dividerHeight-topOverlap]) mirror([0,1,0]) endTopClip(wallLength);
}

//Generate a single lid support with a clip hole
module endTopClip(wallLength) {
    difference() {
        cube([outerWidth, topWidth, upperHeight+topOverlap]);
        
        //Create taper
        translate([outerWidth,topWidth,0]) rotate([0,0,180]) tPrism(outerWidth,topWidth,topOverlap+upperHeight);
        
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
    translate([0,0,upperHeight]) difference() {
        cube([outerWidth, wallLength+topWidth*2, lidThickness]);
        if (genLidText) {
            translate([outerWidth/2,wallLength/2+topWidth,lidThickness-lidTextDepth]) makeLidText(lidThickness, lidTextDepth, title);
        }
    }
    
    
    //sides
    translate([0,topWidth+gap,gap]) cube([outerWallThickness, wallLength-(gap*2), upperHeight+lidThickness-gap]);
    translate([outerWidth-outerWallThickness,topWidth+gap,gap]) cube([outerWallThickness, wallLength-(gap*2), upperHeight+lidThickness-gap]);
    
    //clips
    translate([clipWidth+(outerWidth-clipWidth)/2,5+3+.1,upperHeight-15]) rotate([90,0,-90]) uClip();
    
    translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-5-3.1,upperHeight-15]) rotate([90,0,90]) uClip();
    
    /*Old crappy clips translate([clipWidth+(outerWidth-clipWidth)/2,clipOffsetHoriz+clipThickness+.1,upperHeight-clipDepth-clipExtends]) rotate([0,0,180]) lidClip();
    //translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-outerWallThickness-clipOffsetHoriz-clipHoleExtraHoriz,upperHeight-clipDepth-clipExtends]) lidClip();
    translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-clipOffsetHoriz-clipThickness-.1,upperHeight-clipDepth-clipExtends]) lidClip();
    */
}

//These are crap, don't use them
module lidClip() {
    cube([clipWidth, clipThickness, clipDepth+clipExtends]);
    translate([0,clipThickness+clipShelf,clipExtends]) rotate([180,0,0]) tPrism(clipWidth,clipShelf,clipExtends);
}

//Vastly superior clips
module uClip() {
    mirror([0,1,0]) linear_extrude(height=clipWidth) donutSlice([3,3],[5,5],0,180);
    translate([-5,0,0]) cube([2,clipDepth-5,clipWidth]);
    translate([3,0,0]) cube([2,clipDepth-6,clipWidth]); //movable end
    
    //cube([12, 2, 10]);
    translate([5,9,clipWidth]) rotate([0,90,0]) tPrism(clipWidth,3,clipShelf);
}

module makeLidText(lidThickness, depth, title="") {
    rotate([0,0,-90]) linear_extrude(height=depth) {
        text(title, size=lidTextHeight, font=lidFont, halign="center", valign="center");
    }
}
