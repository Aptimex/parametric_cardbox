wallThickness = 1.2;
wallHeight = 77;

slotWidth = 64;
cardOrSleeveHeight = 100;
slotOffset = 15;

cardThickness = 0.3;
sleeveThickness = .05;
cardExtraThickness = 0.1;


THICK = cardThickness + sleeveThickness*2 + cardExtraThickness;

textBottomOffset = 5;

cards = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12];

titles = ["Test1", "Test2", "Test3", "Test4", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T"];
TextWidth = 4.5;


cards2 = [60,40,30,24,12,12,30,10];

titles2 = ["Copper", "Silver", "Gold", "Estate", "Duchy", "Province", "Curse", "Blank"];

//generate(cards, titles, 0, 0.3, false);
generate(cards2, titles2, 0, 0.3, false);
//translate([.3,.3,0]) slotF();
//translate([.3,7,0]) slotB();

module generate(cardArray, titleArray, i, offset, flip) {
    thickness = cardArray[i]*THICK;
    
    if (i < len(cardArray)) {
        
        if (flip) {
            
            //Slot
            translate([.3,offset,0]) slotB(cardArray[i]);
            //Text
            makeText(titleArray, i, offset, thickness);
            
            nextOffset = offset+thickness+wallThickness;
            flip=false;
            
            generate(cardArray, titleArray, i+1, nextOffset, flip);
        } else {
            
            echo(offset);
            //Slot
            translate([.3,offset,0]) slotF(cardArray[i]);
            //Text
            makeText(titleArray, i, offset, thickness);
            
            nextOffset = offset+thickness+wallThickness;
            flip=true;
            
            generate(cardArray, titleArray, i+1, nextOffset, flip);
        }
    } else { //finishings
        walls(offset);
    }
}

module walls(length=50) {
    length = length+(1.5);
    echo(length);
    cube([1.2,length,wallHeight]); //front
    translate([81.7,0,0]) cube([1.2,length,wallHeight]); //back
    
    cube([82,length,1.8]); //floor
    
    cube([82,.3,wallHeight], center=false); //start side
    translate([0,length-1.5,0]) cube([82,1.5,wallHeight], center=false); //end side
}

module makeText(textArray, i, offset, thickness) {
    centerOffset = offset+TextWidth+wallThickness + ((thickness-TextWidth)/2);
    
    translate([0, centerOffset, wallHeight-textBottomOffset]) rotate([0,90,180]) linear_extrude(height=1) text(textArray[i], size=TextWidth);
}

module slotF(numCards=10) {
    cube([81.4,wallThickness,wallHeight]);
    translate([65.2,wallThickness,0]) {
        spacer(false, numCards);
    }
}

module slotB(numCards=10) {
    cube([81.4,wallThickness,wallHeight]);
    translate([0,wallThickness,0]) {
        spacer(true, numCards);
    }
}

module spacer(back=false, numCards=10) {
    thickness = numCards * THICK;
    difference() {
        cube([16.2,thickness,wallHeight]);
        
        if (back) {
            translate([14.2,0,15]) rotate([180,0,90]) tPrism(thickness, 2, 5);
            translate([16.2,0,68]) rotate([270,0,90]) tPrism(thickness, 8, 15);
            translate([1.2,0,15]) cube([15,thickness,45]);
        } else {
            translate([2,0,15]) mirror([1,0,0]) rotate([180,0,90]) tPrism(thickness, 2, 5);
            translate([0,0,68]) mirror([1,0,0]) rotate([270,0,90]) tPrism(thickness, 8, 15);
            translate([0,0,15]) cube([15,thickness,45]);
        }
        
    }
}

module tPrism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}