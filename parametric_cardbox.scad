use <./OptimusPrinceps.ttf>
use <./OptimusPrincepsSemiBold.ttf>
use <./EPISODE1.ttf>

bottomThickness = 1.8;
outerWallThickness = 1.5;
lidThickness = 4;

cardOrSleeveWidth = 60;

cardOrSleeveHeight = 94;
cardExtraHeight = 2;
slotVerticalSpace = cardOrSleeveHeight + cardExtraHeight;
slotExtraWidth = 2;
slotSpacerDepth = 15;

dividerThickness = .8;
dividerHeight = 70;
dividerCardOverlap = 3;

slotWidth = cardOrSleeveWidth+slotExtraWidth;
innerWidth = slotWidth+slotSpacerDepth;
outerWidth = innerWidth + outerWallThickness*2;
upperHeight = slotVerticalSpace-dividerHeight;
cutoutWidth = innerWidth-2*slotSpacerDepth-slotExtraWidth-dividerCardOverlap;

cardThickness = 0.3;
sleeveThickness = .05;
cardAdditionalThickness = 0.15;
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
cardTextWidth = 4.5;
lidTextDepth = 1.2;

//Width of the top shelf
topWidth = 20;//12;    
//How far the top taper overlaps with the box side
topOverlap = 20;

clipWidth = 12;//12;
clipThickness = 2;
clipDepth = 15;//8;
clipExtends = 3;
clipShelf = 2;
clipHoleExtraVert = 8;
clipHoleExtraHoriz = clipShelf+1;
clipOffsetHoriz = clipShelf+1;

//Clip size constrains to ensure so it will intersect the lid support
//Just uses similar triangle proportions
minClipHoleOffset = clipDepth/(upperHeight+topOverlap)*topWidth;
maxClipDepth = (topWidth-1.2)/topWidth*(upperHeight+topOverlap);

contrainedClipHoleOffset = (minClipHoleOffset <= topWidth-1.5) ? clipOffsetHoriz : minClipHoleOffset;
contrainedClipDepth = (minClipHoleOffset <= topWidth-1.5) ? clipOffsetHoriz : minClipHoleOffset;



lidOnTop = true;
lidOnSide = false;
lidDeconstructed = false;
makeSideLabels = false;
genLidText = false;

lidText = "Base";
lidTextHeight = 25;
cards = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12];
titles = ["Artisan", "Bandit", "Bureaucrat", "Cellar", "Chapel", "Council Room", "Festival", "Harbinger", "Laboratory", "Library", "Market", "Merchant", "Militia", "Mine", "Moat", "Moneylender", "Poacher", "Remodel", "Sentry", "Smithy", "Throne Room", "Vassal", "Village", "Witch", "Workshop", "Gardens"];


cards2 = [60,40,30,12,16,24,12,12,30,10];
titles2 = ["Copper", "Silver", "Gold", "Platinum", "Potion", "Estate", "Duchy", "Province", "Curses", "Blank"];
cost2 = ["0", "3", "6", "9", "4", "2", "5", "8", "0"," "];


//generate(cards, titles, 0, outerWallThickness-dividerThickness);
generate(cards2, titles2, 0, outerWallThickness-dividerThickness);
//translate([.3,.3,0]) slotF();
//translate([.3,7,0]) slotB();

module generate(cardArray, titleArray, i, offset, flip=false) {
    //Space allotted all cards in this slot
    thickness = cardArray[i]*THICK;
    
    //Iterate over the array of card numbers
    if (i < len(cardArray)) {
        
        //Alternate generating front and back slots
        if (flip) {
            
            //Slot (back)
            translate([outerWallThickness,offset,0]) slotB(cardArray[i]);
            
            //Label Text
            if (makeSideLabels) {
                makeText(titleArray, i, offset, thickness);
            }
            
            nextOffset = offset+thickness+dividerThickness;
            flip=false;
            generate(cardArray, titleArray, i+1, nextOffset, flip);
        } else {
            
            //Slot (front)
            translate([outerWallThickness,offset,0]) slotF(cardArray[i]);
            
            //Label Text
            if (makeSideLabels) {
                makeText(titleArray, i, offset, thickness);
            }
            
            
            nextOffset = offset+thickness+dividerThickness;
            flip=true;
            generate(cardArray, titleArray, i+1, nextOffset, flip);
        }
    } else { //Final touches after main storage done
        //Account for the final wall in total length
        finalLength = offset + outerWallThickness;
        
        //Generate bottom and outer side walls
        sides(finalLength);
        
        //Generate end supports for the lid
        endTops(finalLength);
        
        //Generate the lid on top to verify fit
        if (lidOnTop) translate([0,-topWidth,dividerHeight]) lid(finalLength);
        
        //Generate the lid on the floor for printing
        if (lidOnSide) translate([outerWidth*2+5,-topWidth,upperHeight+lidThickness-bottomThickness]) rotate([0,180,0]) lid(finalLength);
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
module makeText(textArray, i, offset, thickness) {
    //Calculate location of text centered on slot
    centerOffset = offset+dividerThickness+(cardTextWidth+thickness)/2;
    
    //Generate and move text to that location
    translate([0, centerOffset, dividerHeight-textTopOffset]) rotate([0,90,180]) linear_extrude(height=1) {
        text(textArray[i], size=cardTextWidth, font="EPISODE I");
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
    thickness = numCards * THICK;
    
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
    /*
    translate([outerWidth/2-clipWidth/2, clipOffsetHoriz, topOverlap+upperHeight+.5-clipDepth-clipExtends-clipHoleExtraVert]) clipHole();
    */
    difference() {
        cube([outerWidth, topWidth, upperHeight+topOverlap]);
        
        //Create taper
        translate([outerWidth,topWidth,0]) rotate([0,0,180]) tPrism(outerWidth,topWidth,topOverlap+upperHeight);
        
        //Add clip hole
        translate([outerWidth/2-clipWidth/2, clipOffsetHoriz, topOverlap+upperHeight+.5-clipDepth-clipExtends-clipHoleExtraVert]) clipHole();
        
    }
}

//Generate the geometry for the clip hole
module clipHole() {
    cube([clipWidth, clipThickness+clipHoleExtraHoriz, clipDepth+clipExtends+clipHoleExtraVert]);
    translate([0,-topWidth,0]) cube([clipWidth,topWidth,clipExtends+clipHoleExtraVert]);
}

//Generate the lid
module lid(wallLength) {
    //Gap between the lid walls/sides and the box
    gap = 0.5;
    
    /*
    //top (with optional text)
    translate([0,0,upperHeight]) difference() {
        cube([outerWidth, wallLength+topWidth*2, lidThickness]);
        if (genLidText) {
            translate([outerWidth/2,wallLength/2+topWidth,lidThickness-lidTextDepth]) makeLidText(lidThickness, lidTextDepth);
        }
    }
    */
    
    //sides
    translate([0,topWidth+gap,gap]) cube([outerWallThickness, wallLength-(gap*2), upperHeight+lidThickness-gap]);
    translate([outerWidth-outerWallThickness,topWidth+gap,gap]) cube([outerWallThickness, wallLength-(gap*2), upperHeight+lidThickness-gap]);
    
    //clips
    translate([clipWidth+(outerWidth-clipWidth)/2,clipOffsetHoriz+clipThickness+.1,upperHeight-clipDepth-clipExtends]) rotate([0,0,180]) lidClip();
    
    //translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-outerWallThickness-clipOffsetHoriz-clipHoleExtraHoriz,upperHeight-clipDepth-clipExtends]) lidClip();
    translate([(outerWidth-clipWidth)/2,wallLength+topWidth*2-clipOffsetHoriz-clipThickness-.1,upperHeight-clipDepth-clipExtends]) lidClip();
}

module lidClip() {
    cube([clipWidth, clipThickness, clipDepth+clipExtends]);
    translate([0,clipThickness+clipShelf,clipExtends]) rotate([180,0,0]) tPrism(clipWidth,clipShelf,clipExtends);
}

module makeLidText(lidThickness, depth) {
    rotate([0,0,-90]) linear_extrude(height=depth) {
        text(lidText, size=lidTextHeight, font="OptimusPrincepsSemiBold", halign="center", valign="center");
    }
}



