use <./OptimusPrinceps.ttf>
use <./OptimusPrincepsSemiBold.ttf>

bottomThickness = 1.8;
outerWallThickness = 3;
wallThickness = 1.2;
wallHeight = 70;

//slotWidth = 64;
slotWidth = 60;
cardOrSleeveHeight = 100;
slotOffset = 15;

innerWidth = slotWidth+slotOffset;
outerWidth = innerWidth + outerWallThickness*2;
upperHeight = cardOrSleeveHeight-wallHeight;

cardThickness = 0.3;
sleeveThickness = .05;
cardAdditionalThickness = 0.1;
THICK = cardThickness + sleeveThickness*2 + cardAdditionalThickness;

topChamferX = 15;
topChamferZ = 8;
topChamferEdge = 15;
topCfrX = (topChamferX <= slotOffset) ? topChamferX : slotOffset;

bottomChamferX = 2;
bottomChamferZ = 5;
bottomChamferEdge = 10;
bottomCfrX = (bottomChamferX <= slotOffset) ? bottomChamferX : slotOffset;

textTopOffset = 5;
cardTextWidth = 4.5;


lidText = "Base";
lidTextHeight = 25;
cards = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12];
titles = ["Artisan", "Bandit", "Bureaucrat", "Cellar", "Chapel", "Council Room", "Festival", "Harbinger", "Laboratory", "Library", "Market", "Merchant", "Militia", "Mine", "Moat", "Moneylender", "Poacher", "Remodel", "Sentry", "Smithy", "Throne Room", "Vassal", "Village", "Witch", "Workshop", "Gardens"];


cards2 = [60,40,30,12,16,24,12,12,30,10];
titles2 = ["Copper", "Silver", "Gold", "Platinum", "Potion", "Estate", "Duchy", "Province", "Curses", "Blank"];
cost2 = ["0", "3", "6", "9", "4", "2", "5", "8", "0"," "];

//spacer(true, 10);

//generate(cards, titles, 0, outerWallThickness-wallThickness);
generate(cards2, titles2, 0, outerWallThickness-wallThickness);
//translate([.3,.3,0]) slotF();
//translate([.3,7,0]) slotB();

module generate(cardArray, titleArray, i, offset, flip=false) {
    thickness = cardArray[i]*THICK;
    
    if (i < len(cardArray)) {
        
        if (flip) {
            
            //Slot
            translate([outerWallThickness,offset,0]) slotB(cardArray[i]);
            //Text
            makeText(titleArray, i, offset, thickness);
            
            nextOffset = offset+thickness+wallThickness;
            flip=false;
            
            generate(cardArray, titleArray, i+1, nextOffset, flip);
        } else {
            
            //Slot
            translate([outerWallThickness,offset,0]) slotF(cardArray[i]);
            //Text
            makeText(titleArray, i, offset, thickness);
            
            
            nextOffset = offset+thickness+wallThickness;
            flip=true;
            
            generate(cardArray, titleArray, i+1, nextOffset, flip);
        }
    } else { //finishings
        //offset = offset + outerWallThickness
        sides(offset);
        endTops(offset+outerWallThickness);
        translate([0,-12,wallHeight]) lid(offset+outerWallThickness);
    }
}

module sides(length=50) {
    length = length+outerWallThickness;
    cube([outerWallThickness,length,wallHeight]); //front
    translate([innerWidth+outerWallThickness,0,0]) cube([outerWallThickness,length,wallHeight]); //back
    
    translate([0,0,-bottomThickness]) cube([outerWidth,length,bottomThickness]); //floor
    
    cube([outerWidth,outerWallThickness,wallHeight]); //start side
    translate([0,length-outerWallThickness,0]) cube([outerWidth,outerWallThickness,wallHeight]); //end side
}

module makeText(textArray, i, offset, thickness) {
    centerOffset = offset+cardTextWidth+wallThickness + ((thickness-cardTextWidth)/2);
    
    translate([0, centerOffset, wallHeight-textTopOffset]) rotate([0,90,180]) linear_extrude(height=1) text(textArray[i], size=cardTextWidth, font="OptimusPrincepsSemiBold");
    //linear_extrude(height=1) text(textArray[i], size=cardTextWidth);
}

module slotF(numCards=10) {
    cube([innerWidth,wallThickness,wallHeight]);
    translate([slotWidth,wallThickness,0]) {
        spacer(false, numCards);
    }
}

module slotB(numCards=10) {
    cube([innerWidth,wallThickness,wallHeight]);
    translate([0,wallThickness,0]) {
        spacer(true, numCards);
    }
}

module spacer(back=false, numCards=10) {
    thickness = numCards * THICK;
    
    difference() {
        cube([slotOffset,thickness,wallHeight]);
        
        if (back) {
            translate([0,0,bottomChamferEdge+bottomChamferZ]) cube([slotOffset,thickness,wallHeight-topChamferEdge-bottomChamferEdge-topChamferZ-bottomChamferZ]);
            
            translate([slotOffset-bottomCfrX,0,bottomChamferEdge+bottomChamferZ]) rotate([180,0,90]) tPrism(thickness, bottomCfrX, bottomChamferZ);
            translate([slotOffset,0,wallHeight-topChamferEdge]) rotate([270,0,90]) tPrism(thickness, topChamferZ, topCfrX);
        } else {
            translate([0,0,bottomChamferEdge+bottomChamferZ]) cube([slotOffset,thickness,wallHeight-topChamferEdge-bottomChamferEdge-topChamferZ-bottomChamferZ]);
            
            //translate([bottomCfrX,0,bottomChamferEdge+bottomChamferZ]) mirror([1,0,0]) rotate([180,0,90]) tPrism(thickness, bottomCfrX, bottomChamferZ);
            translate([bottomCfrX,thickness,bottomChamferEdge+bottomChamferZ]) rotate([180,0,270]) tPrism(thickness, bottomCfrX, bottomChamferZ);
            //translate([0,0,wallHeight-topChamferEdge]) mirror([1,0,0]) rotate([270,0,90]) tPrism(thickness, topChamferZ, topCfrX);
            translate([0,thickness,wallHeight-topChamferEdge]) rotate([270,0,270]) tPrism(thickness, topChamferZ, topCfrX);
        }
        
    }
}

module tPrism(l, w, h){
       polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
       );
}

module endTops(wallLength) {
    endTopWidth = 12;
    endTopOverlap = 20;
    translate([0,-endTopWidth,wallHeight-endTopOverlap]) endTopClip(wallLength, endTopWidth);
    translate([0,wallLength+endTopWidth,wallHeight-endTopOverlap]) mirror([0,1,0]) endTopClip(wallLength, endTopWidth);
}

module endTopClip(wallLength, finalThickness) {
    difference() {
        cube([outerWidth, finalThickness, upperHeight+20]);
        translate([outerWidth,finalThickness,0]) rotate([0,0,180]) tPrism(outerWidth,12,20+upperHeight);
        translate([outerWidth/2-12/2, 4, 20+upperHeight-18]) clipHole();
        
    }
    
    
    //translate([0,wallLength+outerWallThickness,wallHeight]) cube([outerWidth, 12, cardOrSleeveHeight-wallHeight]);
}

module clipHole() {
    cube([12, 6.5, 18]);
    translate([0,-10,0]) cube([12,10,9.5]);
}

module lid(wallLength) {
    gap = 0.5;
    
    //top
    translate([0,0,upperHeight]) difference() {
        cube([outerWidth, wallLength+12+12, 4]);
        translate([outerWidth/2,wallLength/2+12,4-1.2]) makeLidText(4, 1.2);
    }
    
    //sides
    translate([0,12+gap/2,gap]) cube([outerWallThickness, wallLength-gap, upperHeight-gap]);
    translate([outerWidth-outerWallThickness,12+gap/2,gap]) cube([outerWallThickness, wallLength-gap, upperHeight-gap]);
    
    //clips
    translate([12+outerWidth/2-12/2,4,upperHeight-11.5]) rotate([0,0,180]) lidClip();
    translate([outerWidth/2-12/2,wallLength+12+12-4,upperHeight-11.5]) lidClip();
}

module lidClip() {
    tabHeight = 3;
    tabShelf = 2;
    cube([12, 2, 11.5]);
    //rotate([180,0,180]) tPrism(12,2,3);
    translate([0,2+tabShelf,tabHeight]) rotate([180,0,0]) tPrism(12,tabShelf,tabHeight);
}

module makeLidText(lidThickness, depth) {
    rotate([0,0,-90]) linear_extrude(height=depth) {
        text(lidText, size=lidTextHeight, font="OptimusPrincepsSemiBold", halign="center", valign="center");
    }
}



