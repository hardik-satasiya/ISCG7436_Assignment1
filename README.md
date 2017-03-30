# ISCG7436_Assignment1
Assignment 1 for ISCG7436 iOS Development

## Purpose

- Draw with finger (tap and drag) on device screen.
- Draw freeform lines, straight lines, circles, Squares / Rectangles.
- Select one of a few colours, and one tool to use at a time.
- Select to clear the drawing screen. when clearing, a popup dialog allows user to confirm clearing.

## Design Patterns

Model View Controller was used.

- Shape classes for models. Enums for tools and colours. shapes could generate a UIBezierPath if requested.
- ShapeManager singleton for maintaining a list of shapes created.

- Controller was the ViewController for the main screen.
- Controller did all the drawing, tool and colour selection, and handling user input.

- View was the Scene for the above controller. 
- Includes a button bar for selecting the tool, buttons for selecting colours, trash button, and draw area.

## Additional features

- Work Universally, on iPad (Air, Pro, Mini), and iPhone (SE, 4, 5, 5s, 6, 6s, 6plus, 7, 7s, 7plus)
- Save to Photo Album. ***
- Highlighting of current selected colour.
- Undo feature.
- Drawing area, to prevent drawing over the buttons and screen margins.

## Third party libraries

None were used.

## What could be better

- Drawing area should show a border so user knows where to draw.
- Clear Screen dialog could be proper popup dialog, and disappear if user tapped outside it.
- better highlighting of colour buttons.
- a dialog showing scrollable user history, and option to undo other than last drawn image (too complex for time remaining).
- simplify the Controller. Create a Utility class to perform some of the calculations and actions.


