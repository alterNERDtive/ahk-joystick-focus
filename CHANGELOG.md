# v0.2.0 (2021-01-20)

This release adds proper support for devices beyond just Joysticks, e.g.  
physical throttle units.

## Changed

* Now watching all available axes, not just X and Y. See below.

## Fixed

* Instead of an axis for deviation from the middle (only works with sticks, 
  really), now watching for a _change_ in axis value. (#1)

# v0.1.1 (2020-08-03)

## Fixed

* reading booleans from the .ini file “correctly” (= it works™) (#3)
* no longer force-killing tools on exit, gracefully instead (#4)

-----

# v0.1 (2020-02-08)

Initial release. Currently not working properly with throttle axes; see #1 and 
the README on how to disable the device’ axes as a workaround.
