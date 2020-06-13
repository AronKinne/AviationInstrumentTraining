# Aviation Instrument Training

This application is made to train pilots instrument skills.


## Current state and future ideas

- [ ] Primary Flight Display (PFD)
    - [ ] Classic six indicators
        - [x] Attitude Indicator (ADI)
        - [x] Airspeed Indicator (ASI)
        - [x] Altimeter (ALTM)
        - [x] Vertical Speed Indicator (VSI)
        - [ ] Horizontal Situation Indicator
        - [ ] Slip Skid Indicator
    - [x] controllable by mouse with easy physics
    - [x] JSON implementation
        - [ ] customizable layout for the whole Training Evironment
        - [x] specific values for different aircrafts
        - [x] customizable layout for the PFD
- [ ] Training Environment
    - [ ] map with locations of aircraft and radio navigation systems
    - [ ] Radio Navigation Systems
        - [ ] VOR
        - [ ] NDB

Feel free to suggest further ideas by creating a [new issue](https://github.com/AronKinne/AviationInstrumentTraining/issues/new/choose).


## How to create a new JSON File

In the following JSON templates are sometimes keys, starting with `_`.
Those keys are not used, but might be helpful for comments or links.

### <a name="json_aircraft"></a> Aircraft

Aircraft JSON files should be placed in the `data/aircraft` folder.
To actually use a particular file, you have to change the path manually in the code (this might be changed soon).
You will find that particular line in [AviationInstrumentTraining.pde](AviationInstrumentTraining.pde) which is also the main file:

```java
ac = new Aircraft("json path");
```

To create a new aircraft, use the following template:

```JSON
{
    "name": "Aircraft name",
    "pfdlayout": "path to the used PFD layout",
    "axes": {
        "maxPitchVel": 1,
        "maxRollVel": 1,
        "maxYaw": 1
    },
    "_speeds": "(comment) can be used to store a link as reference for the values",
    "speeds": {
        "vs0": 100,
        "vs1": 150,
        "vfe": 200,
        "vno": 250,
        "vne": 300,
        "maxTurnSpeed": 1
    }
}
```

Explanation:

Key | Description | Example | Used
-|-|-|-
name|The name of the aircraft|Airbus A320, Boeing 737, Cessna 172|no
pfdlayout|The path to the PFD layout used for this aircraft|`data/pfdlayout/g1000.json`|yes
axes|The maximum pitch and roll speed such as maximum yaw for mouse control|`0.3`, `1`, ...|yes
speeds|The speed values of the certain aircraft in kts|`87.5`, `150`, ...|yes
maxTurnSpeed|The maximum turn speed of the aircraft|`0.5`, `2`, ...|yes


### PFD Layout

Those files are used to customize the layout of the PFD.
Place a new file in the folder `data/pfdlayout`.
To use a layout for a certain aircraft, put the path of the layout file in the JSON file of the aircraft ([see above](#json_aircraft)).

The most values in this file are position or size values.
Every value is relative to its parent.
The position values are always the location of the top-left corner.
To get the values, I suggest to find an appropriate image of the PFD use it with an [online ruler tool](https://www.rapidtables.com/web/tools/pixel-ruler.html).
Then you can just input every integer or floating point number.

To create a new PFD layout, use the following template:

```JSON
{
    "name": "Layout name",
    "_img": "(comment) can be used to store the link of an image, which was used with ruler",
    "layout": {
        "width": 0,
        "height": 0,
        "background": [0, 0, 0, 0],
        "adi": {
            "x": 0,
            "y": 0,
            "width": 0,
            "height": 0,
            "pivotX": 0,
            "pivotY": 0,
            "degInPx": 0 
        },
        "asi": {
            "x": 0,
            "y": 0,
            "width": 0,
            "height": 0,
            "pointerY": 0,
            "numberStep": 0,
            "ktInPx": 0
        },
        "altm": {
            "x": 0,
            "y": 0,
            "width": 0,
            "height": 0,
            "pointerY": 0,
            "ftInPx": 0
        },
        "vsi": {
            "x": 0,
            "y": 0,
            "width": 0,
            "height": 0,
            "pointerW": 0,
            "fpmInPx": 0
        }
    }
}
```

Explanation:

Key|Description|Optional|Default
-|-|-|-
name|The name of the layout|yes|-
width, height|The size of the PFD|no|-
background|The background color, which might be visible. Format: `[R, G, B, ALPHA]`. Every value ranges from `0` to `255`.|yes|`[0, 0, 0, 255]`
adi: x, y, width, height|The position and size of the ADI|yes|`0, 0, layout width, layout height`
adi: pivotX, pivotY|The position of the center point of the ADI|no|-
adi: degInPx|Used for the scala. `1 degree = <degInPx> pixels`|no|-
other indicators: x, y, width, height|The position and size of the indicator|no|-
asi and altm: pointerY|The y-position of the pointer|no|-
asi: numberStep|The step size of the numbers on the scala|yes|`10`
asi: ktInPx|Used for the scala. `1 knot = <ktInPx> pixels`|no|-
altm: ftInPx|Used for the scala. `1 foot = <ftInPx> pixels`|no|-
vsi: pointerW|The width of the pointer|no|-
vsi: fpmInPx|Used for the scala. `1 foot per minute = <fpmInPx> pixels`|no|-


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details