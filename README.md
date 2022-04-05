**Currently the Thingiverse Customizer is throwing a generic "Parser error in [last line]: syntax error Can't parse file ..." error, even after I remove all the custom font imports (and references). Until I (or someone else) can figure out why you'll have to use OpenSCAD 2019.05 (https://www.openscad.org/downloads.html) to customize this.**

**Update 3/8/22:** Added box and lid STLs for **sleeved cards** in Alchemy, Dark Ages, Empires, Intrigue, Menagerie, Nocturne, Prosperity, and Renaissance thanks to card info provided by MikRED97. Also added Big Box Base box thanks to card info from MTNBW. **I have not personally verified any of these details or printed these boxes, so double-check that they look right before you print them.** Also updated the customizer file with these presets.

Based on play0r's really nice dominion box designs (https://www.thingiverse.com/thing:4696563). I love the look, but found a few areas for improvement after printing one:
- The lid slides off very easily and doesn't lock into place, so it's not very good for transport
- There's a fair amount of internal geometry that can be removed to reduce plastic and print time
- The open top and cutouts in the sides leave the cards exposed- again, not great for transport
- The slots were a bit more spacious than necessary (for my cards and sleeves), leading to excessive shifting in the box
- The whole thing would benefit from being parameterized so similar containers for other cards can be easily made


Inspired by that design, I made a similar design with the following improvements:
- Made the whole thing parameterized to a fault. Way more customization options than anyone will probably ever use
- Filled in the end walls to better protect the cards
- Maximized cutouts in the slot divider walls and offset walls without sacrificing integrity or function, resulting in about 20% less plastic use (and print time)
- Adjusted internal divider cutout size to prevent card bottoms from slipping into adjacent slots during insertion
- Designed a lid that snaps securely into place and protects the tops of the cards
- Found the (IMHO) ideal parameters for sleeved dominion cards and extrapolated that into defaults and recommendations for any card set

#### Quickstart guide and notes
0. All values are in mm
1. If one of the presets matches the card set you want to box, select that to start
2. Review and modify as needed all the values in the Required tab
    - `cards` should contain a comma-separated list of card counts per slot; the first number corresponds to the right-most slot, and the last number to the left-most slot.
    - `titles` is an optional list of labels for each card slot; should be in the same order as the `cards` array.
    - `prefix` is an option list of text to place prior to the titles; useful for metadata about the card, such as in-game cost.
    - Set the text on the lid with lidText, and decrease the lidTextHeight if the lid text is too big to fit
    - Enter the various dimensions of your cards,
    - Specify how much 'extra' room the cards should have in various dimensions. The defaults should be good if you're looking for a reasonably tight fit.
    - Adjust the dividerHeight to be about 75% of the card height;
        - Make sure that this value is less or equal to [cardOrSleeveHeight - 20] or you may have difficulty gripping the cards for removal.
3. Skim over the variables in the Optional (Basic) tab. Adjust to your preference. The defaults here have been optimized for any print with a 0.4mm nozzle and 0.2 or 0.3mm layer height.
    - I highly recommend you leave lidClipsSeparate = true. This will allow you to print the clips separately at an orientation that will make them DRASTICALLY more robust than printing them as part of the lid (where I guarantee they will break at some point). Print the separated clips at 100% infill. They can be securely attached to the lid with a generous application of superglue; make sure to orient them correctly.
4. Skip the Optional (Advanced) tab; these allow you to modify the offset wall cutouts if you need to, but you shouldn't need to.
5. Go to the Components to Generate tab to select what to generate
    - You can turn off the side labels and lid text to make the previews generate much faster
    - lidOnTop should only be used to verify a proper lid fit; do not print an STL with the lid on top
    - makeClipSupport should only be used when lidClipsSeparate is off, which is NOT recommended.
    - When everything looks good, toggle makeBox, lidOnSide, and separatedCLips one at a time to generate those STLs (also remember to turn the text back on). You can generate one STL with all of them to print at once, but I recommend printing them separately to minimize the consequences of failed prints.


#### Customization notes:
I tried to thoroughly test a wide range of reasonable input values, but you should double check that the output STL is what you expect before printing. Generate a test print with the largest and smallest card slot you'll need and make sure you like the card fit before printing a complete box.

This currently includes presets for the following sleeved card sets, using the card cost as a label prefix:
- Dominion 2e base cards
- Dominion 2e kingdom cards
- Dominion Base Card set (which includes Platinum, Potion, and Colony additions)
- Dominion Big Box base cards
- Alchemy
- Dark Ages (full set and split into 2)
- Empires (full set and split into 2)
- Intrigue (full set and split into 2)
- Menagerie (full set and split into 2)
- Nocturne (full set and split into 2)
- Prosperity
- Renaissance (full set and split into 2)
- Seaside (full set and split into 2)

NOTE: These presets assume the cards are sleeved with Mayday standard clear sleeves (0.04mm thick material) since that's what I use. Modify or remove the sleeveThickness value to match your cards.


#### Other
All included fonts are distributed under licenses that allow for free personal and commercial use.

I'm not including the font for the pictured Dominion logo because I don't have permission from RGG to distribute it, but you can grab it here after creating a free account: https://boardgamegeek.com/filepage/73273/dominion-card-icons-vector-images

This is available on Thingiverse here: https://www.thingiverse.com/thing:4720741
